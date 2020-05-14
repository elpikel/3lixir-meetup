defmodule ElixirPython do
  alias ElixirPython.Helper

  def encode(data) do
    call_python(:encoder, :encode, [data])
  end

  def add(pid) do
    result = Helper.call_python(pid, :adder, :add, [1, 1])
    result
  end

  def adds do
    pid = default_instance()

    1..30
    |> Enum.map(fn _ -> Task.async(fn -> add(pid) end) end)
    |> Enum.map(fn proc -> Task.await(proc, :infinity) end)

    :python.stop(pid)
  end

  def add(a, b) do
    call_python(:adder, :add, [a, b])
  end

  def divide(a, b) do
    try do
      call_python(:divider, :divide, [a, b])
    rescue
      e in ErlangError -> IO.inspect(e)
    end
  end

  def generate_pdfs() do
    pid = default_instance()

    1..100
    |> Enum.map(fn i -> Task.async(fn -> generate(pid, i) end) end)
    |> Enum.map(fn proc -> Task.await(proc, :infinity) end)

    :python.stop(pid)
  end

  def generate_pdf() do
    pid = default_instance()

    generate(pid, 1)

    :python.stop(pid)
  end

  def generate(pid, i) do
    html = generate_html()
    IO.inspect(html)
    Helper.call_python(pid, :gen, :generate, [html, i])
  end

  def default_instance() do
    # Load all modules in our priv/python directory
    path = Path.join([:code.priv_dir(:elixir_python), "python"])
    Helper.python_instance(to_charlist(path))
  end

  # wrapper function to call python functions using
  # default python instance
  defp call_python(module, function, args) do
    pid = default_instance()

    result = Helper.call_python(pid, module, function, args)
    :python.stop(pid)
    result
  end

  def generate_html() do
    EEx.eval_file(
      Path.join(:code.priv_dir(:elixir_python), "template.html"),
      report: %{
        account_id: "BF - 38abf11c",
        flex: "-",
        date: "March 31, 2020",
        currencies_data: [
          %{
            symbol: "BTC",
            in_usd: "6438",
            interest_earned: "",
            interest_earned_in_usd: "",
            bonus_earned: "",
            bonus_earned_in_usd: "",
            ending_balance: "",
            ending_balance_in_usd: ""
          },
          %{
            symbol: "BTC",
            in_usd: "6438",
            interest_earned: "",
            interest_earned_in_usd: "",
            bonus_earned: "",
            bonus_earned_in_usd: "",
            ending_balance: "",
            ending_balance_in_usd: ""
          },
          %{
            symbol: "BTC",
            in_usd: "6438",
            interest_earned: "",
            interest_earned_in_usd: "",
            bonus_earned: "",
            bonus_earned_in_usd: "",
            ending_balance: "",
            ending_balance_in_usd: ""
          },
          %{
            symbol: "BTC",
            in_usd: "6438",
            interest_earned: "",
            interest_earned_in_usd: "",
            bonus_earned: "",
            bonus_earned_in_usd: "",
            ending_balance: "",
            ending_balance_in_usd: ""
          },
          %{
            symbol: "BTC",
            in_usd: "6438",
            interest_earned: "",
            interest_earned_in_usd: "",
            bonus_earned: "",
            bonus_earned_in_usd: "",
            ending_balance: "",
            ending_balance_in_usd: ""
          },
          %{
            symbol: "BTC",
            in_usd: "6438",
            interest_earned: "",
            interest_earned_in_usd: "",
            bonus_earned: "",
            bonus_earned_in_usd: "",
            ending_balance: "",
            ending_balance_in_usd: ""
          }
        ],
        interest_earned_in_usd: "",
        bonus_earned_in_usd: "",
        ending_balance_in_usd: ""
      },
      trim: true
    )
  end
end
