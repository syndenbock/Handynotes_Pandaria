local addonName, shared = ...;

shared.HandyNotes = LibStub('AceAddon-3.0'):GetAddon('HandyNotes', true)
shared.addon = {};

local addon = shared.addon;

-- event handling
do
  local events = {};
  local addonFrame = CreateFrame('frame');

  function addon:on (event, callback)
    local list = events[event];

    if (list == nil) then
      events[event] = {callback};
      addonFrame:RegisterEvent(event);
    else

      list[#list + 1] = callback;
    end
  end

  local function eventHandler (self, event, ...)
    for i = 1, #events[event] do
      events[event][i](...);
    end
  end

  addonFrame:SetScript('OnEvent', eventHandler);
end
