defmodule BananaBankWeb.UsersController do
  use BananaBankWeb, :controller
  alias BananaBank.Users.Create

  def create(conn, params) do
    params
    |> Create.call()
    |> handle_response(conn)
  end

  def handle_response({:ok, user}, conn) do
    conn
    |> put_status(:created)
    |> render("user.json", user: user)
  end

  def handle_response({:error, _changeset} = error, conn) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", error)
  end
end
