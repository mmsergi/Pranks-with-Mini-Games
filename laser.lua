local scene = composer.newScene()

local t = loadTable( "settings.json" )

local sound = audio.loadSound("assets/on.ogg")

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
	soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 90
    group:insert(soundBtn)

    end
end

local function onPointer()
	audio.play( sound )
	if laser.alpha==0 then
		laser.alpha=1
	else
		laser.alpha=0
	end
end

local function changeColor(event)
	audio.play( sound )
	
	laser:removeSelf( )
	laser = nil
	grip:removeSelf( )
	grip = nil

	laser = display.newImage("assets1/" .. event.target.id .. ".png")
	laser.x, laser.y = display.contentWidth/2, display.contentHeight/2
	group:insert(laser)


	grip = widget.newButton
	{
	    defaultFile="assets1/grip.png",
	    onRelease = onPointer
	}
	grip.x, grip.y = display.contentWidth/2, display.contentHeight/2 + 300
	group:insert(grip)
end

local function retorn()
	
	composer.gotoScene( "menu" )

end

function scene:create( event )
		group = self.view

		composer.removeScene( "gamein" )

		background = display.newImage(group, "assets1/sky2.png", cx, cy )

		laser = display.newImage(group, "assets1/red.png" )
		laser.x, laser.y = display.contentWidth/2, display.contentHeight/2

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
		    defaultFile="assets1/back.png",
		    onRelease = retorn
		}

		button.x = 50
		button.y = display.contentHeight - 120

		grip = widget.newButton
        {
            defaultFile="assets1/grip.png",
            onRelease = onPointer
        }

        grip.x, grip.y = display.contentWidth/2, display.contentHeight/2 + 300
        group:insert(grip)

	if t.music==true then
		soundBtn = widget.newButton{
			defaultFile="assets1/sound_on.png",
            height = 50,
            width = 50,
			onEvent = soundBtnlistener
		}
	else 
		soundBtn = widget.newButton{
			defaultFile="assets1/sound_off.png",
            height = 50,
            width = 50,
			onEvent = soundBtnlistener
		}
	end

	soundBtn.anchorX , soundBtn.anchorY = 1, 1 
	soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 90

	laser.alpha=0

	group:insert(button)
	
	group:insert(soundBtn)

	group:insert(redbtn)
	group:insert(greenbtn)
	group:insert(bluebtn)
	group:insert(purplebtn)
	group:insert(yellowbtn)

end

function scene:show( event )
	group = self.view
	
	if t.music==false then
		audio.setVolume(0)
	end

	composer.removeScene( "gamein" )

	ads.show( "banner", { x=0, y=bottomMarg-70, appId=bannersimulator} )
end


function scene:hide( event )
	group = self.view

	ads.hide()
end


function scene:destroy( event )
	group = self.view
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene