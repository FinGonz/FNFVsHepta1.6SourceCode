function onEvent(name, value1, value2)
    if name == 'Force off Ghost Tapping' then
        if value1 == 'on' then
            keepScroll = getPropertyFromClass('ClientPrefs', 'ghostTapping');
            setPropertyFromClass('ClientPrefs', 'ghostTapping', false);
            
        end
    end
    if value1 == 'off' then
        keepScroll = getPropertyFromClass('ClientPrefs', 'ghostTapping');
        setPropertyFromClass('ClientPrefs', 'ghostTapping', true);
    end
end

function onDestroy()
    keepScroll = getPropertyFromClass('ClientPrefs', 'ghostTapping');
setPropertyFromClass('ClientPrefs', 'ghostTapping', true);
end --made it work