defmodule Sonet.Forum do
  use Sonet.Prelude

  use Ash.Domain,
    extensions: [
      AshJsonApi.Domain
    ]

  json_api do
    routes do
      base_route "/article", Forum.Article do
        post :create
      end
    end
  end

  resources do
    resource Forum.Article
  end
end
