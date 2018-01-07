-- OpenFetch 1.0 for OpenComputers, Lua 5.3
-- Written by skielred <skielred@gmail.com>
-- 2018

local computer  = require("computer")
local shell     = require("shell")
local text      = require("text")
local os        = require("os")
local component = require("component")

local devices = computer.getDeviceInfo()

local function getCPU()
  for at, info in pairs(devices) do
    if info["description"] == "CPU" then
      return string.format("%s @ %sHz", info["product"], info["clock"])
    end
  end
  return nil
end

local function getGPU()
  for at, info in pairs(devices) do
    if info["description"] == "Graphics controller" then
      return info["product"]
    end
  end
  return nil
end

local function getEnv(key)
  for name, value in pairs(os.getenv()) do
    if key == name then
      return value
    end
  end
  return nil
end

local function getMemUsage()
  free = computer.freeMemory() / 1024
  total = computer.totalMemory() / 1024
  return string.format("%.2fK / %.2fK", total - free, total)
end

local function getUptime()
  s = computer.uptime()
  m = 0
  h = 0
  d = 0
  while s >= 60 do
    s = s - 60
    m = m + 1
  end
  while m >= 60 do
    m = m - 60
    h = h + 1
  end
  while h >= 60 do
    h = h - 60
    d = d + 1
  end
  local function f(str, num)
    result = num .. " " .. str
    if num > 1 then
      result = result .. "s"
    end
    return result
  end
  return string.format("%s, %s, %s", f("day", d), f("hour", h), f("minute", m))
end

local function getRes()
  width, height = component.gpu.getResolution()
  return string.format("%sx%s characters", width, height)
end

local function ofPrint(name, value)
  if value then
    print(string.format("%s: %s", name, value))
  end
end

ofPrint("Terminal", getEnv("TERM"))
ofPrint("Shell", getEnv("SHELL"))
ofPrint("Uptime", getUptime())
ofPrint("CPU", getCPU())
ofPrint("GPU", getGPU())
ofPrint("Resolution", getRes())
ofPrint("RAM", getMemUsage())
