defmodule SonetLib.Enumex do
  use SonetLib.Prelude

  @doc ~S"""
  ## Examples

      iex> Enumex.deep_delete_keys(%{b: [a: 1, b: 2, a: 3], c: [a: 1, b: 2, a: 3]}, :a)
      %{b: [b: 2], c: [b: 2]}

      iex> Enumex.deep_delete_keys([%{a: 1, b: 2}, %{a: 1, b: 2}], :a)
      [%{b: 2}, %{b: 2}]

  """
  def deep_delete_keys(%{} = map, key) do
    for {k, v} <- Map.delete(map, key), into: %{} do
      {k, deep_delete_keys(v, key)}
    end
  end

  def deep_delete_keys([{k, _v} | _] = keywords, key) when is_atom(k) do
    for {k, v} <- Keyword.delete(keywords, key) do
      {k, deep_delete_keys(v, key)}
    end
  end

  def deep_delete_keys(list, key) when is_list(list) do
    for value <- list do
      deep_delete_keys(value, key)
    end
  end

  def deep_delete_keys(value, _key) do
    value
  end

  @doc ~S"""
  ## Examples

      iex> Enumex.deep_map_keys(%{b: [a: 1, b: 2, a: 3], c: [a: 1, b: 2, a: 3]}, &to_string/1)
      %{"b" => [a: 1, b: 2, a: 3], "c" => [a: 1, b: 2, a: 3]}

      iex> Enumex.deep_map_keys([a: 1, b: 2, c: %{a: 1, b: 2, c: 3}], &to_string/1)
      [a: 1, b: 2, c: %{"a" => 1, "b" => 2, "c" => 3}]

      iex> Enumex.deep_map_keys([%{a: 1, b: 2}, %{a: 1, b: 2}], &to_string/1)
      [%{"a" => 1, "b" => 2}, %{"a" => 1, "b" => 2}]

  """
  def deep_map_keys(%{} = map, fun) do
    for {k, v} <- map, into: %{} do
      {fun.(k), deep_map_keys(v, fun)}
    end
  end

  def deep_map_keys([{k, _v} | _] = keywords, fun) when is_atom(k) do
    for {k, v} <- keywords do
      {k, deep_map_keys(v, fun)}
    end
  end

  def deep_map_keys(list, fun) when is_list(list) do
    for value <- list do
      deep_map_keys(value, fun)
    end
  end

  def deep_map_keys(value, _fun) do
    value
  end

  @doc ~S"""
  ## Examples

      iex> Enumex.keys_to_string(%{b: [a: 1, b: 2, a: 3], c: [a: 1, b: 2, a: 3]})
      %{"b" => [a: 1, b: 2, a: 3], "c" => [a: 1, b: 2, a: 3]}

      iex> Enumex.keys_to_string([a: 1, b: 2, c: %{a: 1, b: 2, c: 3}])
      [a: 1, b: 2, c: %{"a" => 1, "b" => 2, "c" => 3}]

      iex> Enumex.keys_to_string([%{a: 1, b: 2}, %{a: 1, b: 2}])
      [%{"a" => 1, "b" => 2}, %{"a" => 1, "b" => 2}]

  """
  def keys_to_string(value) do
    deep_map_keys(value, &to_string/1)
  end
end
