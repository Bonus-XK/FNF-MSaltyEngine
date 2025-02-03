function onCreate()
    --天空
    makeLuaSprite("sky","neon_Phily/sky",-350,-1150)
    addLuaSprite("sky",false)
    --山
    makeLuaSprite("hall","neon_Phily/hall",-350,-650)
    addLuaSprite("hall",false)
    --高楼
    makeLuaSprite("citys","neon_Phily/citys",-350,-650)
    addLuaSprite("citys",false)
    --高楼的光
    makeLuaSprite("light1","neon_Phily/light1",-350,-650)
    addLuaSprite("light1",false)
    --路
    makeLuaSprite("road","neon_Phily/road",-350,-650)
    addLuaSprite("road",false)
    
    --人群(xml和图片本身有问题,位置没调好)
    --makeAnimatedLuaSprite('crowd', 'neon_Phily/crowd', -350, -650);
	--addAnimationByPrefix('crowd', '', 'idle', 24, true)
	--addLuaSprite('crowd', false);

    --街头
    makeLuaSprite("street","neon_Phily/street",-350,-650)
    addLuaSprite("street",false)
    --车灯光
    makeLuaSprite("lit","neon_Phily/lit",-350,-650)
    addLuaSprite("lit",false)
    --车
    makeLuaSprite("car","neon_Phily/car",-130,-570)
    addLuaSprite("car",true)
    --栏杆
    makeLuaSprite("balustrade","neon_Phily/balustrade",-350,-650)
    addLuaSprite("balustrade",false)

end