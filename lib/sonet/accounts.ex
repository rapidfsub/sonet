defmodule Sonet.Accounts do
  use Ash.Domain,
    extensions: [
      AshJsonApi.Domain
    ]

  json_api do
    routes do
      base_route "/user", Sonet.Accounts.User do
        post :sign_in_with_password do
          route "/login"

          metadata fn _subject, user, _request ->
            %{token: user.__metadata__.token}
          end
        end

        post :register_with_password
      end
    end
  end

  resources do
    resource Sonet.Accounts.Token
    resource Sonet.Accounts.User
  end
end
