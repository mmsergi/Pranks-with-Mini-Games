local scene = composer.newScene()

local t = loadTable( "settings.json" )

local sound = audio.loadSound("assets/on.ogg")

local group
local fingerprintCancelado = false
local scanFinished=false
local bip = audio.loadSound("assets/bip.ogg")

local verdad = audio.loadSound("assets/verdad.ogg")
local mentira = audio.loadSound("assets/mentira.ogg")
-- fingerprint
    local fingerprintData = { width=181, height=250, numFrames=4,}
    local fingerprintSheet = graphics.newImageSheet( "assets/fingerprint.png", fingerprintData )    
    local fingerprintSequence = {
        { name = "reposo", start=2, count=1, time=125,},
        { name = "pulsado", start=1, count=1, time=125,},
        { name = "mentira", start=3, count=1, time=125,},
        { name = "verdad", start=4, count=1, time=125,},}
-- luz
    local luzData = { width=380, height=211, numFrames=3,}
    local luzSheet = graphics.newImageSheet( "assets/luz.png", luzData )    
    local luzSequence = {
        { name = "reposo", start=1, count=1, time=125,},
        { name = "verdad", start=2, count=1, time=125,},
        { name = "mentira", start=3, count=1, time=125,}}
local function goHome()
	composer.removeScene( "lieDetector" )
	composer.gotoScene( "menu" )
	
end
function publi()
	pRandom = math.random( 100 )
	if pRandom >= 70 then
		ads.show( "interstitial", { x=display.screenOriginX, y=display.screenOriginY, appId=interstitialretry} )
		print("PUBLI")
	else
	end
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

 function moverBarra()
	if fingerprintCancelado == false then
		barraForward = transition.moveTo( barra, {x=cx+60, time=2000, onComplete=decision} )
		tmrVibration = timer.performWithDelay( 200, function() system.vibrate() end, 0 )
		barraLuz.isVisible = true
		tr1 = transition.moveTo( barraLuz, {y=cy+240, time=1000, onComplete=moverbarraLuz} )
		transition.blink( scanText, { time=1000 } )
	else 
		transition.cancel( barraForward )
		timer.cancel( tmrVibration )
		barraBackwards = transition.moveTo( barra, {x=cx-85, time=2} )
	end
end

 function moverbarraLuz()
	tr2 = transition.moveTo( barraLuz, {y=cy, time=1000, onComplete=barraLuzDissapear})
end

function barraLuzDissapear()
	barraLuz.isVisible=false
	transition.cancel( barraLuz )
	barraLuz.y = cy
	transition.cancel(scanText )
	scanText.alpha = 1
end

 function decision()
	scanText.text = ""
	scanFinished = true
	dRandom = math.random(100)
	timer.cancel( tmrVibration )
	publi()
	if dRandom >= 51 then
		print ("Verdad")
		luzText.text = translations["Verdad"][language]
		luz:setSequence( "verdad" )
		audio.play(verdad)
	elseif dRandom <= 50 then 
		print("Mentira")
		luzText.text = translations["Mentira"][language]
		luz:setSequence( "mentira" )
		audio.play(mentira)
	end	
end

local function retorn()
	composer.gotoScene( "menu" )
end

function scene:create( event )
	group = self.view

	mayShowAd()

	barra = display.newImage( group, "assets/barra.png", cx-85, cy-62 )
	background = display.newImage( group, "assets/fondoSim.png", cx, cy )
	fingerprint = display.newSprite( group, fingerprintSheet, fingerprintSequence )
	luz = display.newSprite( group, luzSheet, luzSequence )
	barraLuz = display.newImage( group, "assets/barraLuz.png", cx, cy )

	barraLuz.isVisible = false

	fingerprint.x, fingerprint.y = cx, cy+110
	fingerprint:scale( 0.8, 0.8 )

	luz.x, luz.y = cx, cy-200
	luzText = display.newText(group, "", cx, cy-200, native.systemFontBold, 50)
local options = {
	text = "",
	parent = group,
	x = cx,
	y = cy-200,
	font = native.systemFont,
	width = 220,
	height = 0,
	fontSize = 30,
	align = "center",
	}
	scanText = display.newText(options)
function fingerprint:touch(event)
   	if ( event.phase == "began" ) then
   		bipChannel = audio.play( bip, { channel=1 } )
        fingerprint:setSequence( "pulsado" )
        fingerprint:scale( 0.97, 0.97 )
        fingerprintCancelado = false
        moverBarra()
        luzText.text = ""
        scanText.text = translations["Escaneando"][language]
        
		luz:setSequence( "reposo" )

	elseif ( event.phase == "cancelled" ) then
		fingerprint:setSequence( "reposo" )
		fingerprint:scale( 1.03, 1.03 )
		fingerprintCancelado = true
		timer.cancel( tmrVibration )
		audio.stop(bipChannel)
		scanText.text = translations["Escaneo abortado"][language]
		barraLuzDissapear()
		moverBarra()

	elseif ( event.phase == "ended" ) then
		fingerprint:setSequence( "reposo" )
		fingerprint:scale( 1.03, 1.03 )
		fingerprintCancelado = true
		scanText.text = translations["Escaneo abortado"][language]
		barraLuzDissapear()
		moverBarra()
		audio.stop(bipChannel)
		timer.cancel( tmrVibration )
		if scanFinished==true then
			scanText.text = ""
			scanFinished=false
		end
	elseif ( event.phase == "moved" ) then
		if math.abs(event.xStart - event.x) > 60 or math.abs(event.yStart- event.y) > 60 then
			fingerprint:setSequence( "reposo" )
			--fingerprint:scale( 1.03, 1.03 )
			timer.cancel( tmrVibration )
			fingerprintCancelado = true
			audio.stop(bipChannel)
			scanText.text = translations["Escaneo abortado"][language]
			barraLuzDissapear()
			moverBarra()
		end
    end
end
    fingerprint:addEventListener("touch",fingerprint)

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
		    height = 70,
		    width = 70,
		    defaultFile="assets/home.png",
		    onRelease = goHome,
		    parent = group,
		}

		
		homeBtn.x = 50
		homeBtn.y = bottomMarg-50
		
		group:insert( soundBtn )
		group:insert( homeBtn )
end

function scene:show( event )
	group = self.view
	


	if t.music==false then
		audio.setVolume(0)
	end

	composer.removeScene( "gamein" )

	ads.show( "banner", { x=0, y=topMarg, appId=bannersimulator} )
end


function scene:hide( event )
	group = self.view

	ads.hide()
	composer.removeScene( "menu" )
end


function scene:destroy( event )
	group = self.view
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene