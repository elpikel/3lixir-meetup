defmodule PdfGenBenchmark.MixProject do
  use Mix.Project

  def project do
    [
      app: :pdf_gen_benchmark,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PdfGenBenchmark.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:pdf_generator, ">=0.6.0"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:benchee, "~> 1.0", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:erlport, "~> 0.9"},
      {:poolboy, "~> 1.5.1"}
    ]
  end
end
