

-------------------------------------------------------------------------------------------

local maxFuel = car.maxFuel -- Maximum fuel in tank, in liters
local fuelConsumption = 0.0050 -- Fetch this from car.ini/[FUEL] section (couldn't figure out ac.readDataFile())
local currentLitersAvailable = car.fuel
local maxMiles = 300 -- Maximum range for the car to drive with a full tank (in miles)  
local fordFont = 'Whittle' -- font for numbers
local fordFont2 = 'aria' -- font for text
local hudPath = "GAUG.png"
local gaugePath = "TFAMIFOLLOWING.png"
local bgPath = "BACKGROUND2.png"
local screenRes = 1024
local resMult = 2
local revOrange = rgb(247/255,185/255,50/255)

function RenderHUD()
  display.image{image = hudPath,pos = vec2(0,0),size = vec2(screenRes,screenRes) ,uvStart = vec2(0,0),uvEnd = vec2(1, 1)}
end

function RenderBG()
  display.image{image = bgPath,pos = vec2(0,0),size = vec2(screenRes,screenRes) ,uvStart = vec2(0,0),uvEnd = vec2(1, 1)}
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

function DrawWaterBar()

  display.horizontalBar({
        pos = vec2(29*resMult,141*resMult),
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

  display.text({
    text = string.format("%03d",math.round((car.waterTemperature*1.8) + 32)), --string formatting to pad 0's
    pos = vec2(61*resMult,126*resMult),
    letter = vec2(13*resMult,19*resMult),
    font = fordFont,
    color = rgbm.colors.white,
    alignment = 0,
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

function DrawGearDisplay()
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

function DrawSpeedDisplay()
  display.text({
    text = string.format("%03d",math.round(car.speedKmh/1.609344)), --string formatting to pad 0's
    pos = vec2(365*resMult,174*resMult),
    letter = vec2(48*resMult, 72*resMult),
    font = fordFont,
    color = rgbm.colors.white,
    alignment = 0,
    width = 200,
    spacing = -12
  })
end

function DrawOdometer()
  display.text({
    text = string.format("%06.01f",car.distanceDrivenTotalKm/1.609344), --string formatting to pad 0's
    pos = vec2(387*resMult,236*resMult),
    letter = vec2(18*resMult, 26*resMult),
    font = fordFont,
    color = rgbm.colors.white,
    alignment = 0,
    width = 200,
    spacing = -10
  })
end

function DrawRevBars() --do uv start and uv end image drawing, solid orange rectangle for tip of rpm bar and dotted rectangle for revs
  local rpm = car.rpm
  
  local multiplier = 408 * (0.65 + ((rpm + (rpm/5))/6800))
  --ac.log(multiplier)
  
  display.image{image = gaugePath,pos = vec2(0,0),size = vec2(screenRes,screenRes) ,uvStart = vec2(0,0),uvEnd = vec2(1, 1)}
  display.rect({ pos = vec2(55 + ((rpm*multiplier)/7000),190), size = vec2(780,300), color = rgbm.colors.black })
  display.rect({ pos = vec2(55 + ((rpm*multiplier)/7000),190), size = vec2(5,300), color = revOrange })
end

function script.update(dt)
  DrawRevBars()
  RenderBG()
  RenderHUD()
  DrawFuelBar()
  DrawWaterBar()
  DrawGearMode()
  DrawRPM()
  DrawGearDisplay()
  DrawOdometer()
  DrawSpeedDisplay()
end