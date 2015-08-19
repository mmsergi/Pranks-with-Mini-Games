local scene = composer.newScene()

local t = loadTable( "settings.json" )

local on = audio.loadSound("assets1/on.wav")
local off = audio.loadSound("assets1/off.wav")
local swing1 = audio.loadSound("assets1/swing.wav")
local swing2 = audio.loadSound("assets1/swing2.wav")
local hit = audio.loadSound("assets1/hit.wav")

local group

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
    soundBtn.anchorX , soundBtn.anchorY = 1, 1 
	soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 50

    group:insert(soundBtn)

    end
end

local function onPointer()
	touchimg.alpha = 0

	shakeimg = display.newImage( group, "assets/shake.png" )
	shakeimg.x , shakeimg.y = cx + 135, cy 
	if laser.alfa==0 then
		audio.play( on )
		laser.alfa=1
		transition.to( laser, { time=200, y=display.contentHeight/2, transition=easing.outQuad} )
	else
		audio.play( off )
		laser.alfa=0
		transition.to( laser, { time=200, y=display.contentHeight*2, transition=easing.outQuad} )
	end
end

local function changeColor(event)
	
	audio.play( on )
	laser:removeSelf( )
	laser = nil
	grip:removeSelf( )
	grip = nil

	laser = display.newImage(group, "assets1/" .. event.target.id .. ".png")
	laser.x, laser.y = display.contentWidth/2, display.contentHeight/2

	grip = widget.newButton
	{
	    defaultFile="assets1/grip.png",
	    onRelease = onPointer
	}
	grip.x, grip.y = display.contentWidth/2, display.contentHeight/2 + 300
	group:insert(grip)

	transition.to( laser, { time=200, y=display.contentHeight/2, transition=easing.outQuad} )

end

local function retorn()
	composer.removeScene( "laser" )
	composer.gotoScene( "menu" )

end

local function shake( event )

	if laser.alfa==1 then

	    if event.isShake == true then
    		if shakeimg.alpha==1 then
				shakeimg.alpha=0
			end
	    	rand = math.random(0, 10)
	    	if (rand>6) then
	    		audio.play( swing1 )
	    	elseif (rand<4) then
	    		audio.play( swing2 )
	    	elseif (rand>4 and rand<6) then
	    		audio.play( hit )
	    	end
	    end

	end
end

function scene:create( event )
		group = self.view

		mayShowAd()

		background = display.newImage(group, "assets1/sky2.png", cx, cy )

		laser = display.newImage(group, "assets1/red.png" )
		laser.x, laser.y = display.contentWidth/2, display.contentHeight*2

		redbtn = widget.newButton
		{
			onRelease = changeColor,
			shape="circle",
			radius = 20,
			fillColor = { default={ 255, 0, 0, 1 }, over={ 255, 0, 0, 0.5 }  }
		}

		redbtn.id = "red"
		redbtn.x = 50
		redbtn.y = 120

		greenbtn = widget.newButton
		{
			onRelease = changeColor,
			shape="circle",
			radius = 20,
			fillColor = { default={ 0, 255, 0, 1 }, over={ 0, 255, 0, 0.5 }  }
		}

		greenbtn.id = "green"
		greenbtn.x = 50
		greenbtn.y = 170

		bluebtn = widget.newButton
		{
			onRelease = changeColor,
			shape="circle",
			radius = 20,
			fillColor = { default={ 0, 0, 255, 1 }, over={ 0, 0, 255, 0.5 }  }
		}

		bluebtn.id = "blue"
		bluebtn.x = 50
		bluebtn.y = 220

		yellowbtn = widget.newButton
		{
			onRelease = changeColor,
			shape="circle",
			radius = 20,
			fillColor = { default={ 255, 255, 0, 1 }, over={ 255, 255, 0, 0.5 }  }
		}

		yellowbtn.id = "yellow"
		yellowbtn.x = 50
		yellowbtn.y = 270

		purplebtn = widget.newButton
		{
			onRelease = changeColor,
			shape="circle",
			radius = 20, 
			fillColor = { default={ 128, 0, 128, 1 }, over={ 128, 0, 128, 0.5 }  }
		}

		purplebtn.id = "purple"
		purplebtn.x = 50
		purplebtn.y = 320
		
		button = widget.newButton
		{
		    defaultFile="assets/home_2.png",
		    width=70,
		    height=70,
		    onRelease = retorn
		}

		button.x = 70
		button.y = display.contentHeight - 70

		grip = widget.newButton
        {
            defaultFile="assets1/grip.png",
            onRelease = onPointer
        }

        grip.x, grip.y = display.contentWidth/2, display.contentHeight/2 + 300
        group:insert(grip)

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

	soundBtn.anchorX , soundBtn.anchorY = 1, 1 
	soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 50

	laser.alfa=0

	Runtime:addEventListener( "accelerometer", shake )

	group:insert(button)
	
	group:insert(soundBtn)

	group:insert(redbtn)
	group:insert(greenbtn)
	group:insert(bluebtn)
	group:insert(purplebtn)
	group:insert(yellowbtn)

	touchimg = display.newImage( group, "assets/touch.png" )
	touchimg.x , touchimg.y = cx + 70, cy + 320
	touchimg.rotation = -45

end

function scene:show( event )
	group = self.view

	if ( event.phase == "will" ) then
	
		if t.music==false then
			audio.setVolume(0)
		end

	end
end


function scene:hide( event )
	group = self.view

end


function scene:destroy( event )
	group = self.view
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene