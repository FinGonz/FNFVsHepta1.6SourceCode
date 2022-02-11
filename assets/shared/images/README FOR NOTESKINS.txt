they are broken since i got these from vs camellia
THEY ARE BROKEN
if you want you can fix em i tested it using this code:

    if dadName == 'hepta' then
        for i=0,4,1 do
            setPropertyFromGroup('opponentStrums', i, 'texture', 'CIRCLENOTE_assets')
        end
        for i = 0, getProperty('unspawnNotes.length')-1 do
            if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'CIRCLENOTE_assets'); --Change texture
            end
        end
    end






i dont know how to fix it since the xml is correct but psych engine is just saying FUCK YOU!






-some dumbass programmer