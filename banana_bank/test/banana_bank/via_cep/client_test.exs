defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "successfully returns cep info", %{bypass: bypass} do
      cep = "36570017"

      body = ~s({
        "bairro": "",
        "cep": "36570-017",
        "ddd": "31",
        "gia": "",
        "ibge": "3171303",
        "localidade": "Viçosa",
        "logradouro": "Rua Alexandre Ferreira Mendes",
        "siafi": "5427",
        "uf": "MG"
      })

      expected_response =
        {:ok,
         %{
           "bairro" => "",
           "cep" => "36570-017",
           "ddd" => "31",
           "gia" => "",
           "ibge" => "3171303",
           "localidade" => "Viçosa",
           "logradouro" => "Rua Alexandre Ferreira Mendes",
           "siafi" => "5427",
           "uf" => "MG"
         }}

      Bypass.expect(bypass, "GET", "/36570017/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      url = endpoint_url(bypass.port)
      response = Client.call(url, cep)

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
