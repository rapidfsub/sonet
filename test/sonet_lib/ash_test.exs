defmodule SonetLib.AshTest do
  use Sonet.DataCase

  describe "changes" do
    test "local changes precede global changes" do
      assert_value SonetLib.Forum.Article
                   |> Ash.Changeset.for_create(:test)
                   |> Ash.create!()
                   |> Map.take([:title]) == %{title: "Global"}
    end
  end
end
