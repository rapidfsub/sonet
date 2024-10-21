defmodule Sonet.Identity.Account.Actions do
  use Sonet.Prelude
  use Spark.Dsl.Fragment, of: Ash.Resource

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    create :register_with_password do
      description "Register a new user with a email and password."
      accept [:email, :username, :bio]

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      # Hashes the provided password
      change AshAuthentication.Strategy.Password.HashPasswordChange

      # Generates an authentication token for the user
      change AshAuthentication.GenerateTokenChange

      # validates that the password matches the confirmation
      validate AshAuthentication.Strategy.Password.PasswordConfirmationValidation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end
    end

    action :request_password_reset do
      description "Send password reset instructions to a user if they exist."

      argument :email, :ci_string do
        allow_nil? false
      end

      # creates a reset token and invokes the relevant senders
      run {AshAuthentication.Strategy.Password.RequestPasswordReset, action: :get_by_email}
    end

    update :reset_password do
      argument :reset_token, :string do
        allow_nil? false
        sensitive? true
      end

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      # validates the provided reset token
      validate AshAuthentication.Strategy.Password.ResetTokenValidation

      # validates that the password matches the confirmation
      validate AshAuthentication.Strategy.Password.PasswordConfirmationValidation

      # Hashes the provided password
      change AshAuthentication.Strategy.Password.HashPasswordChange

      # Generates an authentication token for the user
      change AshAuthentication.GenerateTokenChange
    end

    update :update_current_account do
      accept [:username, :bio]
    end

    update :follow do
      argument :is_following, :boolean, allow_nil?: false
      argument :follower_id, :string, public?: false
      require_atomic? false

      change fn changeset, ctx ->
        Ashex.get_actor_id(ctx)
        ~> Changeset.set_argument(changeset, :follower_id)
      end

      change manage_relationship(:follower_id, :followers, on_lookup: :relate, value_is_key: :id),
        where: argument_equals(:is_following, true)

      change manage_relationship(:follower_id, :followers, on_match: :unrelate, value_is_key: :id),
        where: argument_equals(:is_following, false)

      change load([:is_following])
    end
  end
end
