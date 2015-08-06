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
	composer.gotoScene( "game", "flip", 200 )
end

function scene:create( event )
	local group = self.view	

	local background = display.newImage(group, "assets2/bckg.png", cx, cy)

	local cup = display.newImage(group, "assets2/cup.png")
	cup.x, cup.y = display.contentWidth/2, 150
	cup.height, cup.width = 100, 100

	local backBtn = widget.newButton{
	    width = 80,
	    height = 80,
	    defaultFile = "assets2/back.png",
	    overFile = "assets2/back_on.png",
	    onRelease = backButtonListener
	}
	backBtn.x = 50
	backBtn.y = display.contentHeight - 40

	local playBtn = widget.newButton{
	    width = 150,
	    height = 150,
	    defaultFile = "assets2/play.png",
	    overFile = "assets2/play_on.png",
	    onRelease = playButtonListener
	}
	playBtn.x = display.contentWidth/2 
	playBtn.y = 400

	local lastscore = display.newText(group, "Last Score "..event.params.lastscore.." m", display.contentWidth/2, 220, native.systemFontBold, 32)
	lastscore:setFillColor( 0, 0, 0 )

	local highscore = display.newText(group, "High Score "..t.highscoreCopter.." m", display.contentWidth/2, 260, native.systemFontBold, 32)
	highscore:setFillColor( 0, 0, 0 )

	local ncoins = display.newText(group, "+ "..event.params.currentCoins.." coins", display.contentWidth/2, 500, native.systemFontBold, 32)
	ncoins:setFillColor( 0, 0, 0 )

	local totalcoins = display.newText(group, t.coins.." C", display.contentWidth - 75, 25, native.systemFontBold, 28)
	totalcoins:setFillColor( 0, 0, 0 )

	adBtn = widget.newButton{
			defaultFile="assets2/ad.png",
			onEvent = adBtnlistener
			}
			adBtn.x, adBtn.y = 320, 670	

	group:insert(backBtn)
	group:insert(playBtn)
	group:insert(adBtn)
end

function scene:show( event )
    local group = self.view	
    tapSound = audio.loadStream("assets2/tap.wav")
    composer.removeScene( "game" )
    composer.removeScene( "menu" ) 
    
end

function scene:hide( event )
    local group = self.view

end

function scene:destroy( event )
    local group = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene