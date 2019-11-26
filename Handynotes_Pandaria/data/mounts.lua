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

for mountId, rareList in pairs(mountMap) do
  if (type(rareList) ~= 'table') then
    rareList = {rareList};
  end

  for x = 1, #rareList, 1 do
    local rareId = rareList[x];

    rareInfo[rareId] = rareInfo[rareId] or {};
    data = rareInfo[rareId];
    data.mounts = data.mounts or {};
    table.insert(data.mounts, mountId);
  end
end
