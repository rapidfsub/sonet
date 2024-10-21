defmodule SonetLib.Pipe do
  defmacro last_arg ~> {name, meta, args} do
    {name, meta, List.insert_at(args, -1, last_arg)}
  end
end
