local scene = composer.newScene()

local t = loadTable( "settings.json" )

function backButtonListener()
	if t.music == true  then
		audio.play( tapSound)
	end
	composer.gotoScene( "menu2", "flip", 200 )
end

function playButtonListener()
	if t.music == true  then
		audio.play( tapSound)
	end
    destroyHUD()
    composer.removeScene( "game")
    composer.removeScene( "stats")
    analytics.logEvent( "RetryGameSession" , { game="CopterSession" } )

	composer.gotoScene( "game", "flip", 200 )
end

function scene:create( event )
	local group = self.view	

    mayShowAd()
    checkLocks(t)
	local background = display.newImage(group, "assets2/bckg.png", cx, cy)

	local cup = display.newImage(group, "assets2/cup.png")
	cup.x, cup.y = display.contentWidth/2, 150
	cup.height, cup.width = 100, 100

	local playBtn = widget.newButton{
	    width = 150,
	    height = 150,
	    defaultFile = "assets2/play.png",
	    overFile = "assets2/play_on.png",
	    onRelease = playButtonListener
	}
	playBtn.x = display.contentWidth/2 
	playBtn.y = 400

	local lastscore = display.newText(group, "Score "..event.params.lastscore.." m", display.contentWidth/2, 220, native.systemFontBold, 32)
	lastscore:setFillColor( 0, 0, 0 )

	local highscore = display.newText(group, "High Score "..t.highscoreCopter.." m", display.contentWidth/2, 260, native.systemFontBold, 32)
	highscore:setFillColor( 0, 0, 0 )


	adBtn = widget.newButton{
		defaultFile="assets3/moregames.png",
		onRelease = showMoreGamesAd
	}
	adBtn.x, adBtn.y = cx, cy+175	
    adBtn:scale(0.65,0.65)
	
	group:insert(playBtn)
	group:insert(adBtn)

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


group:insert(soundBtn)

local function goHome()
       
   composer.removeScene( "game")
   composer.removeScene( "stats")
   destroyHUD()
    composer.gotoScene( "menu2" )
      
end

local homeBtn = widget.newButton
        {
            defaultFile="assets/back.png",
            overFile="assets/back_2.png",
            onRelease = goHome,
            parent = group,
        }

        homeBtn.x = leftMarg+50
        homeBtn.y = bottomMarg-50
        
        
        group:insert( homeBtn )
            local hud = require( "hud" )
    group:insert( hudCoins)
    group:insert( coins)
    group:insert( coinsText)
    showNumCoins(coinsText, numCoins, duration) 
end

function scene:show( event )
    local group = self.view	
    
    tapSound = audio.loadStream("assets2/tap.wav")
    
    composer.removeScene( "game" )
end

function scene:hide( event )
    local group = self.view

end

function scene:destroy( event )
    local group = self.view
    destroyHUD()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene