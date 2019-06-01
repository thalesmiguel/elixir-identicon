defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  describe "pick_color/1" do
    defp initial_struct do
      %Identicon.Image{
        hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]
      }
    end

    test "retuns the first 3 arguments of hex as a rgb color" do
      struct = Identicon.pick_color(initial_struct())

      assert struct.color == {114, 179, 2}
    end

    test "returns a Identicon.Image struct" do
      struct = Identicon.pick_color(initial_struct())

      assert Map.has_key?(struct, :__struct__)
      assert struct.__struct__ == Identicon.Image
    end

    test "always returns the same color based on the given struct argument" do
      first_struct = Identicon.pick_color(initial_struct())
      second_struct = Identicon.pick_color(initial_struct())

      assert first_struct == second_struct
    end

    test "returns different structs for different string arguments" do
      another_struct = %Identicon.Image{
        hex: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160]
      }

      first_hash_input = Identicon.pick_color(initial_struct())
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
