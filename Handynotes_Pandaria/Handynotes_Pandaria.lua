local addonName, shared = ...;

shared.HandyNotes = LibStub('AceAddon-3.0'):GetAddon('HandyNotes', true)
shared.addon = {};

local addon = shared.addon;

-- event handling
do
  local events = {};
  local addonFrame = CreateFrame('frame');

  function addon:on (eventList, callback)
    if (type(eventList) ~= 'table') then
      eventList = {eventList};
    end

    for x = 1, #eventList, 1 do
      local event = eventList[x];
      local list = events[event];

      if (list == nil) then
        events[event] = {callback};
        addonFrame:RegisterEvent(event);
      else
        list[#list + 1] = callback;
      end
    end
  end

  local function eventHandler (self, event, ...)
    for i = 1, #events[event] do
      events[event][i](...);
    end
  end

  addonFrame:SetScript('OnEvent', eventHandler);
end

-- event funnel
function addon:funnel (eventList, timeSpan, callback)
  local flag = false;

  local funnel = function (...)
    local args = {...};

    if (flag == false) then
      flag = true;

      C_Timer.After(timeSpan, function ()
        flag = false;
        callback(unpack(args));
      end);
    end
  end

  addon:on(eventList, funnel);

  -- returning funnel for manual call
  return funnel;
end
