defmodule Algo.Internal.Delegate do
  @moduledoc false

  # A utility for delegating all functions from a list of provided modules.
  # This lets our clients do things like alias Algo.Enum and have all the
  # standard library's Enum functions available as well.

  defmacro __using__(opts) do
    opts = Keyword.validate!(opts, modules: [], exclude_mfa: [])

    modules =
      for {_, _, full_module_path} <- opts[:modules] do
        Module.safe_concat(full_module_path)
      end

    exclude_mfa =
      for {_, _, [{_, _, full_module_path}, fun, arity]} <- opts[:exclude_mfa] do
        {Module.safe_concat(full_module_path), fun, arity}
      end

    for module <- modules, {fun, arity} <- module.__info__(:functions) do
      unless Enum.member?(exclude_mfa, {module, fun, arity}) do
        quote do
          defdelegate unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, module))),
            to: unquote(module)
        end
      end
    end
  end
end
