defmodule DestroyTheWorld do
  use Application
  require Logger

  alias ElixirALE.GPIO
  @output_pin Application.get_env(:destroy_the_world, :output_pin)

  def start(_type, _args) do
    Logger.info "Starting pin #{@output_pin} as output"
    {:ok, output_pid} = GPIO.start_link(@output_pin, :output)
    spawn fn -> toggle_led(output_pid) end

    {:ok, self()}
  end

  defp toggle_led(output_pid) do
    Logger.info "Toggle sequence"
    GPIO.write(output_pid, 1)
    Process.sleep(400)
    GPIO.write(output_pid, 0)
    Process.sleep(400)
    GPIO.write(output_pid, 1)
    Process.sleep(400)
    GPIO.write(output_pid, 0)
    Process.sleep(400)
    GPIO.write(output_pid, 1)
    Process.sleep(400)
    GPIO.write(output_pid, 0)

    Process.sleep(1000)
    toggle_led(output_pid)
  end
end
