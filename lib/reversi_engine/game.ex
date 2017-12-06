defmodule ReversiEngine.Game do
  @moduledoc """
  Módulo que expone la funcionalidad del juego
  """
  use GenServer

  alias ReversiEngine.{Ruler, MovementValidator, BoardGenerator}

  defstruct [board: nil, ruler: nil]

  def start_link(game_code) when is_binary game_code and byte_size(game_code) > 0 do
    GenServer.start_link(__MODULE__, game_code, name: {:global, "game:#{game_code}"})
  end

  def move(pid, box, player) when is_atom(player) and is_pid(pid) do
    GenServer.call(pid, {:move, box, player})
  end

  def pass(pid, player) when is_atom(player) and is_pid(pid) do
    GenServer.call(pid, {:pass, player})
  end

  def retire(pid, player) when is_atom(player) and is_pid(pid) do
    GenServer.call(pid, {:retire, player})
  end

  def get_state(pid)  when is_pid(pid) do
    GenServer.call(pid, :current_state)
  end

  def init(_name) do
    {:ok, fsm} = Ruler.start_link
    board = Application.get_env(:reversi_engine, :board_2)[:value]
    {:ok, {board, fsm}}
  end

  def handle_call(:current_state, _from, state) do
    #TODO devolver conteo
    {:reply, {:ok, board: state[:board]}, state}
  end

  def handle_call({:retire, player}, _from, {board, fsm}) do
    #TODO por implementar
    {:reply, {:error, %{board: board}}, {board, fsm}}
  end

  def handle_call({:pass, player}, _from, {board, fsm}) do
    #TODO por implementar
    {:reply, {:error, %{board: board}}, {board, fsm}}
  end

  def handle_call({:move, box, player}, _from, {board, fsm}) do
    case MovementValidator.validate_movement(board, get_color(player), box) do
      [] ->
        {:reply, {:error, %{board: board}}, {board, fsm}}
      movs ->
        #TODO validar que el siguiente jugador puede mover y si no puede
        # comprobar si se ha alcanzado el final de la partida
        try_move(board, fsm, player,  movs ++ [box])
    end
  end

  defp try_move(board, fsm, player, colored_boxes) do
    case Ruler.move(fsm, player) do
      :ok ->
        color = get_color(player)
        board = BoardGenerator.calc_board(board, color, colored_boxes)
        {:reply, {:ok, %{board: board}}, {board, fsm}}
      _ ->
        {:reply, {:error, %{board: board}}, {board, fsm}}

    end
  end

  defp get_color(player) when player == :black, do: "B"

  defp get_color(player) when player == :white, do: "W"
end
