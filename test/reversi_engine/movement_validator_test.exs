defmodule ReversiEngine.MovementValidatorTest do
  use ExUnit.Case
  doctest ReversiEngine.MovementValidator
  alias ReversiEngine.MovementValidator

  @board_1  Application.get_env(:reversi_engine, :board_1)[:value]

  @board_2  Application.get_env(:reversi_engine, :board_2)[:value]

  @board_3  Application.get_env(:reversi_engine, :board_3)[:value]

  @board_4  Application.get_env(:reversi_engine, :board_4)[:value]

  test "posicion contigua izquierda valida" do
    assert MovementValidator.validate_movement(@board_1, "B", %{x: 0, y: 2}) == [%{x: 1, y: 2}]
  end

  test "posicion contigua derecha valida" do
    assert MovementValidator.validate_movement(@board_1, "B", %{x: 3, y: 1}) == [%{x: 2, y: 1}]
  end

  test "posicion contigua arriba valida" do
    assert MovementValidator.validate_movement(@board_1, "B", %{x: 2, y: 0}) == [%{x: 2, y: 1}]
  end

  test "posicion contigua abajo valida" do
    assert MovementValidator.validate_movement(@board_1, "B", %{x: 1, y: 3}) == [%{x: 1, y: 2}]
  end

  test "posicion contigua diagonal arriba - izquierda  no valida" do
    assert MovementValidator.validate_movement(@board_1, "B", %{x: 0, y: 0}) == []
  end

  test "posicion contigua no valida por mismo color" do
    assert MovementValidator.validate_movement(@board_1, "W", %{x: 0, y: 2}) == []
  end

  test "posicion aislada no valida" do
    assert MovementValidator.validate_movement(@board_2, "W", %{x: 1, y: 2}) == []
  end

  test "posicion contigua diagonal arriba - izquierda valida" do
    expected = [%{x: 3, y: 3}, %{x: 4, y: 4}]
    MovementValidator.validate_movement(@board_3, "W", %{x: 2, y: 2})
    |> is_same(expected)
  end

  test "posicion contigua diagonal arriba - derecha valida" do
    expected = [%{x: 4, y: 3}, %{x: 3, y: 4}]
    MovementValidator.validate_movement(@board_3, "B", %{x: 5, y: 2})
    |> is_same(expected)
  end


  test "posicion contigua diagonal abajo - izquierda valida" do
    expected = [%{x: 4, y: 3}, %{x: 3, y: 4}]
    MovementValidator.validate_movement(@board_4, "B", %{x: 2, y: 5})
    |> is_same(expected)
  end

  test "posicion contigua diagonal abajo - derecha valida" do
    expected = [%{x: 3, y: 3}, %{x: 4, y: 4}]
    MovementValidator.validate_movement(@board_4, "W", %{x: 5, y: 5})
    |> is_same(expected)
  end

  defp is_same(l1, l2) do
    assert length(Enum.uniq(l1 ++ l2)) == length(l1) && Enum.all?(l1, &Enum.member?(l2, &1))
  end
end
