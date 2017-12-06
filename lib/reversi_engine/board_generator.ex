defmodule ReversiEngine.BoardGenerator do
  @moduledoc """
  Contiene funcionalidades de creación y modificación del tablero
  """
  alias ReversiEngine.Box

  @doc """
  Devuelve un tablero con las posiciones indicadas en colored_boxes sustituidas

  ##Ejemplo 1:
        iex>alias ReversiEngine.BoardGenerator
        iex>board = {{nil, nil, "B"}, {nil, nil, "B"},{"B", nil, nil}, {"B", "B", nil}}
        iex>colored_boxes = [%{x: 0, y: 1}, %{x: 2, y: 1}, %{x: 2, y: 2}]
        iex>BoardGenerator.calc_board(board, "W", colored_boxes)
        {{nil, nil, "B"},{"W", nil, "W"},{"B", nil, "W"}, {"B", "B", nil}}

  ##Ejemplo 2 si no hay casillas que cambiar de color:
        iex>alias ReversiEngine.BoardGenerator
        iex>board = {{nil, nil, "B"}, {nil, nil, "B"},{"B", nil, nil}, {"B", "B", nil}}
        iex>colored_boxes = []
        iex>BoardGenerator.calc_board(board, "W", colored_boxes)
        {{nil, nil, "B"}, {nil, nil, "B"},{"B", nil, nil}, {"B", "B", nil}}

  ##Ejemplo 3 si se indica que hay que cambiar de color casillas fuera del tablero:
        iex>alias ReversiEngine.BoardGenerator
        iex>board = {{nil, nil, "B"}, {nil, nil, "B"},{"B", nil, nil}, {"B", "B", nil}}
        iex>colored_boxes = [%{x: 0, y: 6}, %{x: 2, y: 6}, %{x: 2, y: 6}]
        iex>BoardGenerator.calc_board(board, "W", colored_boxes)
        {{nil, nil, "B"}, {nil, nil, "B"},{"B", nil, nil}, {"B", "B", nil}}
  """
  def calc_board(board, color, colored_boxes) do
    ordered_boxes = Box.order_boxes(colored_boxes)
    calc_board(board, {}, color, ordered_boxes, 0)
  end

  #Ya no quedan filas en el tablero
  defp calc_board({}, new_board, _, _, _), do: new_board

  #Ya no quedan casillas que cambien, se añaden directamente  las filas
  #restantes del tablero
  defp calc_board(board, new_board, color, [], y) do
    add_row(board, new_board, color, [], y)
  end

  defp calc_board(board, new_board, color, [box | _tail] = colored_boxes, y) do
    case box.y > y do
      true ->
        add_row(board, new_board, color, colored_boxes, y)
      _ ->
        {n_r, n_c} = calc_row(elem(board, 0), {}, color, colored_boxes, {y, 0})
        n_b = Tuple.append(new_board, n_r)
        r_b = Tuple.delete_at(board, 0)
        calc_board(r_b, n_b, color, n_c, y + 1)
    end
  end

  #Añade una fila completa al tablero
  defp add_row(board, new_board, color, colored_boxes, y) do
    n_b = Tuple.append(new_board, elem(board, 0))
    r_b = Tuple.delete_at(board, 0)
    calc_board(r_b, n_b, color, colored_boxes, y + 1)
  end

  defp calc_row({}, new_row, _color, colored_boxes, _) do
    {new_row, colored_boxes}
  end

  #Compone la fila combinando las casillas del tablero original con las que
  #deben cambiar de color
  defp calc_row(row, new_row, color, [box | tail] = colored_boxes, {y, x}) do
    {n_r, boxes} =
      case box.y == y && box.x == x do
        true ->
          {Tuple.append(new_row, color), tail}
        _ -> {Tuple.append(new_row, elem(row, 0)), colored_boxes}
      end
    r_r = Tuple.delete_at(row, 0)
    calc_row(r_r, n_r, color, boxes, {y, x + 1})
  end
end
