defmodule ReversiEngine.Ruler do
  @moduledoc """
  Funcionalidad de máquina de estados encargada de determinar si el estado
  actual permite el cambio de estado solicitado
  """
  use GenStateMachine, callback_mode: :state_functions

  @doc """
  Inicia la máquina de estados finitos

  ##Ejemplo
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_turn
  """
  def start_link do
    GenStateMachine.start_link(__MODULE__, {:white_turn, %{}})
  end

  @doc """
  Inicia la máquina de estados finitos en un estado determinado

  ##Ejemplo
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link(:white_won)
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_won
  """
  def start_link(state) when is_atom(state) do
    GenStateMachine.start_link(__MODULE__, {state, %{}})
  end

  @doc """
  Realiza la acción de mover, solo puede hacerlo el que está en su turno.

  ##Ejemplo
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.show_state(pid)
        iex>ReversiEngine.Ruler.move(pid, :white)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :black_turn
        iex>ReversiEngine.Ruler.move(pid, :white)
        :error
        iex>ReversiEngine.Ruler.move(pid, :black)
        :ok
  """
  def move(fsm, color) do
    GenStateMachine.call(fsm, {:move, color})
  end

  @doc """
  Realiza la acción de pasar, solo puede hacerlo el que está en su turno.

  ##Ejemplo
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.show_state(pid)
        iex>ReversiEngine.Ruler.pass(pid, :white)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :black_turn
        iex>ReversiEngine.Ruler.pass(pid, :white)
        :error
        iex>ReversiEngine.Ruler.pass(pid, :black)
        :ok
  """
  def pass(fsm, color) do
    GenStateMachine.call(fsm, {:pass, color})
  end

  @doc """
  Realiza la acción de retirarse, solo puede hacerlo el que está en su turno e
  implica que el otro jugador gana la partida.

  ##Ejemplo
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.show_state(pid)
        iex>ReversiEngine.Ruler.retire(pid, :white)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :black_won
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.move(pid, :white)
        iex>ReversiEngine.Ruler.retire(pid, :black)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_won
  """
  def retire(fsm, color) do
    GenStateMachine.call(fsm, {:retire, color})
  end

  @doc """
  Realiza la acción de ganar, solo puede hacerlo el que está en su turno e
  implica que el otro jugador pierde la partida.

  ##Ejemplo
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.win(pid, :white)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_won
        iex>ReversiEngine.Ruler.pass(pid, :black)
        :error
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_won
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.move(pid, :white)
        :ok
        iex>ReversiEngine.Ruler.win(pid, :black)
        iex>ReversiEngine.Ruler.show_state(pid)
        :black_won
  """
  def win(fsm, color) do
    GenStateMachine.call(fsm, {:win, color})
  end

  @doc """
  Devuelve el estado actual de la partida.

  ##Ejemplo
        iex>{:ok, pid} = ReversiEngine.Ruler.start_link()
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_turn
        iex>ReversiEngine.Ruler.move(pid, :white)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :black_turn
        iex>ReversiEngine.Ruler.move(pid, :black)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_turn
        iex>ReversiEngine.Ruler.win(pid, :white)
        :ok
        iex>ReversiEngine.Ruler.show_state(pid)
        :white_won

  """
  def show_state(fsm) do
    GenStateMachine.call(fsm, :current_state)
  end

  def white_turn({:call, from}, {:move, :white}, state_data) do
    {:next_state, :black_turn, state_data, {:reply, from, :ok}}
  end

  def white_turn({:call, from}, {:retire, :white}, state_data) do
    {:next_state, :black_won, state_data, {:reply, from, :ok}}
  end

  def white_turn({:call, from}, {:pass, :white}, state_data) do
    {:next_state, :black_turn, state_data, {:reply, from, :ok}}
  end

  def white_turn({:call, from}, {:win, :white}, state_data) do
    {:next_state, :white_won, state_data, {:reply, from, :ok}}
  end

  def white_turn({:call, from}, {:win, :black}, state_data) do
    {:next_state, :black_won, state_data, {:reply, from, :ok}}
  end

  def white_turn({:call, from}, :current_state, _state_data) do
    {:keep_state_and_data, {:reply, from, :white_turn}}
  end

  def white_turn({:call, from}, _, _state_data) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

  def black_turn({:call, from}, {:move, :black}, state_data) do
    {:next_state, :white_turn, state_data, {:reply, from, :ok}}
  end

  def black_turn({:call, from}, {:pass, :black}, state_data) do
    {:next_state, :white_turn, state_data, {:reply, from, :ok}}
  end

  def black_turn({:call, from}, {:retire, :black}, state_data) do
    {:next_state, :white_won, state_data, {:reply, from, :ok}}
  end

  def black_turn({:call, from}, {:win, :black}, state_data) do
    {:next_state, :black_won, state_data, {:reply, from, :ok}}
  end

  def black_turn({:call, from}, {:win, :white}, state_data) do
    {:next_state, :white_won, state_data, {:reply, from, :ok}}
  end

  def black_turn({:call, from}, :current_state, _state_data) do
    {:keep_state_and_data, {:reply, from, :black_turn}}
  end

  def black_turn({:call, from}, _, _state_data) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

  def white_won({:call, from}, :current_state, _state_data) do
    {:keep_state_and_data, {:reply, from, :white_won}}
  end

  def white_won({:call, from}, _, _state_data) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

  def black_won({:call, from}, :current_state, _state_data) do
    {:keep_state_and_data, {:reply, from, :black_won}}
  end

  def black_won({:call, from}, _, _state_data) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

end
