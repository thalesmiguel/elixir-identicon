defmodule Identicon do
  @moduledoc """
    Provides functions to create a identicon based on a string passed
    as argument.
  """

  @doc """
    Main function called for this module passing only a string argument.
  """
  def generate(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
    Given a `Identicon.Image` struct with hex property, returns a new
    `Identicon.Image` struct with grid property

  ## Examples
      iex> struct = %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
      iex> Identicon.build_grid(struct)
      %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65], grid: [{114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4}, {191, 5}, {41, 6}, {122, 7}, {41, 8}, {191, 9}, {34, 10}, {138, 11}, {117, 12}, {138, 13}, {34, 14}, {115, 15}, {1, 16}, {35, 17}, {1, 18}, {115, 19}, {239, 20}, {239, 21}, {124, 22}, {239, 23}, {239, 24}]}
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Given a list of 3 elements (`row`), returns a new list with mirrored elements

  ## Examples
      iex> list = [1, 2, 3]
      iex> Identicon.mirror_row(list)
      [1, 2, 3, 2, 1]
  """
  def mirror_row([first, second | _tail] = row) do
    unless Enum.count(row) == 3, do: raise("Invalid row format")

    row ++ [second, first]
  end

  @doc """
    Given a `Identicon.Image` struct with hex property, returns a new
    `Identicon.Image` struct with color property

  ## Examples
      iex> struct = %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
      iex> Identicon.pick_color(struct)
      %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65], color: {114, 179, 2}}
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Given a string input, returns a `Identicon.Image` struct with a hex property
    containing a hash of 16 elements representing the argument.

  ## Examples
      iex> Identicon.hash_input("banana")
      %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
