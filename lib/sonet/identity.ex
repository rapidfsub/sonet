defmodule Sonet.Identity do
  use Sonet.Prelude

  use Ash.Domain,
    extensions: [
      AshJsonApi.Domain
    ]

  json_api do
    routes do
      base_route "/user", Identity.Account do
        get :get_current_account, route: "/"
        get :read, route: "/:username", name: "/user/:username"
        post :register_with_password

        post :sign_in_with_password do
          route "/login"

          metadata fn _subject, user, _request ->
            %{token: user.__metadata__.token}
          end
        end

        patch :update_current_account, route: "/", read_action: :get_current_account
      end
    end
  end

  resources do
    resource Identity.Token
    resource Identity.Account
  end
end
