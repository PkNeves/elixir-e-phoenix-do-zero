defmodule BananaBank.Users do
  alias BananaBank.Users.Create
  alias BananaBank.Users.Delete
  alias BananaBank.Users.Get
  alias BananaBank.Users.Update
  alias BananaBank.Users.Verify

  defdelegate create(param), to: Create, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate update(param), to: Update, as: :call
  defdelegate login(param), to: Verify, as: :call
end
