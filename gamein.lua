local scene = composer.newScene()

local vx = -20
local vy = -20
local seconds = 0
local frame = 0
local cat
local coin
local group
local e = 0
local ncoins = 0

local gameend = false

local t = loadTable( "settings.json" )

local sound = audio.loadSound("assets1/game.mp3")
local coinSound = audio.loadSound("assets/coin.ogg")

local dragSheet = graphics.newImageSheet( "assets1/drag.png", {width = 60, height = 72, numFrames = 2 })
local dragSequence = {
            { name = "drag", start=1, count=2, time=500},}

local function tempo()
	seconds = seconds + 1
	tim.text = "SCORE "..seconds

	if coin.alpha==1 then
		e = e + 1
	end

	if e>2 then
		coin.alpha=0
		e=0
	end
end

local function startDrag( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

	elseif t.isFocus then
		if "moved" == phase then
			display.remove( drag )
			display.remove( text )

			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
		end
	end

	return true
end

local function move()

 	if gameend == false then

 		cat.rotation = cat.rotation + 3

 		if point.y < 50 then
 			point.y = 51
 		end

 		if point.y > 840 then
 			point.y = 839
 		end

 		if point.x < 0 then
 			point.x = 1
 		end

 		 if point.x >480 then
 			point.x = 479
 		end

		cat.x = cat.x + vx
		cat.y = cat.y + vy


		if cat.x > display.contentWidth or cat.x<0 then 
			vx = vx*-1
		end

		if cat.y > display.contentHeight or cat.y<100 then 
			vy = vy*-1
		end

	if math.abs(point.x-coin.x)<=30 and math.abs(point.y-coin.y)<=30 and coin.alpha==1 then
		coin.alpha = 0
		e=0
		ncoins = ncoins + 1
		audio.play(coinSound)
		cointext.text = ncoins
	end

		if math.abs(point.x-cat.x)<=40 and math.abs(point.y-cat.y)<=40 then
			gameend = true
			
			timer.cancel( timer1 )
			timer.cancel( timer2 )
			point:removeEventListener( "touch", startDrag )
			Runtime:removeEventListener( "enterFrame", move ) 
		
			audio.pause(intro)

			local t = loadTable( "settings.json" )

			t.coins = t.coins + ncoins
			if t.highscoreLaser < seconds then
				t.highscoreLaser = seconds
			end
			saveTable(t, "settings.json")

			local transitionOptions = { effect = "crossFade", time = 300, params = { currentCoins = ncoin, lastscore = seconds} }

			composer.gotoScene( "scorelose", transitionOptions)
			composer.removeScene( "gamein" )
		end

	end

end

local function inc ()
	text.alpha=0
	ccoin()
	if vx > 0 then
		vx = vx+2
	else 
		vx = vx-2
	end

	if vy > 0 then
		vy = vy+2
	else 
		vy = vy-2
	end
end

function ccoin()
	coin.x = math.random(480)
	coin.y = math.random(50,800)
	coin.alpha = 1
end

function scene:create( event )
	group = self.view
	
	background=display.newImage(group, "assets1/floor.png")
	background.x=display.contentWidth/2
	background.y=display.contentHeight/2
 	
	marco=display.newRect( group, cx, 25, display.contentWidth, 50 )
	lineaMarco=display.newRect( group, cx, 50, display.contentWidth, 5 )
	lineaMarco:setFillColor( 0 )

	point = display.newImage(group, "assets1/point.png" )
	point.x=display.contentWidth/2
	point.y=display.contentHeight/2

	drag = display.newSprite( dragSheet, dragSequence )
	drag.x, drag.y = cx+5, cy+40
	drag:play()
	group:insert(drag)

	cat = display.newImage(group, "assets1/cat.png")
	cat.x=0
	cat.y=150 +math.random(400)

	tim=display.newText(group, "SCORE 0", 0, 0, "muro", 35 )
	tim:setFillColor( black )
	tim.x=display.contentWidth/2
	tim.y=topMarg+18

	text = display.newText(group, "DRAG LASER TO AVOID THE CAT!", 0, 0, "muro", 35)
	text:setFillColor( black )
	text.x=display.contentWidth/2
	text.y=cy+100

	coin = display.newSprite( coinsSheet, coinsSequence )
	group:insert(coin)
	coin:scale(0.8,0.8)
	coin:setSequence( "estatica" )
	coin.alpha=0

	cointext = display.newText(group, "0", 0, 0, "muro", 35)
	cointext:setFillColor( black )
	cointext.x, cointext.y=rightMarg-80,topMarg+18

	coinHud = display.newSprite( coinsSheet, coinsSequence )
	coinHud:scale(0.8,0.8)
	group:insert(coinHud)
	coinHud.x, coinHud.y = rightMarg-35,topMarg+22

end

function scene:show( event )
	group = self.view

	local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
    	timer1 = timer.performWithDelay( 1000, tempo, 0)
		timer2 = timer.performWithDelay( 3000, inc, 0)

		point:addEventListener( "touch", startDrag )
		Runtime:addEventListener( "enterFrame", move)

		if t.music == false then
			audio.setVolume(0)
		end

		audio.play( sound, {loops=-1})


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