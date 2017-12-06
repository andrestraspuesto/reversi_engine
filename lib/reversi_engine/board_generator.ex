defmodule ReversiEngine.BoardGenerator do
  @moduledoc """
  Contiene funcionalidades de creación y modificación del tablero
  """
  alias ReversiEngine.Box

  @doc """
  Devuelve un tablero con las posiciones indicadas en colored_boxes sustituidas

  ##Ejemplo:
        iex>alias ReversiEngine.BoardGenerator
        iex>board = {{nil, nil, "B"},{"B", nil, nil}}
        iex>colored_boxes = [%{x: 0, y: 0}, %{x: 2, y: 0}, %{x: 2, y: 1}]
        iex>BoardGenerator.calc_board(board, "W", colored_boxes)
        {{"W", nil, "W"},{"B", nil, "W"}}
  """
  def calc_board(board, color, colored_boxes) do
    #TODO implementar
    #1.-Ordenar colored_boxes por y asc, x asc
    ordered_boxes = Box.order_boxes(colored_boxes)
    #2.-recorrer las filas de board mientras board_y < min_colored_y añadir
    #   si board_y = min_colored_y recorer la fila board_y añadiendo todas
    #   las casillas que no esten en colored_boxes y sustituyendo las que esten
    #   las colored_boxes que se van sustituyendo se eliminan se tiene un nuevo
    #   valor para min_colored_y.
    #3.-Se repite 2 hasta alcanzar el final de board y se devuelve new_board
    calc_board(board, {}, color, ordered_boxes, 0)
  end

  defp calc_board({}, new_board,_, _, _) do
    new_board
  end

  defp calc_board(board, new_board, color, [box | tail] = colored_boxes, y) do
    #TODO implementar

    new_board
  end


end
