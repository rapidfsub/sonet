defmodule SonetLib.Delegate do
  defmacro __using__(opts) do
    for {module, funs} <- opts, {sig, arity, doc} <- fetch_docs(module, funs) do
      define_delegate(module, sig, arity, doc)
    end
  end

  defp fetch_docs(module, funs) do
    {module, _} = Code.eval_quoted(module)
    {:docs_v1, _annotation, :elixir, _fmt, _doc, _meta, docs} = Code.fetch_docs(module)

    Enum.flat_map(funs, fn {fun, arity} ->
      Enum.find_value(docs, [], fn
        {{:function, ^fun, ^arity}, _annotation, [sig], %{"en" => doc}, meta} ->
          defaults = meta[:defaults] || 0

          for a <- (arity - defaults)..arity//1 do
            {sig, a, doc}
          end

        _ ->
          nil
      end)
    end)
  end

  defp define_delegate(module, sig, arity, doc) do
    {name, meta, args} = Code.string_to_quoted!(sig)

    args =
      args
      |> Enum.map(fn
        {:\\, _meta, [arg, _default]} -> arg
        arg -> arg
      end)
      |> Enum.take(arity)

    quote do
      @doc unquote(doc)
      defdelegate unquote({name, meta, args}), to: unquote(module)
    end
  end
end
