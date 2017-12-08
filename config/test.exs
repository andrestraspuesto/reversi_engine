use Mix.Config

config :reversi_engine, :board_1, value: {
  {nil, nil, nil, nil},
  {nil, "B", "W", nil},
  {nil, "W", "B", nil},
  {nil, nil, nil, nil}
}

config :reversi_engine, :board_2, value: {
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, "B", "W", nil, nil, nil},
  {nil, nil, nil, "W", "B", nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil}
}

config :reversi_engine, :board_3, value: {
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, "B", "W", nil, nil, nil},
  {nil, nil, nil, "W", "B", nil, nil, nil},
  {nil, nil, "B", nil, nil, "W", nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil}
}

config :reversi_engine, :board_4, value: {
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, "W", nil, nil, "B", nil, nil},
  {nil, nil, nil, "B", "W", nil, nil, nil},
  {nil, nil, nil, "W", "B", nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil},
  {nil, nil, nil, nil, nil, nil, nil, nil}
}

config :reversi_engine, :board_test_pass, value: {
  {"W", nil, "W", nil},
  {nil, "B", "W", nil},
  {"W", "W", "B", nil},
  {nil, nil, nil, nil}
}

config :reversi_engine, :board_test_w_won, value: {
  {"W", "W", "W", nil},
  {nil, "W", "W", nil},
  {"W", "W", "B", nil},
  {nil, nil, nil, nil}
}

config :reversi_engine, :board_test_b_won, value: {
  {"W", "W", "W", "B"},
  {"B", "W", "W", nil},
  {"W", "W", "B", "B"},
  {"B", "B", "B", "B"}
}

config :reversi_engine, :board_test_b_won_2, value: {
  {"B", "B", "B", "B"},
  {"B", "W", "B", nil},
  {"W", "B", "B", "B"},
  {"B", "B", "B", "B"}
}

config :reversi_engine, :board_test_w_won_2, value: {
  {"W", "W", "W", "W"},
  {"B", "B", "W", nil},
  {"W", "W", "W", "W"},
  {"W", "W", "W", "W"}
}

config :reversi_engine, :board_test_empate, value: {
  {"W", "W", "W", "W"},
  {"W", "B", "W", nil},
  {"W", "W", "B", "B"},
  {"W", "B", "B", "B"}
}
