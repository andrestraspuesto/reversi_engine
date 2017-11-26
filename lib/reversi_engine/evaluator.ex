defmodule ReversiEngine.Evaluator do
  @moduledoc """
  Contiene la funcionalidad de cálculo de todos los movimientos posibles de un
  jugador determinado
  """

  alias ReversiEngine.Evaluator

  @doc """
  ##Cálculo de posibles movimientos.
  Función que calcula los posibles movimientos de un determinado color con una
  determinada disposición de tablero y aplicando una determinada función para
  verificar la valided de los movimientos.

  ##Parametros

    - board: tablero en forma de tupla filas, donde las filas son a su vez
    tuplas donde nil es que la casilla está vacía y otra cosa es el color que
    la ocupa

    - color: color para el que se quieren calcular los posibles movimientos

    - evaluator: función que determina el número de casillas convertidas
    pasándole como argumentos el tablero, el color y la posición

  ##Resultado
  Como resultado de esta función se obtiene una lista con las coordenadas de las
  casillas en las que se podría colocar una ficha y el número de casillas que
  se convertirían en cada caso.

  ##Ejemplo
      iex>alias ReversiEngine.{Evaluator, MovementValidator}
      iex>board = {{nil, nil, nil, nil},{nil, "B", "W", nil},{nil, "W", "B", nil},{nil, nil, nil, nil}}
      iex>color = "B"
      iex>Evaluator.calc_movements(board, color, &MovementValidator.validate_movement/3)
      [%{n: 1, x: 2, y: 0}, %{n: 1, x: 3, y: 1},%{n: 1, x: 0, y: 2}, %{n: 1, x: 1, y: 3}]

  """
  def calc_movements(board, color, validator) do
    0..tuple_size(board)-1
    |> Enum.map(
      &Task.async(
        fn ->
          Evaluator.analyze_row(board, color, elem(board, &1), &1, validator)
        end
      )
    )
    |> Enum.map(&Task.await/1)
    |> Enum.flat_map(&(&1))
  end


  def analyze_row(board, color, row, y, validator) do
    0..tuple_size(row)-1
    |> Enum.filter(&is_nil(elem(row, &1)))
    |> Enum.map(
      &Task.async(
        fn -> Evaluator.analyze_cell(board, color, y, &1, validator) end)
      )
    |> Enum.map(&Task.await/1)
    |> Enum.filter(&(!is_nil(&1)))

  end

  def analyze_cell(board, color, y, x, validator) do
    m = validator.(board, color, %{x: x, y: y})
    case length(m) do
      0 ->
        nil
      n ->
        %{x: x, y: y, n: n}
    end
  end


end
