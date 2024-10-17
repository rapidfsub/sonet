defmodule SonetLib.Ashex do
  use SonetLib.Prelude

  use Delegate, [
    {Ash,
     [
       create: 3,
       create!: 3,
       read: 2,
       read!: 2,
       load!: 3
     ]},
    {Ash.DataLayer.Simple,
     [
       set_data: 2
     ]},
    {Ash.Seed,
     [
       seed!: 1,
       seed!: 3
     ]}
  ]

  def run_create(initial, action, params \\ %{}) do
    Changeset.for_create(initial, action, params) |> create()
  end

  def run_create!(initial, action, params \\ %{}) do
    Changeset.for_create(initial, action, params) |> create!()
  end

  def set_data_and_read(query, action_name, data, args \\ %{}, opts \\ []) do
    query
    |> Query.for_read(action_name, args, opts)
    |> Ash.DataLayer.Simple.set_data(data)
    |> read()
  end

  def set_data_and_read!(query, action_name, data, args \\ %{}, opts \\ []) do
    query
    |> Query.for_read(action_name, args, opts)
    |> Ash.DataLayer.Simple.set_data(data)
    |> read!()
  end
end
