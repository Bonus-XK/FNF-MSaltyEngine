function onEvent(name,value1,value2)
	if name == 'train' then
   	makeLuaSprite('train', 'NEOPhily/train', -4000, 100);
	scaleObject('train', 0.85, 0.85);
	addLuaSprite('train', false);
    setObjectOrder('train', getObjectOrder('dadGroup') -4)
    runTimer('trainsound',0.1)
end

	function onTimerCompleted(t,l,ll)
	if t == 'trainsound' then
	    playSound('train_passes');
	    runTimer('trainCome',5)
	end
	if t == 'trainCome' then
		doTweenAlpha('traintween','train',1,0.1)
		setProperty('train.x', 1150)
		doTweenX('train','train',-1150,0.3,'sineOut')
		runTimer('trainCome2',0.3)
	end
	if t == 'trainCome2' then
		setProperty('train.x', 1150)
		doTweenX('train','train',-1150,0.3,'sineOut')
		runTimer('trainCome3',0.3)
	end
		if t == 'trainCome3' then
		setProperty('train.x', 1150)
		doTweenX('train','train',-1150,0.3,'sineOut')
		runTimer('trainCome4',0.3)
		end
		if t == 'trainCome4' then
		setProperty('train.x', 1150)
		doTweenX('train','train',-1150,0.3,'sineOut')
		runTimer('trainCome5',0.3)
		end
		if t == 'trainCome5' then
		setProperty('train.x', 1150)
		doTweenX('train','train',-1150,0.3,'sineOut')
		runTimer('trainCome6',0.3)
		end
		if t == 'trainCome6' then
		setProperty('train.x', 1150)
		doTweenX('train','train',-1150,0.3,'sineOut')
		runTimer('trainCome7',0.3)
		end
	if t == 'trainCome7' then
	doTweenX('train','train',-4000,0.5,'sineOut')
	runTimer('trainRide',1)

	end
	if t == 'trainRide' then
  
	setProperty('train.x', 2000)
    runTimer('trainsound',14)
    end
end
end