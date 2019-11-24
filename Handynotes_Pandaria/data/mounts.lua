local addonName, shared = ...;

local rareInfo = shared.rareInfo;

local mountMap = {
  [94229] = 69769,
  [94230] = 69769,
  [94231] = 69769,
  [90655] = 64403,
  [104269] = 73167,
};

for mountId, rareId in pairs(mountMap) do
  rareInfo[rareId] = rareInfo[rareId] or {};
  data = rareInfo[rareId];
  data.mounts = data.mounts or {};
  table.insert(data.mounts, mountId);
end
