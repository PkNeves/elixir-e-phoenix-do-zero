defmodule BananaBank.Users do
  alias BananaBank.Users.Create
  alias BananaBank.Users.Delete
  alias BananaBank.Users.Get
  alias BananaBank.Users.Update

  defdelegate create(param), to: Create, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate update(param), to: Update, as: :call
end
