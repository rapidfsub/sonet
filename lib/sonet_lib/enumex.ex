defmodule SonetLib.Enumex do
  use SonetLib.Prelude

  @doc ~S"""
  ## Examples

      iex> Enumex.deep_delete_key(%{b: [a: 1, b: 2, a: 3], c: [a: 1, b: 2, a: 3]}, :a)
      %{b: [b: 2], c: [b: 2]}

      iex> Enumex.deep_delete_key([%{a: 1, b: 2}, %{a: 1, b: 2}], :a)
      [%{b: 2}, %{b: 2}]

  """
  def deep_delete_key(%{} = map, key) do
    for {k, v} <- Map.delete(map, key), into: %{} do
      {k, deep_delete_key(v, key)}
    end
  end

  def deep_delete_key([{k, _v} | _] = keywords, key) when is_atom(k) do
    for {k, v} <- Keyword.delete(keywords, key) do
      {k, deep_delete_key(v, key)}
    end
  end

  def deep_delete_key(list, key) when is_list(list) do
    for value <- list do
      deep_delete_key(value, key)
    end
  end

  def deep_delete_key(value, _key) do
    value
  end

  @doc ~S"""
  ## Examples

      iex> Enumex.deep_map_key(%{b: [a: 1, b: 2, a: 3], c: [a: 1, b: 2, a: 3]}, &to_string/1)
      %{"b" => [a: 1, b: 2, a: 3], "c" => [a: 1, b: 2, a: 3]}

      iex> Enumex.deep_map_key([a: 1, b: 2, c: %{a: 1, b: 2, c: 3}], &to_string/1)
      [a: 1, b: 2, c: %{"a" => 1, "b" => 2, "c" => 3}]

      iex> Enumex.deep_map_key([%{a: 1, b: 2}, %{a: 1, b: 2}], &to_string/1)
      [%{"a" => 1, "b" => 2}, %{"a" => 1, "b" => 2}]

  """
  def deep_map_key(%{} = map, fun) do
    for {k, v} <- map, into: %{} do
      {fun.(k), deep_map_key(v, fun)}
    end
  end

  def deep_map_key([{k, _v} | _] = keywords, fun) when is_atom(k) do
    for {k, v} <- keywords do
      {k, deep_map_key(v, fun)}
    end
  end

  def deep_map_key(list, fun) when is_list(list) do
    for value <- list do
      deep_map_key(value, fun)
    end
  end

  def deep_map_key(value, _fun) do
    value
  end
end
