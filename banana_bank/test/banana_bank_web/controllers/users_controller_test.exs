defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  alias BananaBank.Users

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do
      params = %{
        name: "Pet",
        email: "pet@hot.com",
        cep: "123",
        password: "321"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "123", "email" => "pet@hot.com", "id" => _1, "name" => "Pet"},
               "message" => "User criado com sucesso!"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{
        name: "Pet",
        email: "pethot.com",
        cep: "123",
        password: "321"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      assert %{
               "errors" => %{"email" => ["has invalid format"]}
             } = response
    end
  end

  describe "delete" do
    test "successfully deletes an user", %{conn: conn} do
      params = %{
        name: "Pet",
        email: "pet@hot.com",
        cep: "123",
        password: "321"
      }

      {:ok, user} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{user.id}", params)
        |> json_response(:ok)

      assert %{
               "data" => %{"cep" => "123", "email" => "pet@hot.com", "id" => _1, "name" => "Pet"},
               "message" => "User deletado com sucesso!"
             } = response
    end
  end
end
