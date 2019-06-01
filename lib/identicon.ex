defmodule Identicon do
  @moduledoc """
    Provides functions to create a identicon based on a string passed
    as argument.
  """

  @doc """
    Main function called for this module passing only a string argument.
  """
  def main(input) do
    input
    |> hash_input
  end

  @doc """
    Given a string input, returns a hash of 16 elements representing the
    argument.

  ## Examples
      iex> Identicon.hash_input("banana")
      [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
