defmodule ReversiEngine.CounterTest do
  use ExUnit.Case
  doctest ReversiEngine.Counter
  alias ReversiEngine.Counter

  @board_1  Application.get_env(:reversi_engine, :board_1)[:value]

  @board_3  Application.get_env(:reversi_engine, :board_3)[:value]

  test "tablero 1 2B 2W 12nil" do
    expected = %{nil => 12, "B" => 2, "W" => 2}
    m = Counter.count(@board_1)
    assert expected == m
  end

  test "tablero 3 2B 2W 12nil" do
    expected = %{nil => 58, "B" => 3, "W" => 3}
    m = Counter.count(@board_3)
    assert expected == m
  end

end
