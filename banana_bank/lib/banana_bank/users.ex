defmodule BananaBank.Users do
  alias BananaBank.Users.Create
  alias BananaBank.Users.Get

  defdelegate create(param), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
end
