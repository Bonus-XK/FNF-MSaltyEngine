function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do	
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'bullet_notes' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTES/bullet_notes');
			setPropertyFromGroup('unspawnNotes',i,'missHealth', 1)

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				
			end
		end
	end

end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == "bullet_notes" then
			triggerEvent('Screen Shake', "0.25, 0.0025", 0)
			triggerEvent('Play Animation', 'gun', 0);
			playSound('gun')
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == "bullet_notes" then
                playSound('gun')
		triggerEvent('Screen Shake', "0.25, 0.0025", 0)
		triggerEvent('Play Animation', 'gun', 0);
                        if direction==0 then
					triggerEvent('Play Animation', 'dodge', 1 );
			elseif direction==1 then
					triggerEvent('Play Animation', 'dodge', 1);
			elseif direction==2 then
					triggerEvent('Play Animation', 'dodge', 1);
			elseif direction==3 then
					triggerEvent('Play Animation', 'dodge', 1);
			end
	end
end
