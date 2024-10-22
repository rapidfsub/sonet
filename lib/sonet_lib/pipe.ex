defmodule SonetLib.Pipe do
  defmacro last_arg ~> atom when is_atom(atom) do
    {atom, last_arg}
  end

  defmacro last_arg ~> {name, meta, args} do
    {name, meta, List.insert_at(args, -1, last_arg)}
  end
end
