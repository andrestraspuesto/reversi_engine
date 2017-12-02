defmodule ReversiEngine.Mixfile do
  use Mix.Project

  def project do
    [
      app: :reversi_engine,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.5", only: :test},
      {:ex_doc, "~>0.12"},
      {:earmark, "~> 1.0", override: true},
      {:gen_state_machine, "~> 2.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
