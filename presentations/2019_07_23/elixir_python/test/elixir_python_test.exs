defmodule ElixirPythonTest do
  use ExUnit.Case
  doctest ElixirPython

  test "greets the world" do
    assert ElixirPython.hello() == :world
  end
end
