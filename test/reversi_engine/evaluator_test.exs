defmodule ReversiEngine.EvaluatorTest do
  use ExUnit.Case
  doctest ReversiEngine.Evaluator
  alias ReversiEngine.{Evaluator, MovementValidator}



  test "tablero 1 movimientos de negras" do
    expected = [
      %{n: 1, x: 2, y: 0}, %{n: 1, x: 3, y: 1},
      %{n: 1, x: 0, y: 2}, %{n: 1, x: 1, y: 3}
    ]

    board = Application.get_env(:reversi_engine, :board_1)[:value]
    m = Evaluator.calc_movements(board, "B", &MovementValidator.validate_movement/3)

    is_same(m, expected)
  end

  test "tablero 3 movimientos de negras" do
    expected = [
      %{n: 1, x: 2, y: 4}, %{n: 1, x: 4, y: 2},
      %{n: 2, x: 5, y: 2}, %{n: 1, x: 5, y: 3},
      %{n: 1, x: 6, y: 6}, %{n: 1, x: 3, y: 5}
    ]

    board = Application.get_env(:reversi_engine, :board_3)[:value]
    m = Evaluator.calc_movements(board, "B", &MovementValidator.validate_movement/3)

    is_same(m, expected)
  end

  defp is_same(l1, l2) do
    assert length(Enum.uniq(l1 ++ l2)) == length(l1) && Enum.all?(l1, &Enum.member?(l2, &1))
  end
end
