defmodule ReversiEngine.Evaluator do

  alias ReversiEngine.{Evaluator, MovementValidator}

  def calc_movements(board, color) do
    0..tuple_size(board)-1
    |> Enum.map(
      &Task.async(
        fn -> Evaluator.analyze_row(board, color, elem(board, &1), &1) end
      )
    )
    |> Enum.map(&Task.await/1)
    |> Enum.flat_map(&(&1))
  end


  def analyze_row(board, color, row, y) do
    0..tuple_size(row)-1
    |> Enum.filter(&is_nil(elem(row, &1)))
    |> Enum.map(
      &Task.async(
        fn -> Evaluator.analyze_cell(board, color, y, &1) end)
      )
    |> Enum.map(&Task.await/1)
    |> Enum.filter(&(!is_nil(&1)))

  end

  def analyze_cell(board, color, y, x) do
    m = MovementValidator.validate_movement(board, color, %{x: x, y: y})
    case length(m) do
      0 ->
        nil
      n ->
        %{x: x, y: y, n: n}
    end
  end


end
