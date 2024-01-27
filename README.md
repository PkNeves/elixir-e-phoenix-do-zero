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

## Configurando PostgreSql
Bom, foi falado acima que as configurações do banco ficam no arquivo `config/dev.exs`, mas antes disso é preciso configurar o postgres junto ao docker.
Siga os passos abaixo
1. Abra o console do Docker e veja se já existe alguma aplicação rodando na porta 5432:5432. Caso esteja, pare esse serviço
2. Crie uma nova instância do docker com o comando a seguir `docker run --name banana_bank_dev -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres`
3. Rode o comando para criar o banco de dados da aplicação `mix ecto.setup`

Seguindo os passos acima é quase certeza que tudo irá funcionar, mas caso não funcione, vejo o erro e procure soluções.

## Rodando o nosso serviço
Uma vez configurado nosso banco e deixado ele ativo, podemos rodar nossa aplicação localmente com o comando
```shell
mix phx.server
```
Esse código irá nos restornar, no terminal, a url do nosso serviço localmente. Por padrão essa rota é a `http://localhost:4000`, mas não temos nada nessa rota, então podemos adicionar o caminho `/dev/dashboard`, ficando `http://localhost:4000/dev/dashboard`, onde o phoenix nos retornará um dashboard dos status da nossa aplicação.

## Criando nosso primeiro controller
Na pasta banana_bank_web criamos, dentro de controller, nosso primeiro controller. O nome do controller será `welcome_controller`, dentro dele precisamos fazer um use do nosso `banana_bank_web` e criar a rota de index.
Exemplo abaixo
```elixir
defmodule BananaBankWeb.WelcomeController do
  use BananaBankWeb, :controller

  def index(conn, params) do
    # IO.inspect(conn)
    IO.inspect(params)

    conn
    |> put_status(:ok)
    |> json(%{message: "asd"})
  end
end
```
Dentro da nosso arquivo `/banana_bank_web/router.ex` criamos uma rota dentro do escopo da api que passa nosso controller novo e qual a função a ser chamada
```elixir
scope "/api", BananaBankWeb do
    pipe_through(:api)

    get("/", WelcomeController, :index)
  end
```

## Criando uma migration

Migrations são o versionamento do banco de dados. Nela você colcoa o código de cada alteração feita para que uma pessoa que baixe seu repositório consiga ter tudo pronto e se caso haja necessidade de voltar em algum estado anterior, é possível.

### Como funciona
1. Gerar uma migration a partir de um comando `mix ecto.gen.migration <nome_da_migration>`. Esse comando irá gerar um arquivo no qual você pode inserir a mudança que você quer que aconteça no banco de dados. 
2. Inserir mudanças no banco. Abaixo está um exemplo de criação de tabela
```elixir
defmodule BananaBank.Repo.Migrations.AddUser do
  use Ecto.Migration

  def change do
    create table("users") do
      add(:name, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:email, :string, null: false)
      add(:cep, :string, null: false)

      timestamps()
    end
  end
end
```
3. Rodar o comando para efetivar essas mudanças no banco de dados `mix ecto.migrate`. Para desfazer esse alteração, basta usar o comando `mix ecto.rollback`

Pronto, agora você terá um banco versionado e cada mudança deve ser feita a partir dos passo acima

Outros comandos uteis são:
`mix ecto.reset`: que irá resetar todo o banco e rodar as migrations novamente
`mix ecto.setup`: não irá resetar o banco, mas irá criar e rodar as migrations se for necessário.


## Changeset 
Changeset é um conjunto de mudanças. Ele prepara os dados para serem inseridos no banco de dados. Ele também nos retorna se os dados que queremos salvar no banco de dados é válido e ainda podemos fazer a validação dos dados.

Essa combinação de dados em elixir para dados preparados para o banco é feito através da função `cast/3`

As verificações são feitas através da função `valida_<nome_da_validação>`. Existem várias funções de validate e você pode conferir todas elas na documentação.
> Ponto de atenção: A função changeset espera, como primeiro argumento, um struct do módulo, ou seja, chamar User.changeset(User, params) não funciona, tem que passar User.changeset(%User{}, params) ou deixar o primeiro campo vazio, por já ter um default %\_\_MODULE\_\_{} no primeiro parâmetro.

> Outra observação: o mapa que é passado nos parâmetros pode conter valores que o changeset não irá usar, pois ele valirá apenas os fields necessários.

> OBS 3: O changeset retorna uma estrutura do changeset que pode ser válido ou não. Ele ainda não salvou nada no banco, ele estruturou e validou os campos.

## Repo
Repo é uma biblioteca que usamos para dar ações para o nosso banco de dados. No Repo temos funções do tipo 
- `Repo.insert/1`: que inserer um dados no banco de dados através do changeset criado anteriormente
- `Repo.get/2`: que busca um dado do banco de dados.
Entre outras.

Resumindo, o `Changeset` prepara e valida os dados enquanto o `Repo` efetiva as ações no banco.


## Virtual Fields
Nesse seção vamos aprender a criar campos virtuais. Campos virtuais são campos que vamos usar temporariamente no código, mas que não será salvo no banco de dados.

Para criar um campo virtual, basta seguir o exemplo abaixo, colocando o parâmetro `virtual: true` no nosso Schema.
```elixir
  schema "users" do
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:email, :string)
    field(:cep, :string)

    timestamps()
  end
```

Nesse caso estamos criando o campo virtual `password`, isso porque não queremos salvar a senha do usuário de modo puro no nosso banco, queremos criptografá-la antes. Para fazer isso, vamos receber esse campo virtual `password` e transformá-lo em um hash usando a biblioteca `Argon2`. No código tem mais especificações de como isso é feito. Mas em resumo é isso.

## Repo.insert
Dentro de banana_bank/user criamos o arquivo create. Ele tem uma responsabilidade única de criação do usuário. Isso deixa o código mais modular

## Make all router using a unique command
Nos arquivo `router.ex` temos uma forma de criar todas as rotas relativas a um escopo usando o comando `resources/3` Essa função irá criar todas as rotas padrão, mas podemos passar no terceiro argumento um campo de options, especificando apenas as que queremos.

## Create User Controller
Dentro de `banana_bank_web/controllers` criamos o arquivo `users_controller.ex` Esse arquivo ficará responsável por chamar as funções previamente criadas no `banana_bank/user` e lidar com a resposta para o usuário. 
Ele é o intermediador entre as views e os models.

## Adapta Json for Phoenix 1.7
A visualiação do `banana_bank_web/controllers/user_controller.ex` usando o `render("error.json", error)` por exemplo, é a forma como era usado no `Phoenix 1.6`. A nova forma é definir um atom no lugar da string. Esse atom representa o nome de um função que será chamada no arquivo `users_json.ex` que também estará dentro do controller.

Um ponto de atenção é que o defmodule desse arquivo precisa ter o nome `JSON` tudo em caixa alta no final.

Bom, os exemplos estão abaixo


`banana_bank_web/controllers/user_controller.ex`
```elixir
def handle_response({:ok, user}, conn) do
  conn
  |> put_status(:created)
  |> render(:create, user: user)
end
```
`banana_bank_web/controllers/user_json.ex`
```elixir
defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User

  def create(%{user: user}) do
    %{
      message: "User criado com sucesso!",
      data: data(user)
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      cep: user.cep,
      email: user.email,
      name: user.name
    }
  end
end
```
## Render errors 
Quando lidamos com funções que fogem do padrão, ou seja, mandar a renderização de erros para fora do user, usamos a função `put_view/1` e nela especificamos qual arquivo será chamado. Isso serve para que ao chamar a função `render_view/2` ela saiba de qual arquivo chamar.

Adicionamos uma função a mais dentro do `banana_bank_web/controllers/errors_json.ex` que serve para traduzir erros de changeset. Essa função foi nomeada como `translate_erros/1`

## Fallback Controller
Um Fallback Controller é uma forma mais inteligente de lidar com erros. É uma convenção do Phoenix e está descrita na documentação.
A ideia é lidar com apenas com caso de sucesso no nosso controllers e tudo que for erro vai cair no fallbackcontroller.
Para que isso funcione, precisamos usar a estrutura de controle `with`, para que o erro seja passado para frente.

## Using Facade
Usando fachada para deixar nosso código mais legível. O uso de fachada faz com que toda aplicação use um arquivo intermediário que faz o redirecionamento de todas as nossas funções.
No código alterado, ao invés de chamarmos o Usuario com a função `Create.call` iremos chamar a função de fechada `Users.call`. Isso facilita o entendimento e cria, como se fosse um sumário, de todas as funções que temos daquele controller.

## Derivativa
Ele ajuda a renderizar seu schema de forma mais controlada, definindo quais campos vão ser exibidos.
Ele é colocado no schema e daí você escolhe quais campos quer com a opção `only` ou quais campos retirar com a opção `except`.

O uso de derive depende do ituito. O instrutor falou que hoje em dia não prefere usar por preferir coisas mais explicitas. Irei colocar a nível de estudo.

## Update
A função `Repo.update` tem uma peculiaridade. Precisamos usar o changeset para fazer o update, porém o changeset também é usado no create e as validações de criação de atualização podem ser diferentes.
Há várias maneiras de contornar isso, como criar um changeset para cada operação. Não vou delongar sobre as possibilidades, é só um ponto de atenção.

## Biblioteca ex_machine
Uma biblioteca de Factory para facilitar a criação de usuários para teste.

# Section 6 Realizando requisições externas

## 68. Introdução ao Tesla
Tesla é uma lib que ajuda a lidar com requisições externas. No nosso caso, vamos usar ela para consumir uma api de cep, para trazer os dados do cep do usuário.

### 68.1 Adicionando o Tesla
Para a adicionar o Tesla é bem simples, assim como em todas as outras dependencias, só precisamos incluir o tesla no `deps` que fica no nosso arquivo `/mix.exs`
```elixir

defp deps do
[
  {:tesla, "~> 1.4"},
  #...
]
```
Lembrando que, toda vez que for adicionado uma nova dependência, temos que rodar o comando `mix deps.get` para ele trazer essa dependência para nosso código.

### 68.2 Usando o Tesla
Para usar o tesla basta chamar `Tesla.get(url)`. Também é possível usar `post`, basta conferir a documentação

### 68.3 Tesla Middleware
Middleware no tesla são funções de transaformações que atuam nas nossas requisições.
Um exemplo é o JSON que já faz o parse do body caso o `content/type` seja `json` e o `BaseUrl` que define uma url base entre outros.



