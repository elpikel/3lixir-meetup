defmodule PlaySomeMusic do

  alias ElixirALE.GPIO

  @buzzer_pin Application.get_env(:play_some_music, :buzzer_pin)
  @cLS 139
  @dL 146
  @dLS 156
  @eL 163
  @fL 173
  @fLS 185
  @gLS 207
  @aL 219
  @aLS 228
  @bL 232

  @c 261
  @cS 277
  @d 294
  @dS 311
  @e 329
  @f 349
  @fS 370
  @g 391
  @gS 415
  @a 440
  @aS 455
  @b 466

  @cH 523
  @cHS 554
  @dH 587
  @dHS 622
  @eH 659
  @fH 698
  @fHS 740
  @gH 784
  @gHS 830
  @aH 880
  @aHS 910
  @bH 933

  def start(_type, _args) do
    {:ok, buzzer_pid} = GPIO.start_link(@buzzer_pin, :output)
    spawn fn -> buzz_forever(buzzer_pid) end
    {:ok, self()}
  end

  defp buzz_forever(buzzer_pid) do
    play(buzzer_pid, 7000)
  end

  defp play(buzzer_pid, initial_delay \\ 1000) do
    GPIO.write(buzzer_pid, 0)
    Process.sleep(initial_delay)

    beep(@a, 500, buzzer_pid)
    beep(@a, 500, buzzer_pid)
    beep(@f, 350, buzzer_pid)
    beep(@cH, 150, buzzer_pid)

    beep(@a, 500, buzzer_pid)
    beep(@f, 350, buzzer_pid)
    beep(@cH, 150, buzzer_pid)
    beep(@a, 1000, buzzer_pid)
    beep(@eH, 500, buzzer_pid)

    beep(@eH, 500, buzzer_pid)
    beep(@eH, 500, buzzer_pid)
    beep(@fH, 350, buzzer_pid)
    beep(@cH, 150, buzzer_pid)
    beep(@gS, 500, buzzer_pid)

    beep(@f, 350, buzzer_pid)
    beep(@cH, 150, buzzer_pid)
    beep(@a, 1000, buzzer_pid)
    beep(@aH, 500, buzzer_pid)
    beep(@a, 350, buzzer_pid)

    beep(@a, 150, buzzer_pid)
    beep(@aH, 500, buzzer_pid)
    beep(@gHS, 250, buzzer_pid)
    beep(@gH, 250, buzzer_pid)
    beep(@fHS, 125, buzzer_pid)

    beep(@fH, 125, buzzer_pid)
    beep(@fHS, 250, buzzer_pid)

    Microwait.wait_micros(250, yield: true)

    beep(@aS, 250, buzzer_pid)
    beep(@dHS, 500, buzzer_pid)
    beep(@dH, 250, buzzer_pid)
    beep(@cHS, 250, buzzer_pid)
    beep(@cH, 125, buzzer_pid)

    beep(@b, 125, buzzer_pid)
    beep(@cH, 250, buzzer_pid)

    Microwait.wait_micros(250, yield: true)

    beep(@f, 125, buzzer_pid)
    beep(@gS, 500, buzzer_pid)
    beep(@f, 375, buzzer_pid)
    beep(@a, 125, buzzer_pid)
    beep(@cH, 500, buzzer_pid)

    beep(@a, 375, buzzer_pid)
    beep(@cH, 125, buzzer_pid)
    beep(@eH, 1000, buzzer_pid)
    beep(@aH, 500, buzzer_pid)
    beep(@a, 350, buzzer_pid)

    beep(@a, 150, buzzer_pid)
    beep(@aH, 500, buzzer_pid)
    beep(@gHS, 250, buzzer_pid)
    beep(@gH, 250, buzzer_pid)
    beep(@fHS, 125, buzzer_pid)

    beep(@fH, 125, buzzer_pid)
    beep(@fHS, 250, buzzer_pid)

    Microwait.wait_micros(250, yield: true)

    beep(@aS, 250, buzzer_pid)
    beep(@dHS, 500, buzzer_pid)
    beep(@dH, 250, buzzer_pid)
    beep(@cHS, 250, buzzer_pid)
    beep(@cH, 125, buzzer_pid)

    beep(@b, 125, buzzer_pid)
    beep(@cH, 250, buzzer_pid)

    Microwait.wait_micros(250, yield: true)

    beep(@f, 250, buzzer_pid)
    beep(@gS, 500, buzzer_pid)
    beep(@f, 375, buzzer_pid)
    beep(@cH, 125, buzzer_pid)
    beep(@a, 500, buzzer_pid)

    beep(@f, 375, buzzer_pid)
    beep(@c, 125, buzzer_pid)
    beep(@a, 1000, buzzer_pid)
    
    play(buzzer_pid)
  end

  defp beep(note, duration, buzzer_pid) do
    beepDelay = round(1000000/note)
    time = if beepDelay == 0 do
      duration
    else
      round((duration*1000)/(beepDelay*2))
    end

    for _ <- 0..time do
      GPIO.write(buzzer_pid, 1)
      Microwait.wait_micros(beepDelay, yield: true)

      GPIO.write(buzzer_pid, 0)
      Microwait.wait_micros(beepDelay, yield: true)
    end

    GPIO.write(buzzer_pid, 0)
    Microwait.wait_micros(200, yield: true)
  end
end
