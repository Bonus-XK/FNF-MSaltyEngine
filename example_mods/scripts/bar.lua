function onCreatePost()
if downscroll then
doTweenX('Bar','healthBar',120,0.0001,'linear')
doTweenX('time','timeBar',0,0.0001,'linear')
setProperty('timeTxt.visible',true)
else
doTweenX('Bar','healthBar',120,0.0001,'linear')
doTweenX('time','timeBar',0,0.0001,'linear')
setProperty('timeTxt.visible',true)
setProperty('timeTxt.y', 670 )
setProperty('timeTxt.x', 214 )
makeLuaText("foreverCenterMark",'', 1280, -6, 5)
           setTextSize('foreverCenterMark', 27);
           setProperty('foreverCenterMark.alpha', 1)
           setTextAlignment('foreverCenterMark', 'center') 
           addLuaText('foreverCenterMark')
           setObjectCamera('foreverCenterMark', 'hud');
           setTextBorder('foreverCenterMark',2,'000000')
           setTextString('foreverCenterMark',' < ' .. songName .. ''..' > ')
        end
end
function opponentNoteHit()
       health = getProperty('health')
    if getProperty('health') > 0.1 then
       setProperty('health', health- 0.013);

	end
end
function boyfriendNoteHit()
       health = getProperty('health')
    if getProperty('health') > 0.1 then
       setProperty('health', health- 1.013);
  end
end
function onUpdatePost()
setProperty('iconP1.x', 650)	
setProperty('iconP2.x', 10)
end
