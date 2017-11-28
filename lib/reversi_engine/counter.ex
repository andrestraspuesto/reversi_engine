defmodule ReversiEngine.Counter do
@moduledoc """
Contiene la funcionalidad para obtener el estado de la partida
"""
  @doc """
  Devuelve el conteo de las fichas de cada jugador y las vacías
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
