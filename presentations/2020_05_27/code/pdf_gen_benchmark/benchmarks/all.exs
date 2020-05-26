Benchee.run(
  %{
    "poolboy-30" => fn -> PdfGenBenchmark.poolboy() end,
    "poolboy-1" => fn -> PdfGenBenchmark.poolboy(1) end,
    "api-30" => fn -> PdfGenBenchmark.api() end,
    "api-1" => fn -> PdfGenBenchmark.api(1) end,
    "weasyprint_cmd-30" => fn -> PdfGenBenchmark.weasyprint_cmd() end,
    "weasyprint_cmd-1" => fn -> PdfGenBenchmark.weasyprint_cmd(1) end,
    "weasyprint_port-30" => fn -> PdfGenBenchmark.weasyprints_port() end,
    "weasyprint_port-1" => fn -> PdfGenBenchmark.weasyprint_port() end
  },
  formatters: [
    {Benchee.Formatters.HTML, file: "benchmarks/results/all.html"},
    Benchee.Formatters.Console
  ]
)
