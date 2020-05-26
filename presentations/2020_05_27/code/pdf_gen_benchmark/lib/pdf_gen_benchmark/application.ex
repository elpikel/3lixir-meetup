defmodule PdfGenBenchmark.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp poolboy_config do
    [
      name: {:local, :worker},
      worker_module: PdfGenBenchmark.PythonWorker,
      size: 5,
      max_overflow: 0
    ]
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: PdfGenBenchmark.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
