defmodule ReversiEngine.Counter do
@moduledoc """
Contiene la funcionalidad para obtener el estado de la partida
"""
  @doc """
  Devuelve cuenta las casillas de cada jugador y las vacías en el tablero que
  se le pasa como argumento.

  ##Argumentos:
  - board: tupla de tuplas, que representan las filas que componen el tablero.

  ##Ejemplo:
      iex> board = {{nil, nil, nil, nil},{nil, "B", "W", nil},{nil, "W", "B", nil},{nil, nil, nil, nil}}
      iex> ReversiEngine.Counter.count(board)
      %{nil => 12, "B" => 2, "W" => 2}
  """
  def count(board) do
    board
    |> Tuple.to_list
    |> Enum.flat_map(&Tuple.to_list/1)
    |> count_by(%{})
  end

  defp count_by([], result), do: result

  defp count_by([head | tail], result) do
    case Map.has_key?(result, head) do
      true ->
        count_by(tail, Map.update!(result, head, &(&1 + 1)))
      _ ->
        count_by(tail, Map.put(result, head, 1))
    end

  end

end
