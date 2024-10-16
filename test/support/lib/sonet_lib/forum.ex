defmodule SonetLib.Forum do
  use Ash.Domain

  resources do
    resource SonetLib.Forum.Article
  end
end
