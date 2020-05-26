defmodule PdfGenBenchmark.PythonWorker do
  use GenServer

  alias PdfGenBenchmark.PythonPort

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    path = Path.join([:code.priv_dir(:pdf_gen_benchmark), "python"])
    pid = PythonPort.python_instance(to_charlist(path))

    {:ok, %{python_pid: pid}}
  end

  def terminate(_reason, %{python_pid: pid}) do
    :python.stop(pid)
  end

  def generate(i, pid, html, file_name) do
    GenServer.call(pid, %{html: html, file_name: file_name})
  end

  def handle_call(%{html: html, file_name: file_name}, _from, %{python_pid: pid} = state) do
    PythonPort.call_python(pid, :pdf_generator, :generate, [html, file_name])

    {:reply, :ok, state}
  end
end
