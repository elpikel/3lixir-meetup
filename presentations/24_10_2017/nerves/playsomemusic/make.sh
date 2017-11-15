export MIX_TARGET=rpi3
mix deps.get
mix firmware
mix firmware.burn
