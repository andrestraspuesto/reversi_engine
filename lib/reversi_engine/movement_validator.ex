defmodule ReversiEngine.MovementValidator do

  alias ReversiEngine.MovementValidator, as: Worker

  @step_list [
    %{x: -1, y: 0},
    %{x: 1, y: 0},
    %{x: 0, y: -1},
    %{x: 0, y: 1},
    %{x: -1, y: -1},
    %{x: -1, y: 1},
    %{x: 1, y: -1},
    %{x: 1, y: 1}
  ]

  def validate_movement(board, color, coord) when not is_nil(color) do
    case get_color(board, coord) do
      nil -> full_validation(board, color, coord)
      _ -> []
    end

  end



  def is_valid(board, color, coord, step, n_steps, colored \\ []) do
    case in_range(board, coord) do
      false ->
        []
      _ ->
        case get_color(board, coord) do
          ^color = _c ->
            colored
          nil ->
            []
          _ ->
            is_valid(board, color, next_step(coord, step), step, n_steps + 1,
            [coord] ++ colored)
        end
    end

  end

  defp full_validation(board, color, coord) do
      @step_list
      |> Enum.map(&Task.async(fn ->
        Worker.is_valid(board, color, next_step(coord, &1), &1, 0)
      end))
      |> Enum.map(&Task.await/1)
      |> Enum.reduce(&(&1 ++ &2))
  end

  def in_range(board, %{x: x, y: y}) do
    x_ok = x >= 0 && x < tuple_size(board)
    y_ok = y >= 0 && y < tuple_size(board)

    x_ok && y_ok
  end

  defp next_step(%{x: x, y: y}, %{x: sx, y: sy}) do
    %{x: x + sx, y: y + sy}
  end

  defp get_color(board, coord) do
    elem(elem(board, coord.y), coord.x)
  end

end
