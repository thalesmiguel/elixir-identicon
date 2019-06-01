defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  describe "hash_input/1" do
    test "always returns the same hash based on the given string argument" do
      string_argument = "Banana"
      first_hash = Identicon.hash_input(string_argument)
      second_hash = Identicon.hash_input(string_argument)

      assert first_hash == second_hash
    end

    test "returns different hashes for different string arguments" do
      first_hash = Identicon.hash_input("Banana")
      second_hash = Identicon.hash_input("Apple")

      assert first_hash != second_hash
    end
  end
end
