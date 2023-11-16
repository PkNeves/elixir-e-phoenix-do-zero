# Primeiro Projeto 
nome: fizz_buzz
descrição: dado uma lista \[1,2,3,4,5,6,10,15\] se o número for múltiplo de 3, alteramos por `fizz` se o número for múltiplo de 5, alteramos por `buzz` e se o número for múltiplo de 3 e 5, alteramos por `fizz_buzz`.

## Alguns códigos úteis
Criar um projeto
```shell
mix new project_name
```

Compilar o projeto
```shell
mix compile
```

Rodando os testes
```shell
mix test
```

Buildando o projeto
```shell
mix build
```

Rodando o Elixir de forma iterativa
```shell
iex
```

Rodando o Elixir de forma iterativa dentro de um projeto
```shell
iex -S mix
```

## Aprendizados
- Comandos básicos `mix new project_name`, `mix compile`, `mix test`, `mix build`, `iex`, `iex -S mix`
- Criação de módulos e funções através do `defmodule` e `def`
- Pattern Matching 
- Controlando o fluxo de dados com `case`, `if else`, `funções`
- Pipe operator
- Reutilização de código através de métodos prontos `String`, `Enum`, `File`
- Manpulação em listas
- Sintaxe reduzida para funções anônimas
- Guards
- Testes

# Segundo Projeto
nome: ExMon
descrição: Um jogo de turnos com um jogador vs computador. O jogador e o computador tem 100 pontos de vida cada e, em cada turno, eles farão suas jogadas, que podem ser:
- ataque moderado (18-25) de dano
- ataque variado (10-35) de dano
- cura (18-25) de vida.
A cada movimento será exibido na tela exibiremos o que houve com cada jogador e quando um dos dois jogadores chegar a 0 de vida, o jogo acaba.

## Struct
Struct é um mapa com com um maior controle dos dados. Na Struct conseguimos definir quais as chaves devemos ter, quais chaves são obrigatórias e definir chaves com valores já definidos.
A declaração de uma struct segue como o exemplo abaixo
```elixir
defmodule ExMon.Player do
  defstruct [:life, :move]
end
```

## Dependências Externas
Para adicionar dependências externas ao nosso projeto, basta adicionar um objeto dentro da lista que fica no arquivo `mix.exs` na pasta raiz do nosso projeto.
Após adicionado nossa dependência no arquivo `mix.exs`, precisamos rodar o comando abaixo
```shell
mix deps.get
```
Ele será o responsável por baixar nossas dependências.

## Case de testes
No Elixir é muito fácil testar. Os módulos de teste ficam na pasta /test. O nome dos arquivos seguem o padrão `<modulo>_test.exs`, onde o `<modulo>` é o módulo que se deseja testar.

Todos os módulos de teste deve incluir o modulo `ExUnit.Case` através do `use` ficando logo abaixo da definição do módulo
```elixir
use ExUnit.Case
```

O padrão para se testar uma função é usar a função `describe` para descrever a função que se deseja testar e, dentro da função `describe` usar a função `test` onde temos a descrição do teste sendo feito. Dentro da função `test` temos a chamada da função `assert` que irá verificar se os valores estão de acordo. Segue um exemplo abaixo
```elixir
defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  describe "start/2" do
    test "starts the game state" do
      player = Player.build("Petterson", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end
```

Uma função legal que descobri é uma função para se testar as saídas de IO.
Para testar as strings, podemos usar o módulo `import ExUnit.CaptureIO` e usar a função `capture_io` para capturar as mensagens de retorno. Segue um exemplo abaixo

```elixir
describe "start_game/1" do
    test "when the game is started, returns a message" do
      player = Player.build("Petterson", :soco, :chute, :cura)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "The game is started"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end
```

# Terceiro Projeto
Nesse terceiro projeto nós vamos aprender um CRUD usando o Phoenix. Essa aplicação será de um aplicativo de banco que irá englobar os conceitos abaixo:
- Criação de APIs JSON
  - Framkework Phoenix
    - Estrutura de pastas
    - Separação por contexto
  - Ecto para lidar com banco de dados
  - Como lidar com erros com fallback controllers
  - Testes
- Requisições para API externas
  - Como utilizar a lib Tesla
  - Como testar requisições externas
- Transações com Ecto.Multi
  - Garantindo indepotência em nossas ações
- Autenticação de API's utilizando recursos nativos
- Deploy da nossa aplicação pro Fly.io

## Criando nossa aplicação
Antes de começar, precisamos de algumas configurações
1. Ter o phoenix instalado. Caso você não tenha, pode instalar com o comando a seguir `mix archive.install hex phx.new`
2. Ter o postgresql instalado.

Nesse projeto, vamos criar apenas uma api json, sem frontend, então vamos passar alguns parâmetros na hora de rodar o código de criar o projeto, sendo eles:
- `--no-assets`
- `--no-html`
- `--no-mailer`
O código final ficará então:
```shell
mix phx.new banana_bank --no-assets --no-html --no-mailer
```
## Estrutura de pastas
Dentro da pasta raiz temos algumas pastas importantes que vamos destacar

### Config
Nesta pasta ficarão as config do nosso projeto.
Tudo que estiver no arquivo `.config.exs` é aplicado a todos os ambientes que temos
Pastas com nome específico do ambiente tem as configurações aplicadas apenas nesse ambiente, como o cado do `dev.exs` que terá configurações apenas para o ambiente de desenvolvimento
A pasta `runtime.exs` contém as configurações que será aplicada em tempo de execução.

Uma parte que vale a pena destacar é que no `dev.exs` temos as configurações do banco de dados. Se caso sugir erros no Ecto. Pode ser que o problema esteja aqui.
### Lib
A pasta lib é o coração da nossa aplicação, dentro dela temos duas pastas iniciais, uma com o nome do nosso projeto e outro com o nome do nosso projeto mais a palavra web.
- Web: parte da API
- Normal: lógica interna.
