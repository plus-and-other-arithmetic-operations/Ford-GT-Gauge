

-------------------------------------------------------------------------------------------

local maxFuel = car.maxFuel -- Maximum fuel in tank, in liters
local fuelConsumption = 0.0050 -- Fetch this from car.ini/[FUEL] section (couldn't figure out ac.readDataFile())
local currentLitersAvailable = car.fuel
local maxMiles = 300 -- Maximum range for the car to drive with a full tank (in miles)  
local fordFont = 'Whittle' -- font for numbers
local fordFont2 = 'aria' -- font for text
local hudPath = "GAUG.png"
local hud2Path = "GAUG2.png"
local gaugePath = "TFAMIFOLLOWING.png"
local gauge2Path = "TFAMIFOLLOWING2.png"
local bgPath = "BACKGROUND2.png"
local screenRes = 1024
local resMult = 2
local revOrange = rgb(247/255,185/255,50/255)
local revRed = rgb(146/255,13/255,28/255)
local grey = rgbm(160/255,160/255,160/255,1)

function RenderHUD(hud)
  display.image{ image = hud, pos = vec2(0,0), size = vec2(screenRes,screenRes), uvStart = vec2(0,0), uvEnd = vec2(1, 1) }
end

function RenderBG()
  display.image{ image = bgPath, pos = vec2(0,0), size = vec2(screenRes,screenRes), uvStart = vec2(0,0), uvEnd = vec2(1, 1) }
end

function DrawFuelBar()
  display.horizontalBar({
        pos = vec2(29*resMult,122*resMult),
        size = vec2(66*resMult, 2*resMult),
        delta = 0,
        activeColor = rgbm.colors.white,
        inactiveColor = rgbm.colors.gray,
        total = maxFuel,
        active = car.fuel
  })

  for i = 44, 79, 17 do
    display.rect({ pos = vec2(i*resMult,122*resMult), size = vec2(2*resMult,2*resMult), color = rgbm.colors.black }) --overlaying black rectangles to allow for a 4 sectioned smooth bar
  end

  currentLiters100 = (car.rpm * car.gas * fuelConsumption)/1000 --Fuel consumption. In one second the consumption is (rpm*gas*CONSUMPTION)/1000 litres
  currentLitersAvailable = car.fuel - currentLiters100 --Current liters available in the tank
  currentRange = math.max(0,currentLitersAvailable * maxMiles/90) --Current mileage range

  display.text({
    text = math.round(currentRange),
    pos = vec2(61*resMult,107*resMult),
    letter = vec2(13*resMult,19*resMult),
    font = fordFont,
    color = rgbm.colors.white,
    alignment = 0,
    width = 200,
    spacing = -3
  })
end

function DrawWaterBar(x, y, displayBar, isGrey)

  local waterColor = rgbm.colors.white
  if isGrey then
    waterColor = grey
  end

  if displayBar then
    display.horizontalBar({
          pos = vec2(x*resMult, y*resMult),
          size = vec2(66*resMult, 2*resMult),
          delta = 0,
          activeColor = rgbm.colors.white,
          inactiveColor = rgbm.colors.gray,
          total = 740,
          active = (car.waterTemperature*1.8) + 32  --farenheit conversion
    })

    for i = 44, 79, 17 do
      display.rect({ pos = vec2(i*resMult,141*resMult), size = vec2(2*resMult,2*resMult), color = rgbm.colors.black }) --overlaying black rectangles to allow for a 4 sectioned smooth bar
    end
  end

  display.text({
    text = string.format("%03d",math.round((car.waterTemperature*1.8) + 32)), --string formatting to pad 0's
    pos = vec2((x+32)*resMult,(y-15)*resMult),
    letter = vec2(13*resMult,19*resMult),
    font = fordFont,
    color = waterColor,
    alignment = 0,
    width = 200,
    spacing = -3
  })
end

function DrawOilTempBar(x, y, displayBar)
  if displayBar then
    display.horizontalBar({
          pos = vec2(x*resMult, y*resMult),
          size = vec2(66*resMult, 2*resMult),
          delta = 0,
          activeColor = rgbm.colors.white,
          inactiveColor = rgbm.colors.gray,
          total = 740,
          active = (car.oilTemperature*1.8) + 32  --farenheit conversion
    })

    for i = 44, 79, 17 do
      display.rect({ pos = vec2(i*resMult,141*resMult), size = vec2(2*resMult,2*resMult), color = rgbm.colors.black }) --overlaying black rectangles to allow for a 4 sectioned smooth bar
    end
  end

  display.text({
    text = string.format("%03d",math.round((car.oilTemperature*1.8) + 32)), --string formatting to pad 0's
    pos = vec2((x+32)*resMult,(y-15)*resMult),
    letter = vec2(13*resMult,19*resMult),
    font = fordFont,
    color = grey,
    alignment = 0,
    width = 200,
    spacing = -3
  })
end

function DrawOilPressureBar(x, y, displayBar)
  if displayBar then
    display.horizontalBar({
          pos = vec2(x*resMult, y*resMult),
          size = vec2(66*resMult, 2*resMult),
          delta = 0,
          activeColor = rgbm.colors.white,
          inactiveColor = rgbm.colors.gray,
          total = 740,
          active = car.oilPressure*14.504 --psi conversion
    })

    for i = 44, 79, 17 do
      display.rect({ pos = vec2(i*resMult,141*resMult), size = vec2(2*resMult,2*resMult), color = rgbm.colors.black }) --overlaying black rectangles to allow for a 4 sectioned smooth bar
    end
  end

  display.text({
    text = math.round(car.oilPressure*14.504),
    pos = vec2((x+32)*resMult,(y-15)*resMult),
    letter = vec2(13*resMult,19*resMult),
    font = fordFont,
    color = grey,
    alignment = 0,
    width = 200,
    spacing = -3
  })
end

function DrawFuelPercentage(x, y)
  display.text({
    text = math.round((car.fuel/maxFuel)*100),
    pos = vec2((x-32)*resMult,(y-15)*resMult),
    letter = vec2(13*resMult,19*resMult),
    font = fordFont,
    color = grey,
    alignment = 1,
    width = 200,
    spacing = -3
  })
end

function DrawGearMode()

  if car.handbrake > 0 then
    display.text({
      text = 'P',
      pos = vec2(25*resMult,239*resMult),
      letter = vec2(14.5*resMult,25*resMult),
      font = fordFont2,
      color = rgbm.colors.white,
      alignment = 0,
      width = 200,
      spacing = -3
    })
    display.text({
      text = 'BRAKE',
      pos = vec2(303*resMult,245*resMult),
      letter = vec2(4.5*resMult,15*resMult),
      font = fordFont2,
      color = rgbm.colors.red,
      alignment = 0,
      width = 200,
      spacing = 0
    })
  elseif car.gear == 0 then
    display.text({
      text = 'N',
      pos = vec2(59.75*resMult,239*resMult),
      letter = vec2(14.5*resMult,25*resMult),
      font = fordFont2,
      color = rgbm.colors.white,
      alignment = 0,
      width = 200,
      spacing = -3
    })
  elseif car.gear == -1 then
    display.text({
      text = 'R',
      pos = vec2(41.5*resMult,239*resMult),
      letter = vec2(14.5 *resMult,25*resMult),
      font = fordFont2,
      color = rgbm.colors.white,
      alignment = 0,
      width = 200,
      spacing = -3
    })
  else
    display.text({
      text = 'M',
      pos = vec2(97.4*resMult,239*resMult),
      letter = vec2(15*resMult,25*resMult),
      font = fordFont2,
      color = rgbm.colors.white,
      alignment = 0,
      width = 200,
      spacing = -3
    })
  end
end

function DrawRPM()
  display.text({
    text = math.round(car.rpm), --string formatting to pad 0's
    pos = vec2(419*resMult,117*resMult),
    letter = vec2(17*resMult,25*resMult),
    font = fordFont,
    color = rgbm.colors.white,
    alignment = 0,
    width = 200,
    spacing = -3
  })

end


function GetCurrentGear()
  if car.gear == 0 then
    return 'N'
  elseif car.gear == -1 then
    return 'R'
  else
    return car.gear
  end
end

function DrawGearDisplay(outlineColor)
  display.text({
    text = GetCurrentGear(),
    pos = vec2(216.5*resMult ,140*resMult),
    letter = vec2(91*resMult, 141*resMult),
    font = fordFont,
    color = outlineColor,
    alignment = 0,
    width = 200,
    spacing = 0
  })

  display.text({
    text = GetCurrentGear(),
    pos = vec2(217*resMult ,140*resMult),
    letter = vec2(90*resMult, 140*resMult),
    font = fordFont,
    color = rgbm.colors.white,
    alignment = 0,
    width = 200,
    spacing = 0
  })

end

function DrawSpeedDisplay(x, y, sx, sy, isGrey)
  local speedColor = rgbm.colors.white
  if isGrey then
    speedColor = grey
  end

  display.text({
    text = string.format("%03d",math.round(car.speedKmh/1.609344)), --string formatting to pad 0's
    pos = vec2(x*resMult,y*resMult),
    letter = vec2(sx*resMult, sy*resMult),
    font = fordFont,
    color = speedColor,
    alignment = 0,
    width = 200,
    spacing = -12
  })
end

function DrawOdometer(isGrey)
  local odoColor = rgbm.colors.white
  if isGrey then
    odoColor = grey
  end

  display.text({
    text = string.format("%6.01f",car.distanceDrivenTotalKm/1.609344), --string formatting to pad 0's
    pos = vec2(369*resMult,236*resMult),
    letter = vec2(18*resMult, 26*resMult),
    font = fordFont,
    color = odoColor,
    alignment = 1,
    width = 200,
    spacing = -10
  })
end

function DrawRevBars(gauge, tipColor) --do uv start and uv end image drawing, solid orange rectangle for tip of rpm bar and dotted rectangle for revs
  local multiplier = 408 * (0.65 + ((car.rpm + (car.rpm/5))/6800))

  display.image{ image = gauge, pos = vec2(0, 0), size = vec2(screenRes, screenRes), uvStart = vec2(0, 0), uvEnd = vec2(1, 1) }
  display.rect( { pos = vec2(55 + ((car.rpm*multiplier)/7000), 190), size = vec2(780, 300), color = rgbm.colors.black })
  display.rect( { pos = vec2(55 + ((car.rpm*multiplier)/7000), 190), size = vec2(5, 300), color = tipColor })
end


local player = ui.MediaPlayer("GAUGMIDAS.mp4")
local player2 = ui.MediaPlayer("GAUGMIDAS2.mp4")
player:play()
player2:play()
local shouldPlay = true
local shouldPlay2 = true
function script.update(dt)
  if car.extraC then
    -- Track Mode screen
    shouldPlay2 = true
    player2:setCurrentTime(0)

    if shouldPlay then
      if player:ended() then
        shouldPlay = false
      else
        display.image{ image = player, pos = vec2(0,0), size = vec2(screenRes,screenRes), uvStart = vec2(0,0), uvEnd = vec2(1, 1) }
      end

    else
      DrawRevBars(gauge2Path, revRed)
      RenderBG()
      RenderHUD(hud2Path)
      DrawWaterBar(396, 191, false, true)
      DrawOilTempBar(396, 204, false)
      DrawOilPressureBar(407, 221, false)
      DrawFuelPercentage(396, 234)
      DrawGearMode()
      DrawRPM()
      DrawGearDisplay(revRed)
      DrawOdometer(true)
      DrawSpeedDisplay(25, 100, 35, 50, true)
    end
  else
    -- Sport screen
    shouldPlay = true
    player:setCurrentTime(0)

    if shouldPlay2 then
      if player2:ended() then
        shouldPlay2 = false
      else
        display.image{ image = player2, pos = vec2(0,0), size = vec2(screenRes,screenRes), uvStart = vec2(0,0), uvEnd = vec2(1, 1) }
      end
    else
      DrawRevBars(gaugePath, revOrange)
      RenderBG()
      RenderHUD(hudPath)
      DrawFuelBar()
      DrawWaterBar(29, 141, true, false)
      DrawGearMode()
      DrawRPM()
      DrawGearDisplay(revOrange)
      DrawOdometer(false)
      DrawSpeedDisplay(365, 174, 48, 72, false)
    end
  end
end