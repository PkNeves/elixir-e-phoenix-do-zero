defmodule BananaBank.Users do
  alias BananaBank.Users.Create
  defdelegate create(param), to: Create, as: :call
end
