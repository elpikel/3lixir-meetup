# Recorded with the doitlive recorder
#doitlive shell: /bin/bash
#doitlive prompt: default

export MIX_TARGET=rpi3

mix deps.get

mix firmware

mix firmware.burn


