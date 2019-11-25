local addonName, shared = ...;

local rareInfo = shared.rareInfo;

local mountMap = {
  [473] = 60491,
  [542] = 69099,
  [533] = 69161,
  [534] = 69769,
  [535] = 69769,
  [536] = 69769,
  [517] = 64403,
  [561] = 73167,
};

for mountId, rareId in pairs(mountMap) do
  rareInfo[rareId] = rareInfo[rareId] or {};
  data = rareInfo[rareId];
  data.mounts = data.mounts or {};
  table.insert(data.mounts, mountId);
end
