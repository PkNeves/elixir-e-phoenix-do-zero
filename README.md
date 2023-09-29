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