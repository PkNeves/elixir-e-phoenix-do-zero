defmodule ExMon do
  def create_player(name, move_avg, move_rnd, move_heal) do
    ExMon.Player.build(name, move_avg, move_rnd, move_heal)
  end
end
