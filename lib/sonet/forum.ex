defmodule Sonet.Forum do
  use Sonet.Prelude

  use Ash.Domain,
    extensions: [
      AshJsonApi.Domain
    ]

  resources do
    resource Forum.Article
  end
end
