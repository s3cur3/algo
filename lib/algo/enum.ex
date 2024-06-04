defmodule Algo.Enum do
  @moduledoc """
  Utilities for working with enumerables.

  This module exposes all the functions from the standard library's `Enum` module,
  plus more.
  """
  use Algo.Internal.Delegate,
    modules: [Enum],
    exclude_mfa: [
      # Exclude deprecated functions to avoid generating compile warnings
      {Enum, :chunk, 2},
      {Enum, :chunk, 3},
      {Enum, :chunk, 4},
      {Enum, :filter_map, 3},
      {Enum, :partition, 2},
      {Enum, :uniq, 2}
    ]

  @spec ids(Enumerable.t()) :: list(any)
  def ids(enum) do
    Enum.map(enum, & &1.id)
  end

  @doc """
  True if any of the maps/structs within the enum have an `id` field that matches the given id.
  """
  @spec any_id?(Enumerable.t(), any) :: boolean
  def any_id?(enum, id) do
    Enum.any?(enum, &(&1.id == id))
  end
end
