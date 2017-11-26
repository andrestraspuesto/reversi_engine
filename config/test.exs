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
