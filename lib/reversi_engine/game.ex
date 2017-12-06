defmodule ReversiEngine.Game do
  @moduledoc """
  Módulo que expone la funcionalidad del juego
  """
  use GenServer

  alias ReversiEngine.{Game, Ruler, Box, MovementValidator}

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

  def init(name) do
    {:ok, fsm} = Ruler.start_link
    board = Application.get_env(:reversi_engine, :board_2)[:value]
    {:ok, %{board: board, ruler: fsm}}
  end

  def handle_call(:current_state, _from, state) do
    #TODO devolver conteo
    {:reply, {:ok, board: state[:board]}, state}
  end

  def handle_call({:retire, player}, _from, %{board: board, ruler: fsm}) do
    #TODO por implementar
    {:reply, {:error, %{board: board}}, %{board: board, ruler: fsm}}
  end

  def handle_call({:pass, player}, _from, %{board: board, ruler: fsm}) do
    #TODO por implementar
    {:reply, {:error, %{board: board}}, %{board: board, ruler: fsm}}
  end

  def handle_call({:move, box, player}, _from, %{board: board, ruler: fsm}) do
    case MovementValidator.validate_movement(board, get_color(player), box) do
      [] ->
        {:reply, {:error, %{board: board}}, %{board: board, ruler: fsm}}
      movs ->
        {:reply, {:ok, %{board: board, movs: movs}}, %{board: board, ruler: fsm}}
    end
  end

  defp try_move(board, player, box, ruler_pid) do
    case Ruler.move(ruler_pid, player) do
      :ok ->
        #TODO por implementar
        {:reply, {:error, %{board: board}}, %{board: board, ruler: fsm}}
      _ ->
        {:reply, {:error, %{board: board}}, %{board: board, ruler: fsm}}

    end
  end

  defp get_color(player) when player == :black, do: "B"

  defp get_color(player) when player == :white, do: "W"
end
