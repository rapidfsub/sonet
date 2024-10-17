defmodule SonetLib.Delegate do
  defmacro __using__(opts) do
    for {module, funs} <- opts, {sig, doc} <- fetch_docs(module, funs) do
      quote do
        @doc unquote(doc)
        defdelegate unquote(sig), to: unquote(module)
      end
    end
  end

  defp fetch_docs(module, funs) do
    {module, _} = Code.eval_quoted(module)
    {:docs_v1, _annotation, :elixir, _fmt, _doc, _meta, docs} = Code.fetch_docs(module)

    Enum.flat_map(funs, fn {fun, arity} ->
      Enum.find_value(docs, [], fn
        {{:function, ^fun, ^arity}, _annotation, signature, docs, meta} ->
          sig = Enum.fetch!(signature, 0)
          doc = Map.fetch!(docs, "en")
          {fun_name, fun_meta, args} = Code.string_to_quoted!(sig)

          args =
            Enum.map(args, fn
              {:\\, _meta, [arg, _default]} -> arg
              arg -> arg
            end)

          defaults = meta[:defaults] || 0

          for a <- (arity - defaults)..arity//1 do
            {{fun_name, fun_meta, Enum.take(args, a)}, doc}
          end

        _ ->
          nil
      end)
    end)
  end
end
