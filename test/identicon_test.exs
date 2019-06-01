defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

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

    test "returns different structes for different string arguments" do
      first_hash_input = Identicon.hash_input("Banana")
      second_hash_input = Identicon.hash_input("Apple")

      assert first_hash_input != second_hash_input
    end
  end
end
