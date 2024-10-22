defmodule SonetLib.Delegate do
  defmacro __using__(opts) do
    for {module, funs} <- opts, {sig, opts, doc} <- extract(module, funs) do
      quote do
        @doc unquote(doc)
        defdelegate unquote(sig), unquote(opts)
      end
    end
  end

  defp extract(module, funs) do
    {module, _} = Code.eval_quoted(module)
    {:docs_v1, _annotation, :elixir, _fmt, _doc, _meta, docs} = Code.fetch_docs(module)

    Enum.flat_map(funs, fn {fun, opts} ->
      {arity, deleg_opts} =
        case opts do
          arity when is_integer(arity) -> [arity: arity]
          opts when is_list(opts) -> opts
        end
        |> Keyword.put_new(:to, module)
        |> Keyword.pop(:arity)

      fun_name = Keyword.get(deleg_opts, :as, fun)

      [_ | _] =
        Enum.find_value(docs, fn
          {{:function, ^fun_name, ^arity}, _annotation, signature, docs, meta} ->
            sig = Enum.fetch!(signature, 0)
            doc = Map.fetch!(docs, "en")
            {_fun_name, fun_meta, args} = Code.string_to_quoted!(sig)

            args =
              Enum.map(args, fn
                {:\\, _meta, [arg, _default]} -> arg
                arg -> arg
              end)

            defaults = meta[:defaults] || 0

            for a <- (arity - defaults)..arity//1 do
              {{fun, fun_meta, Enum.take(args, a)}, deleg_opts, doc}
            end

          _ ->
            nil
        end)
    end)
  end
end
