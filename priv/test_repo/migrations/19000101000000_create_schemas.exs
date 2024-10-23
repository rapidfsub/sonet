defmodule SonetLib.TestRepo.Migrations.CreateSchemas do
  use Ecto.Migration

  @schema [
    "seven_eleven"
  ]
  def up do
    for schema <- @schema do
      execute("CREATE SCHEMA " <> schema)
    end
  end
end
