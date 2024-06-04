defmodule Algo.EnumTest do
  use ExUnit.Case, async: true
  use Algo

  doctest Algo.Enum

  test "delegates to built-in Enum module" do
    assert Enum.any?([false, true, false, false])
    refute Enum.all?([false, true, false, false])
  end
end
