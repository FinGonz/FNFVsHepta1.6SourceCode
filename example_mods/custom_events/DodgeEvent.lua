function onCreate()
    --variables
	Dodged = false;
    canDodge = false;
    DodgeTime = 0;
	
    precacheImage('spacebar');
	precacheSound('Dodged');
end

function onEvent(name, value1, value2)
    if name == "DodgeEvent" then
    --Get Dodge time
    DodgeTime = 0.9;
	
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
   playSound('Dodged', 0.7);
   characterPlayAnim('boyfriend', 'dodge', true);
   setProperty('boyfriend.specialAnim', true);
   characterPlayAnim('dad', 'gun', true);
   setProperty('dad.specialAnim', true);
   removeLuaSprite('spacebar');
   canDodge = false
   
   end
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == 'Died' and Dodged == false then
   setProperty('health', getProperty('health') - 1.5)
    playSound('Dodged', 0.7);
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