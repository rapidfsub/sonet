defmodule SonetLib.DelegateTest do
  use SonetLib.DataCase

  test "define delegates" do
    assert {:docs_v1, _annotation, :elixir, "text/markdown", %{}, %{}, docs} =
             Code.fetch_docs(SonetLib.MyEnum)

    assert_value Enum.map(docs, &Tuple.delete_at(&1, 1)) ==
                   [
                     {{:function, :max, 1}, ["max(enumerable)"],
                      %{
                        "en" =>
                          "Returns the maximal element in the `enumerable` according\nto Erlang's term ordering.\n\nBy default, the comparison is done with the `>=` sorter function.\nIf multiple elements are considered maximal, the first one that\nwas found is returned. If you want the last element considered\nmaximal to be returned, the sorter function should not return true\nfor equal elements.\n\nIf the enumerable is empty, the provided `empty_fallback` is called.\nThe default `empty_fallback` raises `Enum.EmptyError`.\n\n## Examples\n\n    iex> Enum.max([1, 2, 3])\n    3\n\nThe fact this function uses Erlang's term ordering means that the comparison\nis structural and not semantic. For example:\n\n    iex> Enum.max([~D[2017-03-31], ~D[2017-04-01]])\n    ~D[2017-03-31]\n\nIn the example above, `max/2` returned March 31st instead of April 1st\nbecause the structural comparison compares the day before the year.\nFor this reason, most structs provide a \"compare\" function, such as\n`Date.compare/2`, which receives two structs and returns `:lt` (less-than),\n`:eq` (equal to), and `:gt` (greater-than). If you pass a module as the\nsorting function, Elixir will automatically use the `compare/2` function\nof said module:\n\n    iex> Enum.max([~D[2017-03-31], ~D[2017-04-01]], Date)\n    ~D[2017-04-01]\n\nFinally, if you don't want to raise on empty enumerables, you can pass\nthe empty fallback:\n\n    iex> Enum.max([], &>=/2, fn -> 0 end)\n    0\n\n"
                      }, %{delegate_to: {Enum, :max, 1}}},
                     {{:function, :max, 2}, ["max(enumerable, sorter)"],
                      %{
                        "en" =>
                          "Returns the maximal element in the `enumerable` according\nto Erlang's term ordering.\n\nBy default, the comparison is done with the `>=` sorter function.\nIf multiple elements are considered maximal, the first one that\nwas found is returned. If you want the last element considered\nmaximal to be returned, the sorter function should not return true\nfor equal elements.\n\nIf the enumerable is empty, the provided `empty_fallback` is called.\nThe default `empty_fallback` raises `Enum.EmptyError`.\n\n## Examples\n\n    iex> Enum.max([1, 2, 3])\n    3\n\nThe fact this function uses Erlang's term ordering means that the comparison\nis structural and not semantic. For example:\n\n    iex> Enum.max([~D[2017-03-31], ~D[2017-04-01]])\n    ~D[2017-03-31]\n\nIn the example above, `max/2` returned March 31st instead of April 1st\nbecause the structural comparison compares the day before the year.\nFor this reason, most structs provide a \"compare\" function, such as\n`Date.compare/2`, which receives two structs and returns `:lt` (less-than),\n`:eq` (equal to), and `:gt` (greater-than). If you pass a module as the\nsorting function, Elixir will automatically use the `compare/2` function\nof said module:\n\n    iex> Enum.max([~D[2017-03-31], ~D[2017-04-01]], Date)\n    ~D[2017-04-01]\n\nFinally, if you don't want to raise on empty enumerables, you can pass\nthe empty fallback:\n\n    iex> Enum.max([], &>=/2, fn -> 0 end)\n    0\n\n"
                      }, %{delegate_to: {Enum, :max, 2}}},
                     {{:function, :max, 3}, ["max(enumerable, sorter, empty_fallback)"],
                      %{
                        "en" =>
                          "Returns the maximal element in the `enumerable` according\nto Erlang's term ordering.\n\nBy default, the comparison is done with the `>=` sorter function.\nIf multiple elements are considered maximal, the first one that\nwas found is returned. If you want the last element considered\nmaximal to be returned, the sorter function should not return true\nfor equal elements.\n\nIf the enumerable is empty, the provided `empty_fallback` is called.\nThe default `empty_fallback` raises `Enum.EmptyError`.\n\n## Examples\n\n    iex> Enum.max([1, 2, 3])\n    3\n\nThe fact this function uses Erlang's term ordering means that the comparison\nis structural and not semantic. For example:\n\n    iex> Enum.max([~D[2017-03-31], ~D[2017-04-01]])\n    ~D[2017-03-31]\n\nIn the example above, `max/2` returned March 31st instead of April 1st\nbecause the structural comparison compares the day before the year.\nFor this reason, most structs provide a \"compare\" function, such as\n`Date.compare/2`, which receives two structs and returns `:lt` (less-than),\n`:eq` (equal to), and `:gt` (greater-than). If you pass a module as the\nsorting function, Elixir will automatically use the `compare/2` function\nof said module:\n\n    iex> Enum.max([~D[2017-03-31], ~D[2017-04-01]], Date)\n    ~D[2017-04-01]\n\nFinally, if you don't want to raise on empty enumerables, you can pass\nthe empty fallback:\n\n    iex> Enum.max([], &>=/2, fn -> 0 end)\n    0\n\n"
                      }, %{delegate_to: {Enum, :max, 3}}}
                   ]
  end

  test "error if not existing function is passed" do
    assert_raise MatchError, fn ->
      defmodule MyEnum do
        use Delegate, [{Enum, [not_existing_fun: 0]}]
      end
    end
  end
end
