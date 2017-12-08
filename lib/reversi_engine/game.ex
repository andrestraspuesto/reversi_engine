defmodule ReversiEngine.Game do
  @moduledoc """
  Módulo que expone la funcionalidad del juego
  """
  use GenServer

  alias ReversiEngine.{
    Ruler, MovementValidator, BoardGenerator, Evaluator, Counter
  }

  defstruct [board: nil, ruler: nil]

  @doc """
  Inicia el módulo con el tablero y estado inicial por defecto 8x8 y turno de
  blancas

  ##Ejemplo
          iex>{:ok, pid} = ReversiEngine.Game.start_link
          iex>is_pid(pid)
          true
  """
  def start_link do
    GenServer.start_link(__MODULE__, {})
  end

  @doc """
  Inicia el módulo en el estado inicial por defecto, turno de
  blancas y con el tablero que se pase como argumento

  ##Ejemplo
          iex>board = {{nil, nil}, {nil, nil}}
          iex>{:ok, pid} = ReversiEngine.Game.start_link(board)
          iex>is_pid(pid)
          true
  """
  def start_link(board) do
    GenServer.start_link(__MODULE__, {board})
  end

  @doc """
  Inicia el módulo en el estado inicial por defecto, turno de
  blancas y con el tablero que se pase como argumento

  ##Ejemplo
          iex>board = {{nil, nil}, {nil, nil}}
          iex>estado = :white
          iex>{:ok, pid} = ReversiEngine.Game.start_link(board, estado)
          iex>is_pid(pid)
          true
  """
  def start_link(board, ruler_state) do
    GenServer.start_link(__MODULE__, {board, ruler_state})
  end

  @doc """
  El jugador toma la posición indicada, y se devuelve el resultado de intentar
  dicho movimiento, este puede ser un error por ser un movimiento no permitido
  o el tablero resultante del mismo.

  ##Ejemplo
          iex>board = {{nil, nil, nil, nil}, {nil, "B", "W", nil}, {nil, "W", "B", nil}, {nil, nil, nil, nil}}
          iex>{:ok, pid} = ReversiEngine.Game.start_link(board)
          iex>ReversiEngine.Game.move(pid, %{x: 1, y: 0}, :white)
          {:ok,%{board: {{nil, "W", nil, nil}, {nil, "W", "W", nil},
          {nil, "W", "B", nil}, {nil, nil, nil, nil}},
          possibilities: [%ReversiEngine.Box{n: 1, x: 0, y: 0},
          %ReversiEngine.Box{n: 1, x: 2, y: 0}, %ReversiEngine.Box{n: 1, x: 0, y: 2}],
          scoreboard: %{nil => 11, "B" => 1, "W" => 4}, turn: :black}}
  """
  def move(pid, box, player) when is_atom(player) and is_pid(pid) do
    GenServer.call(pid, {:move, box, player})
  end

  @doc """
  El jugador se retira y pierde la partida.

  ##Ejemplo
          iex>board = {{nil, nil, nil, nil}, {nil, "B", "W", nil}, {nil, "W", "B", nil}, {nil, nil, nil, nil}}
          iex>{:ok, pid} = ReversiEngine.Game.start_link(board)
          iex>ReversiEngine.Game.retire(pid, :white)
          iex>ReversiEngine.Game.get_state(pid)
          {:ok,
            %{board: {{nil, nil, nil, nil}, {nil, "B", "W", nil},
               {nil, "W", "B", nil}, {nil, nil, nil, nil}},
              scoreboard: %{nil => 12, "B" => 2, "W" => 2}, turn: :black_won}}
  """
  def retire(pid, player) when is_atom(player) and is_pid(pid) do
    GenServer.call(pid, {:retire, player})
  end

  @doc """
  Devuelve el estado actual de la partida, de quien es el turno y movimientos
  posibles.

  ##Ejemplo
          iex>board = {{nil, nil, nil, nil}, {nil, "B", "W", nil}, {nil, "W", "B", nil}, {nil, nil, nil, nil}}
          iex>{:ok, pid} = ReversiEngine.Game.start_link(board)
          iex>ReversiEngine.Game.move(pid, %{x: 1, y: 0}, :white)
          iex>ReversiEngine.Game.get_state(pid)
          {:ok,
          %{board: {{nil, "W", nil, nil}, {nil, "W", "W", nil},
          {nil, "W", "B", nil}, {nil, nil, nil, nil}},
          scoreboard: %{nil => 11, "B" => 1, "W" => 4}, turn: :black}}
  """
  def get_state(pid)  when is_pid(pid) do
    GenServer.call(pid, :current_state)
  end

  def init({board, ruler_state}) do
    {:ok, fsm} = Ruler.start_link(ruler_state)
    {:ok, {board, fsm}}
  end

  def init({board}) do
    {:ok, fsm} = Ruler.start_link
    {:ok, {board, fsm}}
  end

  def init(_state) do
    {:ok, fsm} = Ruler.start_link
    board = Application.get_env(:reversi_engine, :board_2)[:value]
    {:ok, {board, fsm}}
  end

  def handle_call(:current_state, _from, {board, fsm}) do
    turn = Ruler.show_state(fsm)
    scoreboard = Counter.count(board)
    data = %{board: board, turn: turn, scoreboard: scoreboard}
    {:reply, {:ok, data}, {board, fsm}}
  end

  def handle_call({:retire, player}, _from, {board, fsm}) do
    result = Ruler.retire(fsm, player)
    scoreboard = Counter.count(board)
    turn = Ruler.show_state(fsm)
    data = %{board: board, turn: turn, scoreboard: scoreboard}
    {:reply, {result, data}, {board, fsm}}
  end

  def handle_call({:move, box, player}, _from, {board, fsm}) do
    case MovementValidator.validate_movement(board, get_color(player), box) do
      [] ->
        {:reply, {:error, %{board: board}}, {board, fsm}}
      movs ->
        result =
          fsm
          |> Ruler.move(player)
          |> set_board(board, fsm, player, movs ++ [box])
          |> set_scoreboard
          |> set_possibilities
          |> set_turn

        Tuple.insert_at(result, 0, :reply)

    end
  end

  defp set_board(:ok, board, fsm, player, colored_boxes) do
    color = get_color(player)
    new_board = BoardGenerator.calc_board(board, color, colored_boxes)
    {{:ok, %{board: new_board}}, {new_board, fsm}}
  end

  defp set_board(:error, board, fsm, _player, _colored_boxes) do
    {{:error, %{board: board}}, {board, fsm}}
  end

  defp set_scoreboard({{type, data}, {board, fsm}}) do
    scoreboard = Counter.count(board)
    {{type, Map.put(data, :scoreboard, scoreboard)}, {board, fsm}}
  end

  defp set_possibilities({{type, data}, {board, fsm}}) do
    player = Ruler.show_state(fsm)
    c = get_color(player)
    mov =
      Evaluator.calc_movements(board, c, &MovementValidator.validate_movement/3)
    {{type, Map.put(data, :possibilities, mov)}, {board, fsm}}
  end

  defp set_turn({{type, %{possibilities: [], scoreboard: sc} = data}, {board, fsm}}) do
    player = Ruler.show_state(fsm)
    c = get_other_color(player)
    mov =
      Evaluator.calc_movements(board, c, &MovementValidator.validate_movement/3)
    case mov do
      [] ->
        blacks = sc["B"] || 0
        whites = sc["W"] || 0
        set_winner(blacks, whites, fsm)
        new_data =
          data
          |> Map.delete(:possibilities)
          |> Map.put(:turn, :finish)

        {{type, new_data}, {board, fsm}}
      _ ->
        Ruler.pass(fsm, player)
        new_player = Ruler.show_state(fsm)
        new_data =
          data
          |> Map.delete(:possibilities)
          |> Map.put(:possibilities, mov)
          |> Map.put(:turn, new_player)

        {{type, new_data}, {board, fsm}}
    end
  end

  defp set_turn({{type, data}, {board, fsm}}) do
    new_data = Map.put(data, :turn, Ruler.show_state(fsm))
    {{type, new_data}, {board, fsm}}
  end

  defp get_color(player) when player == :black, do: "B"

  defp get_color(player) when player == :white, do: "W"

  defp get_other_color(player) when player == :white, do: "B"

  defp get_other_color(player) when player == :black, do: "W"

  defp set_winner(blacks, whites, fsm) when blacks > whites do
    Ruler.win(fsm, :black)
  end

  defp set_winner(blacks, whites, fsm) when blacks < whites do
    Ruler.win(fsm, :white)
  end

  defp set_winner(_blacks, _whites, fsm) do
    Ruler.win(fsm, :none)
  end

end
