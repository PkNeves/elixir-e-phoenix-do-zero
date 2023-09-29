defmodule ExMon.Player do
  @enforce_keys [:life, :name, :move_rnd, :move_avg, :move_heal]
  defstruct [:life, :name, :move_rnd, :move_avg, :move_heal]
end
