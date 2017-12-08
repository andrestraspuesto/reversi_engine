defmodule ReversiEngine.GameTest do
  use ExUnit.Case
  doctest ReversiEngine.Game
  alias ReversiEngine.Game

  @board_test_pass  Application.get_env(:reversi_engine, :board_test_pass)[:value]

  @board_test_w_won  Application.get_env(:reversi_engine, :board_test_w_won)[:value]

  @board_test_b_won  Application.get_env(:reversi_engine, :board_test_b_won)[:value]

  @board_test_w_won_2  Application.get_env(:reversi_engine, :board_test_w_won_2)[:value]

  @board_test_b_won_2  Application.get_env(:reversi_engine, :board_test_b_won_2)[:value]

  @board_test_empate  Application.get_env(:reversi_engine, :board_test_empate)[:value]

  test "tras movimiento de blanca negra debe pasar" do
    {:ok, pid} = Game.start_link(@board_test_pass)
    {:ok, %{turn: turn}} = Game.move(pid, %{x: 1, y: 0}, :white)
    assert turn == :white
  end

  test "tras movimiento de blancas gana" do
    {:ok, pid} = Game.start_link(@board_test_w_won)
    Game.move(pid, %{x: 2, y: 3}, :white)
    {:ok, %{turn: turn}} = Game.get_state(pid)
    assert turn == :white_won
  end

  test "tras movimiento de negras gana" do
    {:ok, pid} = Game.start_link(@board_test_b_won, :black)
    Game.move(pid, %{x: 3, y: 1}, :black)
    {:ok, %{turn: turn}} = Game.get_state(pid)
    assert turn == :black_won
  end

  test "tras movimiento de negras gana blancas" do
    {:ok, pid} = Game.start_link(@board_test_w_won_2, :black)
    Game.move(pid, %{x: 3, y: 1}, :black)
    {:ok, %{turn: turn}} = Game.get_state(pid)
    assert turn == :white_won
  end

  test "tras movimiento de blancas gana negras" do
    {:ok, pid} = Game.start_link(@board_test_b_won_2)
    Game.move(pid, %{x: 3, y: 1}, :white)
    {:ok, %{turn: turn}} = Game.get_state(pid)
    assert turn == :black_won
  end

  test "tras movimiento de negras empate" do
    {:ok, pid} = Game.start_link(@board_test_empate, :black)
    Game.move(pid, %{x: 3, y: 1}, :black)
    {:ok, %{turn: turn}} = Game.get_state(pid)
    assert turn == :none_won
  end

  test "movimiento incorrecto" do
    {:ok, pid} = Game.start_link(@board_test_empate, :black)
    {result, _} = Game.move(pid, %{x: 0, y: 1}, :black)
    assert result == :error
  end

end
