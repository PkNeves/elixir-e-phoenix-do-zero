defmodule FizzBuzzTest do
  use ExUnit.Case

  describe "build/1" do
    test "when a valid file is provided, returns the converted list" do
      assert FizzBuzz.build("numbers.txt") == {:ok, [1, 2, :fizz, 4, :buzz, :fizzbuzz, 16]}
    end

    test "when a invalid file is provided, returns an error" do
      assert FizzBuzz.build("invalid.txt") == {:error, "Error reading file enoent"}
    end
  end
end
