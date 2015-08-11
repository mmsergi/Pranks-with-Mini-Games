local scene = composer.newScene()

local t = loadTable( "settings.json" )

local velocity = 100
local height = 40
local time = 500
local meters = 0
local ncoin = 0
local group
coinSound= audio.loadSound( "assets/coin.ogg")
local groupObj = {}

function move()
	--copter.x=display.contentWidth/4
	if copter.rotation < -180 or copter.rotation > 180 then
		loose()
	end 

	sky.x = sky.x - 0.4

	sun.x = sun.x - 0.2

	if sun.x < 0 then
		background:setFillColor( 0,0,128 )
	end

	if copter.y < -10 or copter.y > 780 or copter.x < 0 or copter.x >480 then
		loose()
	end
	
end

function loose()
	for i=1, #groupObj  do
		if groupObj[i]~=nil then
				groupObj[i].gravityScale = 0.75
		end
	end

	t.coins = t.coins + ncoin

	physics.setGravity( 0, 40 )
	if t.music == true  then
		audio.pause(copterSound)
		local overSound = audio.loadStream("assets2/over.wav")
		audio.play(overSound)
	end

	Runtime:removeEventListener("touch", up)
    Runtime:removeEventListener("enterFrame", move)
    Runtime:removeEventListener("collision", onCollision )
    timer.pause(timer1)
    timer.pause(timer2)
    timer.pause(timer3)
    timer.pause(timer4)
	
	if t.highscoreCopter < meters then
		t.highscoreCopter = meters
	end
	
	saveTable(t, "settings.json")
	transition.to( gameover, { alpha = 1, time = 900, transition = easing.outQuad } )
	timer.performWithDelay( 1000, ves)

end

function ves () 
	--[[for i=1, #groupObj  do
		if groupObj[i]~=nil then
				groupObj[i]:removeSelf( )
				groupObj[i]=nil
		end
	end]]
	clean()
	local transitionOptions = { effect = "crossFade", time = 300, params = { currentCoins = ncoin, lastscore = meters} }
	composer.gotoScene( "stats", transitionOptions)
end

function onCollision( event )
	if (event.object1.id=="copter" and event.object2.id=="coin" and event.object2.alpha==1) then
		event.object2.alpha=0
		audio.play(coinSound)
		ncoin = ncoin + 1
		ncoins.text = ncoin.." C"
	end

	if (event.object1.id=="coin" and event.object2.id=="copter") then
		event.object1.alpha=0
		ncoin = ncoin + 1
		ncoins.text = ncoin.." C"
	end
end

function inc()
	velocity = velocity + 10
	height = height + 1
	if time ~= 400 then
		time = time - 80
		timer.pause(timer2)
		timer2 = timer.performWithDelay( time, attack, 0)
		print(time)
	end
	clean()
end

--[[local function boom()
	bomb = display.newImage( "assets2/bomb.png" )
	physics.addBody( bomb, "dynamic", {density=1000})
	bomb.isBullet = true
	bomb.gravityScale=0
	bomb:setLinearVelocity( 500, 0 )
	bomb.x, bomb.y = copter.x + 20, copter.y
end]]

function tempo()
		meters = meters + 1
	    tim.text = meters .. " m"
end

function up(event)
	physics.setGravity( 0, -30 )
	audio.setVolume( 1 )
	if event.phase=="ended" then
		physics.setGravity( 0, 20 )
		audio.setVolume( 0.25 )
	end
end

function attack()
	object = display.newImage( "assets2/object.png")
	object.id="obj"
	object.x = display.contentWidth
	object.y = math.random(720) + 30
	object.height = height
	physics.addBody( object, "dynamic")
	object.gravityScale=0
	object:setLinearVelocity( -velocity, 0 )
	table.insert(groupObj, object)
	group:insert(object)
end

function coin()
	coin = display.newSprite( coinsSheet, coinsSequence )
	coin:setSequence( "estatica" )
	coin:scale(0.8,0.8)
	physics.addBody( coin, "dynamic", {density=0.00000001})
	coin.x = 480
	coin.y = 20 + math.random(280)
	coin:setLinearVelocity( -velocity, 0 )
	coin.gravityScale=0
	coin.id = "coin"
	coin:play()
	table.insert(groupObj, coin)
	group:insert(coin)
end

function clean()
	for i=1, #groupObj  do
		if groupObj[i]~=nil then
			if groupObj[i].x < 0 or groupObj[i].x > 480 or groupObj[i].y < 0 or groupObj[i].y > 800 then
				groupObj[i]:removeSelf( )
				groupObj[i]=nil
			end
		end
	end
end

function starting()
	physics.start( )
	physics.setGravity( 0, 20 )

	Runtime:removeEventListener("tap", starting)

	copter:play()
	physics.addBody( copter, "dynamic", {density=0.01})

	timer1 = timer.performWithDelay(10, tempo, 0)
	timer2 = timer.performWithDelay( time, attack, 0)
	timer3 = timer.performWithDelay(8000, inc , 0)
	timer4 = timer.performWithDelay( 4250, coin, 0)

	if t.music == true  then
		copterSound = audio.loadStream("assets2/copter.mp3")
		audio.play( copterSound, { loops=-1 })
		audio.setVolume( 0.25 )
	end

	--[[eject = widget.newButton{
	    defaultFile = "assets2/boom.png",
	    onRelease = boom
	}
	eject.x = 430
	eject.y = 300

	group:insert(eject)]]

	Runtime:addEventListener("touch", up)
	Runtime:addEventListener("enterFrame", move)
	Runtime:addEventListener("collision", onCollision)

	tutorial:removeSelf( )
	
end

function scene:create( event )
	group = self.view
	
	--background = display.newRect(group, 0, 0, display.contentWidth, display.actualContentHeight )
	--background:setFillColor( 0, 191, 255 )

	background = display.newImage(group, "assets2/bckg.png", cx, cy)

	sun = display.newImage(group, "assets2/sun.png")
	sun.x = display.contentWidth
	sun.y = 50
	sun.width, sun.height = 150, 150
	sun.alpha = 0.95

	tutorial=display.newText(group, "TOUCH SCREEN TO FLY", 0, 0, native.systemFontBold, 30 )
	tutorial:setFillColor( 0,0,0 )
	tutorial.x=display.contentWidth/2 
	tutorial.y=display.contentHeight - display.contentHeight/3

	tim=display.newText(group, "0 m", 0, 0, native.systemFontBold, 30 )
	tim:setFillColor( 0,0,0 )
	tim.x=display.contentWidth/2 - 40
	tim.y=60

	ncoins=display.newText(group, "0 C", 0, 0, native.systemFontBold, 30 )
	ncoins:setFillColor( 0,0,0 )
	ncoins.x=display.contentWidth/2 + 40
	ncoins.y=60

	sky = display.newImage(group, "assets2/sky.png")

	copter = display.newSprite(group, sheet, sequenceData )
	copter.id = "copter"
	copter.x = display.contentWidth/4
	copter.y =  display.contentHeight/2

	gameover = display.newImage(group, "assets2/gameover.png")
	gameover.x, gameover.y = display.contentWidth/2,  display.contentHeight/2
	gameover.alpha=0

end

function scene:show( event )
    group = self.view	

	local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        ads.hide()	

        Runtime:addEventListener("tap", starting)

		composer.removeScene( "stats" )
		composer.removeScene( "menu" )
		composer.removeScene( "storec" )
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