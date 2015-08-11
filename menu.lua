local composer = require( "composer" )
local scene = composer.newScene()

local t = loadTable( "settings.json" )
local group
local tvCall
local tvLaser
local tvLie
local coinsAnimationFlag=false

local optionsCoinsText = {
	text= t.coins,
	x= rightMarg-85, 
	y= topMarg+36,
	font= "BebasNeue",
	fontSize=34,
	width= 100,
	align= "center"
}

    local tvLieData = { width=209, height=219, numFrames=4,}
    local tvLieSheet = graphics.newImageSheet( "assets/iconLie.png", tvLieData )    
    local tvLieSequence = {
        { name = "unlocked", start=1, count=3, time=900, loopDirection="bounce"},
        { name = "locked", start=4, count=1, time=125,},}


    local tvCallData = { width=209, height=219, numFrames=4,}
    local tvCallSheet = graphics.newImageSheet( "assets/iconCall.png", tvCallData )    
    local tvCallSequence = {
        { name = "unlocked", start=1, count=3, time=2500,},
        { name = "locked", start=4, count=1, time=125,},}

	local tvLaserData = { width=209, height=219, numFrames=4,}
    local tvLaserSheet = graphics.newImageSheet( "assets/iconLaser.png", tvLaserData )    
    local tvLaserSequence = {
        { name = "unlocked", frames={4,3,2}, time=1500},
        { name = "locked", start=1, count=1, time=125,},}

 	iconPlayData = { width=231, height=354, numFrames=4,}
    iconPlaySheet = graphics.newImageSheet( "assets/lab.png", iconPlayData )    
    iconPlaySequence = {
        { name = "normal", start=1, count=4, time=2500,},}  

   local function hudCoinsTouch(event)
	if ( event.phase == "ended") then
	    	composer.removeScene( "menu" )
	    	composer.gotoScene( "tienda" )
		end
    	return true
	end

        local function iconPlayTouch(event)
	    if ( event.phase == "ended") then
	    	composer.removeScene( "menu" )
	    	composer.gotoScene( "menu2" )
		end
    	return true
	end
function soundBtnlistener(event)
    local phase = event.phase 
    
    if "ended" == phase then   

      display.remove(soundBtn) 
      soundBtn = nil
      
      if t.music == true then
        t.music = false
        audio.setVolume(0)
        soundBtn = widget.newButton{
            defaultFile="assets/sound_off.png",
            height = 50,
            width = 50,
            onEvent = soundBtnlistener
        }
      else
        t.music = true
        audio.setVolume(1)
        soundBtn = widget.newButton{
            defaultFile="assets/sound_on.png",
            height = 50,
            width = 50,
            onEvent = soundBtnlistener
        }
      end

    saveTable(t, "settings.json")
    
	soundBtn.x , soundBtn.y = leftMarg+35, topMarg+35
    group:insert(soundBtn)

    end
end

 function tvLieTouch(event)
	    if ( event.phase == "ended") then
		    if t.unlocked>0 then
		    	composer.removeScene( "menu" )
		    	composer.gotoScene( "lieDetector")
				analytics.logEvent( "LieDetector-Session" )
			else 
				flag1 = true
				composer.showOverlay( "popup", {effect="zoomOutIn", isModal = true})
				
			end
		end
    	return true
	end

local function tvCallTouch(event)
	    if ( event.phase == "ended") then
	     	if t.unlocked>1 then
	    	composer.removeScene( "menu" )
	    	composer.gotoScene( "menuphone")
	    	analytics.logEvent( "FakeCall-Session" )
	    	else 
				flag2 = true
				composer.showOverlay( "popup", {effect="zoomOutIn", isModal = true})
			end
		end
    	return true
	end

local function tvLaserTouch(event)
	    if ( event.phase == "ended") then
	    	if t.unlocked>2 then
	    	composer.removeScene( "menu" )
	    	composer.gotoScene( "laser")
			analytics.logEvent( "LaserSword-Session" )
			else 
				flag3 = true
				composer.showOverlay( "popup", {effect="zoomOutIn", isModal = true})
			end
		end
    	return true
	end

 function lieUnlocked()
		tvLie:setSequence( "unlocked" )
		tvLie:play()
		
end

local function callUnlocked()
		tvCall:setSequence( "unlocked" )
		tvCall:play()
		
end

local function laserUnlocked()
		tvLaser:setSequence( "unlocked" )
		tvLaser:play()
		
end

function desbloquea()
	if t.unlocked==0 then
		tvLie:setSequence( "locked" )
		tvCall:setSequence( "locked" )
		tvLaser:setSequence( "locked" )
	elseif t.unlocked==1 then
		lieUnlocked()
		tvCall:setSequence( "locked" )
		tvLaser:setSequence( "locked" )
	elseif t.unlocked==2 then
		lieUnlocked()
		callUnlocked()
		tvLaser:setSequence( "locked" )
	elseif t.unlocked==3 then
		lieUnlocked()
		callUnlocked()
		laserUnlocked()
	end
end

function scene:create( event )
	group = self.view

	if t.music==false then
		audio.setVolume(0)
	end


local background = display.newImage( group, "assets/background.png", cx, cy )
local sombra = display.newImage( group, "assets/sombra.png", cx, bottomMarg-40)
tvCall = display.newSprite( tvCallSheet, tvCallSequence )
tvLaser = display.newSprite( tvLaserSheet, tvLaserSequence )
tvLie = display.newSprite( tvLieSheet, tvLieSequence )

tvLie:addEventListener("touch",tvLieTouch)
tvCall:addEventListener("touch",tvCallTouch)
tvLaser:addEventListener("touch",tvLaserTouch)

tvCall.x, tvCall.y = cx-105, cy+260
tvCall:play()

tvLaser.x, tvLaser.y = cx+105, cy+260
tvLaser:play()

tvLie.x, tvLie.y = cx, cy+115
tvLie:play()

local iconPlay = display.newSprite( iconPlaySheet, iconPlaySequence )
iconPlay.x, iconPlay.y = cx, cy-140
iconPlay:play()

	local intro = audio.loadSound("assets/intro.ogg")
	audio.play( intro )
	

	if t.music==true then
		soundBtn = widget.newButton{
			defaultFile="assets/sound_on.png",
            height = 50,
            width = 50,
			onEvent = soundBtnlistener
		}
	else 
		soundBtn = widget.newButton{
			defaultFile="assets/sound_off.png",
            height = 50,
            width = 50,
			onEvent = soundBtnlistener
		}
	end
	soundBtn.x , soundBtn.y = leftMarg+35, topMarg+35
	group:insert( iconPlay )
	group:insert( soundBtn )
	group:insert( tvCall )
	group:insert( tvLaser )
	group:insert( tvLie ) 
	desbloquea()
	iconPlay:addEventListener("touch",iconPlayTouch)

	local hud = require( "hud" )
    group:insert( hudCoins)
    group:insert( coins)
    group:insert( coinsText)
	showNumCoins(coinsText, numCoins, 1)

end

function scene:show( event )
	group = self.view


end


function scene:hide( event )
	group = self.view
	
	audio.pause(intro)



end


function scene:destroy( event )
	group = self.view
display.remove( soundBtn )
display.remove( tvCall )
display.remove( tvLaser )
display.remove( tvLie )
display.remove(background )
display.remove( sombra )
display.remove( iconPlay )
package.loaded["hud"] = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene