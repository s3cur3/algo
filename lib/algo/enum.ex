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

  @doc """
  Maps over an enumerable, stopping if an `:error` result is encountered.

  Examples:

    iex> Enum.map_while_ok([1, 2, 3], fn x -> {:ok, x * 2} end)
    {:ok, [2, 4, 6]}

    iex> Enum.map_while_ok([1, 2, 3], fn x -> if x == 2, do: {:error, :oh_no}, else: {:ok, x} end)
    {:error, :oh_no}

    iex> Enum.map_while_ok([1, 2, 3], fn x -> if x == 2, do: :error, else: {:ok, x} end)
    :error

    iex> Enum.map_while_ok([1, 2, 3], fn _ -> :ok end)
    {:ok, [:ok, :ok, :ok]}

    iex> Enum.map_while_ok([], fn _ -> :error end)
    {:ok, []}
  """
  @spec map_while_ok(Enumerable.t(), (any -> {:ok, any} | {:error, any} | :ok | :error)) ::
          {:ok, list(any)} | {:error, any} | :error
  def map_while_ok(enum, fun) do
    enum
    |> Enum.reduce_while({:ok, []}, fn item, {:ok, acc} ->
      case fun.(item) do
        {:ok, result} -> {:cont, {:ok, [result | acc]}}
        :ok -> {:cont, {:ok, [:ok | acc]}}
        {:error, error} -> {:halt, {:error, error}}
        :error -> {:halt, :error}
      end
    end)
    |> case do
      {:ok, results} -> {:ok, Enum.reverse(results)}
      error -> error
    end
  end
end
