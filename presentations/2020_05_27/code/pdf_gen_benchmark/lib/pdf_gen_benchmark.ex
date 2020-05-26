defmodule PdfGenBenchmark do
  alias PdfGenBenchmark.PythonPort
  alias PdfGenBenchmark.PythonWorker

  @number_of_tests 30
  @timeout 6_000

  def poolboy do
    1..@number_of_tests
    |> Enum.map(fn i -> Task.async(fn -> poolboy(i) end) end)
    |> Enum.each(fn task -> Task.await(task, :infinity) end)
  end

  def poolboy(i) do
    html = generate_html()
    file_name = get_pdf_file_name("poolboy", i)

    :poolboy.transaction(
      :worker,
      fn pid ->
        try do
          PythonWorker.generate(i, pid, html, file_name)
        catch
          :exit, _error ->
            IO.puts("timeout: #{file_name}")
        end
      end,
      @timeout
    )
  end

  def api() do
    1..@number_of_tests
    |> Enum.map(fn i -> Task.async(fn -> api(i) end) end)
    |> Enum.map(fn proc -> Task.await(proc, :infinity) end)
  end

  def api(i) do
    html = generate_html()

    {:ok, %HTTPoison.Response{body: body}} =
      HTTPoison.post(
        "http://127.0.0.1:5000/",
        Jason.encode!(%{html: html}),
        [
          {"Content-Type", "application/json"}
        ],
        recv_timeout: 999_999_999
      )

    File.write!(get_pdf_file_name("api", i), body)
  end

  def weasyprint_cmd() do
    1..@number_of_tests
    |> Enum.map(fn i -> Task.async(fn -> weasyprint_cmd(i) end) end)
    |> Enum.map(fn proc -> Task.await(proc, :infinity) end)
  end

  def weasyprint_cmd(i) do
    System.cmd(
      "weasyprint",
      [
        Path.join(:code.priv_dir(:pdf_gen_benchmark), "template.html"),
        get_pdf_file_name("weasyprint_cmd", i)
      ],
      stderr_to_stdout: true
    )
  end

  def weasyprints_port() do
    pid = default_instance()

    1..@number_of_tests
    |> Enum.map(fn i -> Task.async(fn -> weasyprint_port(pid, i) end) end)
    |> Enum.map(fn proc -> Task.await(proc, :infinity) end)

    :python.stop(pid)
  end

  def weasyprint_port() do
    pid = default_instance()

    weasyprint_port(pid, 1)

    :python.stop(pid)
  end

  defp weasyprint_port(pid, i) do
    html = generate_html()
    pdf_file_name = get_pdf_file_name("weasyprint_port", i)
    PythonPort.call_python(pid, :pdf_generator, :generate, [html, pdf_file_name])
  end

  defp default_instance() do
    path = Path.join([:code.priv_dir(:pdf_gen_benchmark), "python"])
    PythonPort.python_instance(to_charlist(path))
  end

  defp get_pdf_file_name(type, i) do
    Path.join([
      :code.priv_dir(:pdf_gen_benchmark),
      "pdfs",
      type,
      "template_#{i}.pdf"
    ])
  end

  defp generate_html() do
    EEx.eval_file(
      Path.join(:code.priv_dir(:pdf_gen_benchmark), "template.html"),
      report: %{
        account_id: "BF - 38abf11c",
        flex: "-",
        date: "March 31, 2020",
        currencies_data: [
          %{
            symbol: "BTC",
            in_usd: "6,438,64",
            interest_earned: "0.0008",
            interest_earned_in_usd: "5.27",
            bonus_earned: "0.0000",
            bonus_earned_in_usd: "0.00",
            ending_balance: "0.2506",
            ending_balance_in_usd: "1,613.21"
          },
          %{
            symbol: "ETH",
            in_usd: "133.59",
            interest_earned: "0.0000",
            interest_earned_in_usd: "0.00",
            bonus_earned: "0.0000",
            bonus_earned_in_usd: "0.00",
            ending_balance: "0.0002",
            ending_balance_in_usd: "0.02"
          },
          %{
            symbol: "GUSD",
            in_usd: "1.00",
            interest_earned: "0.0000",
            interest_earned_in_usd: "0.00",
            bonus_earned: "0.0000",
            bonus_earned_in_usd: "0.00",
            ending_balance: "0.0012",
            ending_balance_in_usd: "0.00"
          },
          %{
            symbol: "LTC",
            in_usd: "39.30",
            interest_earned: "0.0000",
            interest_earned_in_usd: "0.00",
            bonus_earned: "0.0000",
            bonus_earned_in_usd: "0.00",
            ending_balance: "0.0000",
            ending_balance_in_usd: "0.00"
          },
          %{
            symbol: "USDC",
            in_usd: "1.00",
            interest_earned: "0.0029",
            interest_earned_in_usd: "0.00",
            bonus_earned: "0.0000",
            bonus_earned_in_usd: "0.00",
            ending_balance: "0.0049",
            ending_balance_in_usd: "0.00"
          },
          %{
            symbol: "PAX",
            in_usd: "1.00",
            interest_earned: "0.0000",
            interest_earned_in_usd: "0.00",
            bonus_earned: "0.0000",
            bonus_earned_in_usd: "0.00",
            ending_balance: "0.0000",
            ending_balance_in_usd: "0.00"
          }
        ],
        interest_earned_in_usd: "5.27",
        bonus_earned_in_usd: "0.00",
        ending_balance_in_usd: "1,613.23"
      }
    )
  end
end
