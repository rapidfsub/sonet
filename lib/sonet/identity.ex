defmodule Sonet.Identity do
  use Sonet.Prelude

  use Ash.Domain,
    extensions: [
      AshJsonApi.Domain
    ]

  json_api do
    routes do
      base_route "/user", Identity.User do
        post :sign_in_with_password do
          route "/login"

          metadata fn _subject, user, _request ->
            %{token: user.__metadata__.token}
          end
        end

        post :register_with_password
        get :get_current_user, route: "/"
        patch :update_current_user, route: "/", read_action: :get_current_user
        get :read, name: "/user/:username", route: "/:username"
      end
    end
  end

  resources do
    resource Identity.Token
    resource Identity.User
  end
end
