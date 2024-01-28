defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users
  alias BananaBank.ViaCep.ClientMock

  setup do
    body = %{
      "bairro" => "Centro",
      "cep" => "36570-017",
      "complemento" => "",
      "ddd" => "31",
      "gia" => "",
      "ibge" => "3171303",
      "localidade" => "Viçosa",
      "logradouro" => "Rua Alexandre Ferreira Mendes",
      "siafi" => "5427",
      "uf" => "MG"
    }

    {:ok, %{body: body}}
  end

  describe "create/2" do
    test "successfully creates an user", %{conn: conn, body: body} do
      params = %{
        "name" => "Pet",
        "email" => "pet@hot.com",
        "cep" => "36570017",
        "password" => "321"
      }

      expect(ClientMock, :call, fn _cep ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{
                 "cep" => "36570017",
                 "email" => "pet@hot.com",
                 "id" => _1,
                 "name" => "Pet"
               },
               "message" => "User criado com sucesso!"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, body: body} do
      params = %{
        "name" => "Pet",
        "email" => "pethot.com",
        "cep" => "36570017",
        "password" => "321"
      }

      expect(ClientMock, :call, fn _cep ->
        {:ok, body}
      end)

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
    test "successfully deletes an user", %{conn: conn, body: body} do
      params = %{
        "name" => "Pet",
        "email" => "pet@hot.com",
        "cep" => "123",
        "password" => "321"
      }

      expect(ClientMock, :call, fn _cep ->
        {:ok, body}
      end)

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
