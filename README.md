# Ford-GT-Gauge

A pro-bono project made for Axis' Ford GT mod.

https://github.com/plus-and-other-arithmetic-operations/Ford-GT-Gauge/assets/88043761/36d4ce2e-64a4-4009-bf17-11b52ad97a01

This gauge features the Ford GT's Sport & Track mode, with animated transitions between the 2.

## Setup

Install the required fonts (whittle & aria)

Add the script entry into the car's ext_config

```ini
[SCRIPTABLE_DISPLAY_...]
ACTIVE = 1
MESHES = INT_GAUGESCREEN
RESOLUTION = 1024,1024
DISPLAY_POS = 0,0
DISPLAY_SIZE = 1024,1024
SKIP_FRAMES = 0
SCRIPT = gauge.lua
```
