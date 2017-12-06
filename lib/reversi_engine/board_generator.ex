defmodule ReversiEngine.BoardGenerator do
  @moduledoc """
  Contiene funcionalidades de creación y modificación del tablero
  """

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
    board
  end


end
