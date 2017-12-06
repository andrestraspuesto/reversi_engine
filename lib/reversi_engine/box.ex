defmodule ReversiEngine.Box do
@moduledoc """
Define la casilla y su color
"""
  defstruct [x: nil, y: nil, n: 0]

  @doc """
  Ordena las casillas en orden descendente primero por y, luego por x.

  ##Ejemplo:
        iex>alias ReversiEngine.Box
        iex>boxes = [%ReversiEngine.Box{x: 4, y: 3}, %ReversiEngine.Box{x: 2, y: 0}, %ReversiEngine.Box{x: 1, y: 0},  %ReversiEngine.Box{x: 0, y: 1}]
        iex>Box.order_boxes(boxes)
        [%ReversiEngine.Box{n: 0, x: 1, y: 0}, %ReversiEngine.Box{n: 0, x: 2, y: 0}, %ReversiEngine.Box{n: 0, x: 0, y: 1}, %ReversiEngine.Box{n: 0, x: 4, y: 3}]
  """
  def order_boxes(colored_boxes) do
    colored_boxes
    |> Enum.sort(&compare_boxes/2)
  end

  defp compare_boxes(%{y: y1}, %{y: y2}) when y1 < y2, do: true

  defp compare_boxes(%{y: y1}, %{y: y2}) when y1 > y2, do: false

  defp compare_boxes(%{x: x1}, %{x: x2}) when x1 < x2, do: true

  defp compare_boxes(_, _), do: false
end
