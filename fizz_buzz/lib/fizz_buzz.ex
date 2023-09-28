defmodule FizzBuzz do
  def build(file_name) do
    case File.read(file_name) do
      {:ok, file} -> file
      {:error, reason} -> reason
    end
  end
end
