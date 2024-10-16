defmodule SonetLib.Forum.Article do
  use Ash.Resource,
    domain: SonetLib.Forum

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    create :test do
      change set_attribute(:title, "Local")
    end
  end

  changes do
    change set_attribute(:title, "Global")
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
  end
end
