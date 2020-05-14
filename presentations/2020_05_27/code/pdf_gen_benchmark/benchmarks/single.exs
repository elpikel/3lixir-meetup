Benchee.run(
  %{
    "api" => fn -> PdfGenBenchmark.api(1) end,
    "weasyprint_cmd" => fn -> PdfGenBenchmark.weasyprint_cmd(1) end,
    "weasyprint_port" => fn -> PdfGenBenchmark.weasyprint_port() end
  },
  formatters: [
    {Benchee.Formatters.HTML, file: "benchmarks/results/single.html"},
    Benchee.Formatters.Console
  ]
)
