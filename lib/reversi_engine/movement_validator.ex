defmodule ReversiEngine.MovementValidator do
@moduledoc """
Contiene la funcionalidad encargada de determinar las casillas que cambiarán
de color al colocar una ficha en unas coordenadas determinadas
"""
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

  @doc """
  Devuelve las casillas que cambian de color al colocar una ficha de un color
  dado en una posición determinada sobre un tablero.

  ##Argumentos:
    - board: tupla de tuplas que representa al tablero, donde nil implica que la
    posición está vacía y un string indica el color.
    - color: string que indica el color que se va a colorcar
    - coord: mapa con las coordenadas donde se quiere poner la ficha donde x es
    la columna e y la fila estándo el 0 en la esquina superior izquierda.

  ##Ejemplo:
      iex> board = {{nil, nil, nil, nil},{nil, "B", "W", nil},{nil, "W", "B", nil},{nil, nil, nil, nil}}
      iex> color = "B"
      iex> coord = %{x: 0, y: 2}
      iex> ReversiEngine.MovementValidator.validate_movement(board, color, coord)
      [%{x: 1, y: 2}]
  """
  def validate_movement(board, color, coord) when not is_nil(color) do
    case get_color(board, coord) do
      nil -> async_validation(board, color, coord)
      _ -> []
    end

  end



  def validate_movement(board, color, coord, step, n_steps, colored \\ []) do
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
            validate_movement(board, color, next_step(coord, step), step, n_steps + 1,
            [coord] ++ colored)
        end
    end

  end

  defp async_validation(board, color, coord) do
      @step_list
      |> Enum.map(&Task.async(fn ->
        Worker.validate_movement(board, color, next_step(coord, &1), &1, 0)
      end))
      |> Enum.map(&Task.await/1)
      |> Enum.reduce(&(&1 ++ &2))
  end

  defp in_range(board, %{x: x, y: y}) do
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
