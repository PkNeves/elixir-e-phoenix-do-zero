defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

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
  end
end
