defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User

  def create(%{user: user}) do
    %{
      message: "User criado com sucesso!",
      data: data(user)
    }
  end

  def login(%{token: token}) do
    %{bearer: token, message: "User autenticado com sucesso!"}
  end

  def get(%{user: user}), do: %{data: user}
  def update(%{user: user}), do: %{message: "User atualizado com sucesso!", data: user}
  def delete(%{user: user}), do: %{message: "User deletado com sucesso!", data: user}

  defp data(%User{} = user) do
    %{
      id: user.id,
      cep: user.cep,
      email: user.email,
      name: user.name
    }
  end
end
