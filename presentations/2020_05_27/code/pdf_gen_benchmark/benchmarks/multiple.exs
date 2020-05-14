Benchee.run(
  %{
    "api" => fn -> PdfGenBenchmark.api() end,
    "weasyprint_cmd" => fn -> PdfGenBenchmark.weasyprint_cmd() end,
    "weasyprint_port" => fn -> PdfGenBenchmark.weasyprints_port() end
  },
  formatters: [
    {Benchee.Formatters.HTML, file: "benchmarks/results/multiple.html"},
    Benchee.Formatters.Console
  ]
)
