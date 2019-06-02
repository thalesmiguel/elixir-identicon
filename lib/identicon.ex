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
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Saves the drawn image on HDD.
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
    Draws the image using erlang's egd engine
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
    Given a `Identicon.Image` struct with grid property, returns a new
    `Identicon.Image` struct with pixel_map property

  ## Examples
      iex> struct = %Identicon.Image{grid: [{114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4}]}
      iex> Identicon.build_pixel_map(struct)
      %Identicon.Image{
        grid: [{114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4}],
        pixel_map: [
          {{0, 0}, {50, 50}},
          {{50, 0}, {100, 50}},
          {{100, 0}, {150, 50}},
          {{150, 0}, {200, 50}},
          {{200, 0}, {250, 50}}
        ]
      }
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_lef = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_lef, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Filters the given `Identicon.Image` and returns only the odd squares that
    will be colored on the processed image

  ## Examples
      iex> struct = %Identicon.Image{grid: [{1, 0}, {2, 1}, {3, 2}, {4, 3}, {5, 4}]}
      iex> Identicon.filter_odd_squares(struct)
      %Identicon.Image{grid: [{2, 1}, {4, 3}]}
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
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
