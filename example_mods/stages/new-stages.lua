function onCreate()
    makeLuaSprite("bg","new-stages1/bg",30,-100)
    addLuaSprite("bg",false)
    scaleObject('bg', 0.5, 0.5);
    makeLuaSprite("load","new-stages1/load",-500,-100)
    addLuaSprite("load",false)
    scaleObject('load', 0.9, 0.9);
    makeLuaSprite("light","new-stages1/light",-500,-100)
    addLuaSprite("light",false)
    scaleObject('light', 1, 1);

end