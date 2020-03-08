defmodule ElixirPython do
  alias ElixirPython.Helper

  def encode(data) do
    call_python(:encoder, :encode, [data])
  end

  def add(a, b) do
    call_python(:adder, :add, [a, b])
  end

  def divide(a, b) do
    try do
      call_python(:divider, :divide, [a, b])
    rescue
      e in ErlangError -> IO.inspect(e)
    end
  end

  defp default_instance() do
    # Load all modules in our priv/python directory
    path = Path.join([:code.priv_dir(:elixir_python), "python"])
    Helper.python_instance(to_charlist(path))
  end

  # wrapper function to call python functions using
  # default python instance
  defp call_python(module, function, args \\ []) do
    pid = default_instance()

    Helper.call_python(pid, module, function, args)
  end
end
