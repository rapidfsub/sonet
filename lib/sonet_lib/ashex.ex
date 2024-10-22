defmodule SonetLib.Ashex do
  use SonetLib.Prelude

  use Delegate, [
    {Ash,
     [
       create: 3,
       create!: 3,
       destroy: 2,
       destroy!: 2,
       get: 3,
       get!: 3,
       load: 3,
       load!: 3,
       read: 2,
       read!: 2,
       read_one: 2,
       read_one!: 2,
       update: 3,
       update!: 3
     ]},
    {Ash.Context,
     [
       to_opts: 2
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

  def run_create(initial, action, opts1 \\ [], opts2 \\ []) do
    {params, opts} = pop_params(opts1, opts2)
    Changeset.for_create(initial, action, params, opts) |> create()
  end

  def run_create!(initial, action, opts1 \\ [], opts2 \\ []) do
    {params, opts} = pop_params(opts1, opts2)
    Changeset.for_create(initial, action, params, opts) |> create!()
  end

  def run_update(initial, action, opts1 \\ [], opts2 \\ []) do
    {params, opts} = pop_params(opts1, opts2)
    Changeset.for_update(initial, action, params, opts) |> update()
  end

  def run_update!(initial, action, opts1 \\ [], opts2 \\ []) do
    {params, opts} = pop_params(opts1, opts2)
    Changeset.for_update(initial, action, params, opts) |> update!()
  end

  defp pop_params(opts1, opts2) do
    Keyword.merge(opts1, opts2) |> Keyword.pop(:params, %{})
  end

  def set_data_and_read(query, action_name, data, opts1 \\ [], opts2 \\ []) do
    do_set_data_and_read(query, action_name, data, opts1, opts2) |> read()
  end

  def set_data_and_read!(query, action_name, data, opts1 \\ [], opts2 \\ []) do
    do_set_data_and_read(query, action_name, data, opts1, opts2) |> read!()
  end

  def set_data_and_read_one(query, action_name, data, opts1 \\ [], opts2 \\ []) do
    do_set_data_and_read(query, action_name, data, opts1, opts2) |> read_one()
  end

  def set_data_and_read_one!(query, action_name, data, opts1 \\ [], opts2 \\ []) do
    do_set_data_and_read(query, action_name, data, opts1, opts2) |> read_one!()
  end

  defp do_set_data_and_read(query, action_name, data, opts1, opts2) do
    {params, opts} = pop_params(opts1, opts2)
    Query.for_read(query, action_name, params, opts) |> Ash.DataLayer.Simple.set_data(data)
  end

  def get_actor(ctx) do
    to_opts(ctx)[:actor]
  end

  def get_actor_id(ctx) do
    get_in(get_actor(ctx).id)
  end

  def run_read_one(query, action_name, opts1 \\ [], opts2 \\ []) do
    {params, opts} = pop_params(opts1, opts2)
    Query.for_read(query, action_name, params, opts) |> read_one()
  end

  def run_read_one!(query, action_name, opts1 \\ [], opts2 \\ []) do
    {params, opts} = pop_params(opts1, opts2)
    Query.for_read(query, action_name, params, opts) |> read_one!()
  end
end
