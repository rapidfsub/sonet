defmodule SonetLib.Enumex do
  use SonetLib.Prelude

  @doc ~S"""
  ## Examples

      iex> deep_delete_key(%{b: [a: 1, b: 2, a: 3], c: [a: 1, b: 2, a: 3]}, :a)
      %{b: [b: 2], c: [b: 2]}

      iex> deep_delete_key([%{a: 1, b: 2}, %{a: 1, b: 2}], :a)
      [%{b: 2}, %{b: 2}]

  """
  def deep_delete_key(%{} = map, key) do
    Map.delete(map, key)
    |> Map.new(fn {k, v} ->
      {k, deep_delete_key(v, key)}
    end)
  end

  def deep_delete_key([{k, _v} | _] = keywords, key) when is_atom(k) do
    Keyword.delete(keywords, key)
    |> Keyword.new(fn {k, v} ->
      {k, deep_delete_key(v, key)}
    end)
  end

  def deep_delete_key(list, key) when is_list(list) do
    Enum.map(list, &deep_delete_key(&1, key))
  end

  def deep_delete_key(value, _key) do
    value
  end
end
