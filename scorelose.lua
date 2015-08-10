local scene = composer.newScene()

local t = loadTable( "settings.json" )

local losem = audio.loadSound("assets1/gameover.mp3")

function soundBtnlistener(event)
    local phase = event.phase 
    
    if "ended" == phase then   

      soundBtn = nil
      
      if t.music == true then
        t.music = false
        audio.setVolume(0)
        soundBtn = widget.newButton{
            defaultFile="assets1/sound_off.png",
            height = 50,
            width = 50,
            onEvent = soundBtnlistener
        }
      else
        t.music = true
        audio.setVolume(1)
        soundBtn = widget.newButton{
            defaultFile="assets1/sound_on.png",
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

local function retorn()
	analytics.logEvent( "RetryGameSession" )
	composer.gotoScene( "gamein" )
	composer.removeScene( "scorelose" )
end

local function goHome()
	composer.gotoScene( "menu2" )
	composer.removeScene( "scorelose" )
end

function scene:create( event )
	local group = self.view

	local background = display.newImage(group, "assets1/sky2.png", cx, cy )

	local bobt = display.newImage(group, "assets1/cat.png" )
	bobt.x, bobt.y = display.contentWidth/2, display.contentHeight/2 -50
	
	local retryBtn = widget.newButton
	{
	    defaultFile="assets1/button.png",
	    onRelease = retorn
	}

	retryBtn.x = display.contentWidth/2
	retryBtn.y = display.contentHeight - 300

	local homeBtn = widget.newButton
	{
	    height = 50,
	    width = 50,
	    defaultFile="assets1/home.png",
	    onRelease = goHome
	}

	homeBtn.x = display.contentWidth/2
	homeBtn.y = display.contentHeight - 50

	local lastscore = display.newText(group, "LAST SCORE: " .. event.params.lastscore, 0, 0, "muro", 32 )
	lastscore:setFillColor( 1,1,1 )
	lastscore.x = display.contentWidth/2
	lastscore.y = 200

	local highscore = display.newText(group, "HIGH SCORE: " .. t.highscoreLaser, 0, 0, "muro", 32 )
	highscore:setFillColor( 1,1,1 )
	highscore.x = display.contentWidth/2
	highscore.y = 250

	cointext = display.newText(group, "0 C", 0, 0, "muro", 24)
	cointext:setFillColor( black )
	cointext.x=display.contentWidth - 40
	cointext.y=20

	if t.lastscore == t.highscore then
		highscore:setFillColor( 1,0,0 )
	end

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
	soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 25

	local gamesBtn = widget.newButton{
		defaultFile="assets1/games.png",
		width=240, height=60,
		onRelease = showGameAd
	}

	gamesBtn.x = display.contentWidth/2
	gamesBtn.y = display.contentHeight/2 + 200

	local cointext = display.newText(group, t.coins.." C", 0, 0, "muro", 24)
	cointext.x=display.contentWidth - 40
	cointext.y=20 

	group:insert(retryBtn)
	group:insert(homeBtn)
	group:insert(gamesBtn)
	group:insert(soundBtn)

end

function scene:show( event )
	group = self.view

	local phase = event.phase
	
	if t.music==false then
		audio.setVolume(0)
	end

	if ( phase == "will" ) then
		audio.play(losem)
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