defmodule HookTest do
  use ExUnit.Case
  doctest Hook

  test "greets the world" do
    assert Hook.hello() == :world
  end
end
