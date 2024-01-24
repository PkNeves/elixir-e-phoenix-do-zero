defmodule BananaBank.Users do
  alias BananaBank.Users.Create
  alias BananaBank.Users.Get
  alias BananaBank.Users.Update

  defdelegate create(param), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate update(param), to: Update, as: :call
end
