local addonName, shared = ...;

local addon = shared.addon;
local HandyNotes = shared.HandyNotes;
local nodes = shared.nodes;

local handler = {};

local tablepool = setmetatable({}, {__mode = 'k'})

-- This is a custom iterator we use to iterate over every node in a given zone
local function iter(t, prestate)
  if not t then return end
  local data = t.data
  local state, value = next(data, prestate)
  if value then
    local info = addon:getNodeInfo(state, value);
    if (info.display) then
      return state, zone, 'Interface\\Addons\\HandyNotes_PandariaTreasures\\Artwork\\RareIcon.tga', 1, 1
    end
  end
  wipe(t)
  tablepool[t] = true
end

-- This is a funky custom iterator we use to iterate over every zone's nodes
-- in a given continent + the continent itself
local function iterCont(t, prestate)
  if not t then return end
  local zone = t.C[t.Z]
  local data = nodes[zone]
  local state, value

  while zone do
    if data then -- Only if there is data for this zone
      state, value = next(data, prestate)
      while state do -- Have we reached the end of this zone?
        if value.cont or zone == t.contId then -- Show on continent?
          local info = addon:getNodeInfo(state, value);
          if (info.display) then
            return state, zone, 'Interface\\Addons\\HandyNotes_PandariaTreasures\\Artwork\\RareIcon.tga', 1, 1
          end
        end
        state, value = next(data, state) -- Get next data
      end
    end
    -- Get next zone
    t.Z = next(t.C, t.Z)
    zone = t.C[t.Z]
    data = nodes[zone]
    prestate = nil
  end
  wipe(t)
  tablepool[t] = true
end

function handler:GetNodes2(uiMapId, minimap)
  local C = HandyNotes:GetContinentZoneList(uiMapId) -- Is this a continent?
  if C then
    local tbl = next(tablepool) or {}
    tablepool[tbl] = nil
    tbl.C = C
    tbl.Z = next(C)
    tbl.contId = uiMapId
    return iterCont, tbl, nil
  else -- It is a zone
    local tbl = next(tablepool) or {}
    tablepool[tbl] = nil
    tbl.data = nodes[uiMapId] or {}
    return iter, tbl, nil
  end
end

local db = {};

local options = {
  type = "group",
  name = 'Handynotes Pandaria',
  desc = 'Handynotes Pandaria',
  get = function(info) return db[info.arg] end,
  set = function(info, v)
    db[info.arg] = v
  end,
  args = {
    desc = {
      name = 'Handynotes Pandaria Options.',
      type = "description",
      order = 0,
    },
    icon_scale = {
      type = 'range',
      name = 'Icon Scale',
      desc = 'The scale of the icons',
      min = 0.25, max = 2, step = 0.01,
      arg = "icon_scale",
      order = 10,
    },
    icon_alpha = {
      type = 'range',
      name = 'Icon Alpha',
      desc = 'The alpha transparency of the icons',
      min = 0, max = 1, step = 0.01,
      arg = "icon_alpha",
      order = 20,
    },
  },
}

HandyNotes:RegisterPluginDB(addonName, handler, options)
