local addonName, shared = ...;

local rareInfo = shared.rareInfo;

local mountMap = {
  [94229] = 970000,
  [94230] = 970000,
  [94231] = 970000,
  [90655] = 64403,
  [104269] = 73167,
};

for mountId, rareId in pairs(mountMap) do
  rareInfo[rareId] = rareInfo[rareId] or {};
  data = rareInfo[rareId];
  data.mounts = data.mounts or {};
  table.insert(data.mounts, mountId);
end
