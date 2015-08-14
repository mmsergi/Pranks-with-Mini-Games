local scene = composer.newScene()

local t = loadTable( "settings.json" )

local group

function moverBarra1()
		tr1 = transition.moveTo( barraLuz1, {y=topMarg+120, time=1000, onComplete=moverbarraLuz1} )
end

 function moverbarraLuz1()
		tr2 = transition.moveTo( barraLuz1, {y=topMarg+75, time=1000, onComplete=moverBarra1})
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
    soundBtn.anchorX , soundBtn.anchorY = 1, 1 
	soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 25
    group:insert(soundBtn)

    end
end

local function goHome()
	composer.gotoScene( "menu" )
	composer.removeScene( "menu2" )
end

function scene:create( event )
	group = self.view

	mayShowAd()

	if t.music==false then
		audio.setVolume(0)
	end

	local intro = audio.loadSound("assets/intro.ogg")
	audio.play( intro )
	
	local background = display.newImage( group, "assets/fondoMenu.png", cx, cy )
	barraLuz1 = display.newImage( group, "assets/barraLuz.png", cx, topMarg+75 )
	local titulo = display.newText( group, translations["Juegos"][language], cx, topMarg+100, "BebasNeue", 80 )

	moverBarra1()
	

	local btn1 = display.newImage( group, "assets/iconoCat.png", leftMarg+150, cy-120)
	btn1:scale(0.75,0.75)

    function btn1:tap()
        btn1:scale(0.75,0.75)
        analytics.logEvent( "LaserCatSession" )
        composer.gotoScene( "gamein" )
    end
    
    btn1:addEventListener("tap",btn1)

    local btn2 = display.newImage( group, "assets/iconoCat.png", rightMarg-150, cy-120)
	btn2:scale(0.75,0.75)

    function btn2:tap()
        btn2:scale(0.75,0.75)
        analytics.logEvent( "DoorsSession" )
        composer.gotoScene( "EndlessH" )
    end
    
    btn2:addEventListener("tap",btn2)

    local btn3 = display.newImage( group, "assets2/copicon.png", leftMarg+150, cy+120)


	local btn4 = display.newImage( group, "assets/iconoCat.png", rightMarg-150, cy+120)
	btn4:scale(0.5,0.5)

    function btn3:tap()
        btn3:scale(0.75,0.75)
        analytics.logEvent( "CopterSession" )
        composer.gotoScene( "game" )
    end
    
    btn3:addEventListener("tap",btn3)

    function btn4:tap()
        btn4:scale(0.75,0.75)
        analytics.logEvent( "CoconutSession" )
        composer.gotoScene( "juegoTOA" )
    end
    
    btn4:addEventListener("tap",btn4)

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
	soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 25

	local homeBtn = widget.newButton
		{
		    defaultFile="assets/home.png",
		    overFile="assets/home_2.png",
		    onRelease = goHome,
		    parent = group,
		    height = 70,
		    width = 70,
		}

		homeBtn.x = 60
		homeBtn.y = bottomMarg-60

	group:insert( homeBtn )
	group:insert( soundBtn )

end

function scene:show( event )
	group = self.view


end


function scene:hide( event )
	group = self.view
	
	audio.pause(intro)

	composer.removeScene( "menu2" )

end


function scene:destroy( event )
	group = self.view
display.remove( soundBtn )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene