local xx = 1100;
local yy = 500;
local xx2 = 1100;
local yy2 = 500;
local ofs = 50;

function onCreate()
    --variables
	Dodged = false;
    canDodge = false;
    DodgeTime = 0;
	
    precacheImage('spacebar');
	precacheSound('Dodged2');
end

function onEvent(name, value1, value2)
    if name == "DodgeEvent2" then
    --Get Dodge time
    DodgeTime = 1.2;
	
    --Make Dodge Sprite
	makeAnimatedLuaSprite('spacebar', 'spacebar', 400, 200);
    luaSpriteAddAnimationByPrefix('spacebar', 'spacebar', 'spacebar', 25, true);
	luaSpritePlayAnimation('spacebar', 'spacebar');
	setObjectCamera('spacebar', 'hud');
	scaleLuaSprite('spacebar', 0.75, 0.75); 
    addLuaSprite('spacebar', true); 
	
	--Set values so you can dodge
	canDodge = true;
	runTimer('Died', DodgeTime);
	
	end
end

function onUpdate()
   if canDodge == true and keyJustPressed('space') then
   
   Dodged = true;
   playSound('Dodged2', 0.7);
   characterPlayAnim('boyfriend', 'dodge', true);
   setProperty('boyfriend.specialAnim', true);
   characterPlayAnim('dad', 'gun', true);
   setProperty('dad.specialAnim', true);
   removeLuaSprite('spacebar');
   canDodge = false
   
   end
   if getProperty('dad.animation.curAnim.name') == 'gun' then
    triggerEvent('Camera Follow Pos',xx+ofs,yy)
end
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == 'Died' and Dodged == false then
    setProperty('health', getProperty('health') - 0.8)
    playSound('Dodged2', 0.7);
    removeLuaSprite('spacebar');
    canDodge = false;
    characterPlayAnim('dad', 'gun', true);
    setProperty('dad.specialAnim', true);
    characterPlayAnim('boyfriend', 'hurt', true);
    setProperty('boyfriend.specialAnim', true);
    setProperty('songMisses', getProperty('songMisses') + 1)
   
   elseif tag == 'Died' and Dodged == true then
   Dodged = false
   
   end
end