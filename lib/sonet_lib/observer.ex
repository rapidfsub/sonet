defmodule SonetLib.Observer do
  def start() do
    Mix.ensure_application!(:observer)
    # call apply to avoid warning
    apply(:observer, :start, [])
  end
end
