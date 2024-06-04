defmodule Algo do
  @moduledoc """
  A wrapper for the various Algo modules.

  Clients are encouraged to simply `use Algo` to alias all the submodules.
  Since Algo exposes all the functions from the standard library's corresponding
  modules (e.g., `Algo.Enum` exposes all the functions from `Enum`) and never
  conflicts with them, clients don't have to remember whether a function comes
  from the standard library or Algo.
  """

  defmacro __using__(_opts) do
    quote do
      alias Algo.Enum
    end
  end
end
