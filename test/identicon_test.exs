defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  describe "build_pixel_map/1" do
    defp build_pixel_initial_struct_with_grid do
      %Identicon.Image{
        grid: [{114, 0}, {2, 2}, {114, 4}]
      }
    end

    test "retuns a pixel_map with the square points" do
      struct = Identicon.build_pixel_map(build_pixel_initial_struct_with_grid())

      assert struct.pixel_map == [{{0, 0}, {50, 50}}, {{100, 0}, {150, 50}}, {{200, 0}, {250, 50}}]
    end

    test "returns a Identicon.Image struct" do
      struct = Identicon.build_pixel_map(build_pixel_initial_struct_with_grid())

      assert Map.has_key?(struct, :__struct__)
      assert struct.__struct__ == Identicon.Image
    end
  end

  describe "filter_odd_squares/1" do
    defp filter_odd_squares_initial_struct_with_grid do
      %Identicon.Image{
        grid: [{114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4}, {191, 5}, {41, 6}, {122, 7}, {41, 8}, {191, 9}, {34, 10}, {138, 11}, {117, 12}, {138, 13}, {34, 14}, {115, 15}, {1, 16}, {35, 17}, {1, 18}, {115, 19}, {239, 20}, {239, 21}, {124, 22}, {239, 23}, {239, 24}]
      }
    end

    test "retuns a grid with only the odd elements" do
      struct = Identicon.filter_odd_squares(filter_odd_squares_initial_struct_with_grid())

      assert struct.grid == [{114, 0}, {2, 2}, {114, 4}, {122, 7}, {34, 10}, {138, 11}, {138, 13}, {34, 14}, {124, 22}]
    end

    test "returns a Identicon.Image struct" do
      struct = Identicon.filter_odd_squares(filter_odd_squares_initial_struct_with_grid())

      assert Map.has_key?(struct, :__struct__)
      assert struct.__struct__ == Identicon.Image
    end
  end

  describe "build_grid/1" do
    defp build_grid_initial_struct_with_hex do
      %Identicon.Image{
        hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]
      }
    end

    test "retuns a grid based on the given hex" do
      struct = Identicon.build_grid(build_grid_initial_struct_with_hex())

      assert struct.grid == [{114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4}, {191, 5}, {41, 6}, {122, 7}, {41, 8}, {191, 9}, {34, 10}, {138, 11}, {117, 12}, {138, 13}, {34, 14}, {115, 15}, {1, 16}, {35, 17}, {1, 18}, {115, 19}, {239, 20}, {239, 21}, {124, 22}, {239, 23}, {239, 24}]
    end

    test "returns a Identicon.Image struct" do
      struct = Identicon.build_grid(build_grid_initial_struct_with_hex())

      assert Map.has_key?(struct, :__struct__)
      assert struct.__struct__ == Identicon.Image
    end

    test "always returns the same grid based on the given struct argument" do
      first_struct = Identicon.build_grid(build_grid_initial_struct_with_hex())
      second_struct = Identicon.build_grid(build_grid_initial_struct_with_hex())

      assert first_struct == second_struct
    end

    test "returns different structs for different string arguments" do
      another_struct = %Identicon.Image{
        hex: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160]
      }

      first_hash_input = Identicon.build_grid(build_grid_initial_struct_with_hex())
      second_hash_input = Identicon.build_grid(another_struct)

      assert first_hash_input != second_hash_input
    end
  end

  describe "mirror_row/1" do
    test "retuns a list with mirrored elements" do
      list = [1, 2, 3]

      assert Identicon.mirror_row(list) == [1, 2, 3, 2, 1]
    end

    test "raises an error if the given row is not compatible" do
      list = [1, 2, 3, 4]

      assert_raise RuntimeError, fn ->
        Identicon.mirror_row(list)
      end
    end
  end

  describe "pick_color/1" do
    defp pick_color_initial_struct_with_hex do
      %Identicon.Image{
        hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]
      }
    end

    test "retuns the first 3 arguments of hex as a rgb color" do
      struct = Identicon.pick_color(pick_color_initial_struct_with_hex())

      assert struct.color == {114, 179, 2}
    end

    test "returns a Identicon.Image struct" do
      struct = Identicon.pick_color(pick_color_initial_struct_with_hex())

      assert Map.has_key?(struct, :__struct__)
      assert struct.__struct__ == Identicon.Image
    end

    test "always returns the same color based on the given struct argument" do
      first_struct = Identicon.pick_color(pick_color_initial_struct_with_hex())
      second_struct = Identicon.pick_color(pick_color_initial_struct_with_hex())

      assert first_struct == second_struct
    end

    test "returns different structs for different string arguments" do
      another_struct = %Identicon.Image{
        hex: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160]
      }

      first_hash_input = Identicon.pick_color(pick_color_initial_struct_with_hex())
      second_hash_input = Identicon.pick_color(another_struct)

      assert first_hash_input != second_hash_input
    end
  end

  describe "hash_input/1" do
    test "returns a Identicon.Image struct" do
      hash_input = Identicon.hash_input("Banana")

      assert Map.has_key?(hash_input, :__struct__)
      assert hash_input.__struct__ == Identicon.Image
    end

    test "always returns the same struct based on the given string argument" do
      string_argument = "Banana"
      first_hash_input = Identicon.hash_input(string_argument)
      second_hash_input = Identicon.hash_input(string_argument)

      assert first_hash_input == second_hash_input
    end

    test "returns different structs for different string arguments" do
      first_hash_input = Identicon.hash_input("Banana")
      second_hash_input = Identicon.hash_input("Apple")

      assert first_hash_input != second_hash_input
    end
  end
end
