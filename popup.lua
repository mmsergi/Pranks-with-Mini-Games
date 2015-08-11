local scene = composer.newScene()

local t = loadTable( "settings.json" )

local group
local flechaD
local flechaI
local titulo
local textoBloqueo
local valorDesbloqueo="5"
local optionsTextoBloqueo = {
	text= translations["to unlock"][language],
	x= cx+100,
	y= cy+123,
	font= "LobsterTwo-Regular",
	fontSize= 42,
	width= 220,
	align= "left"
}
local optionsValorDesbloqueo = {
	text= valorDesbloqueo,
	x= cx-150,
	y= cy+135,
	font= "LobsterTwo-Regular",
	fontSize= 60,
	width= 150,
	align= "right"
}

 function chooseScreenshot()
 	
	if flag1 then 
		display.remove( screenshot )
		local screenshot=display.newImage( group, "assets/s_Lie.png",cx, cy+10 )
		valorDesbloqueo = 15-(t.coins)
		textoValorDesbloqueo.text=valorDesbloqueo
	elseif flag2 then
		display.remove( screenshot )
		local screenshot=display.newImage( group, "assets/s_Call.png",cx, cy+10 )
		valorDesbloqueo = 50-(t.coins)
		textoValorDesbloqueo.text=valorDesbloqueo
	elseif flag3 then
		display.remove( screenshot )
		local screenshot=display.newImage( group, "assets/s_Laser.png",cx, cy+10 )
		valorDesbloqueo = 100-(t.coins)
		textoValorDesbloqueo.text=valorDesbloqueo
	end
backgroundFront()
end

local function balls()
	if t.unlocked==0 then
		if flag1 then 
			titulo.text=translations["Lie Detector"][language]
			textoBloqueo.text=translations["to unlock"][language]

			C1 = display.newCircle( group, cx-40, bottomMarg-41, 15 )
			C1:setFillColor(.60, .671, .988)
			C2 = display.newCircle( group, cx, bottomMarg-41, 10 )
			C3 = display.newCircle( group, cx+40, bottomMarg-41, 10 )
		elseif flag2 then
			titulo.text=translations["Fake Call"][language]
			textoBloqueo.text=translations["to unlock"][language]
			C1 = display.newCircle( group, cx-40, bottomMarg-41, 10 )
			C2 = display.newCircle( group, cx, bottomMarg-41, 15 )
			C2:setFillColor(.60, .671, .988)
			C3 = display.newCircle( group, cx+40, bottomMarg-41, 10 )
		elseif flag3 then
			titulo.text=translations["Laser Sword"][language]
			textoBloqueo.text=translations["to unlock"][language]
			C1 = display.newCircle( group, cx-40, bottomMarg-41, 10 )
			C2 = display.newCircle( group, cx, bottomMarg-41, 10 )
			C3 = display.newCircle( group, cx+40, bottomMarg-41, 15 )
			C3:setFillColor(.60, .671, .988)
		end
	elseif t.unlocked==1 then
		if flag2 then
			titulo.text=translations["Fake Call"][language]
			textoBloqueo.text=translations["to unlock"][language]
			C2 = display.newCircle( group, cx-20, bottomMarg-41, 15 )
			C2:setFillColor(.60, .671, .988)
			C3 = display.newCircle( group, cx+20, bottomMarg-41, 10 )
		elseif flag3 then
			titulo.text=translations["Laser Sword"][language]
			textoBloqueo.text=translations["to unlock"][language]
			C2 = display.newCircle( group, cx-20, bottomMarg-41, 10 )
			C3 = display.newCircle( group, cx+20, bottomMarg-41, 15 )
			C3:setFillColor(.60, .671, .988)
		end

	elseif t.unlocked==2 then	
		titulo.text=translations["Laser Sword"][language]
		C2 = display.newCircle( group, cx, bottomMarg-41, 15 )
		C2:setFillColor(.60, .671, .988)
		flechaD.isVisible=false
		flechaI.isVisible=false
	end
end

local function iconExitTouch(event)
	    if ( event.phase == "ended") then
	    	composer.hideOverlay("zoomOutInFade")
		end
    	return true
	end

local function iconTiendaTouch(event)
	    if ( event.phase == "ended") then
	    	composer.hideOverlay( "popup" )
	    	composer.removeScene( "menu" )
	    	ads:setCurrentProvider("vungle")
	    	composer.gotoScene( "tienda" )
		end
    	return true
	end

local function iconPlayTouch(event)
	    if ( event.phase == "ended") then
	    	composer.hideOverlay( "popup" )
	    	composer.removeScene( "menu" )
	    	composer.gotoScene( "menu2" )
		end
    	return true
	end

local function flechaIHandle(event)
	if ( event.phase == "ended") then
	    if t.unlocked==0 then
	    	if flag1 then 
				flag1=false
	    		flag3=true
	    		chooseScreenshot()
	    	elseif flag2 then
	    		flag2=false
	    		flag1=true
	    		chooseScreenshot()
	    	elseif flag3 then
	    		flag3=false
	    		flag2=true
	    		chooseScreenshot()
	    	end
	    elseif t.unlocked==1 then
	    	if flag2 then
	    		flag2=false
	    		flag3=true
	    		chooseScreenshot()
	    	elseif flag3 then
	    		flag3=false
	    		flag2=true
	    		chooseScreenshot()
	    	end
		end
	end
    	return true
end

local function flechaDHandle(event)
	if ( event.phase == "ended") then
	    if t.unlocked==0 then
	    	if flag1 then
	    		flag1=false
	    		flag2=true
	    		chooseScreenshot()
	    	elseif flag2 then
	    		flag2=false
	    		flag3=true
	    		chooseScreenshot()
	    	elseif flag3 then
	    		flag3=false
	    		flag1=true
	    		chooseScreenshot()
	    	end
	    elseif t.unlocked==1 then
	    	if flag2 then
	    		flag2=false
	    		flag3=true
	    		chooseScreenshot()
	    	elseif flag3 then
	    		flag3=false
	    		flag2=true
	    		chooseScreenshot()
	    	end
		end
	end
    	return true
end

function scene:create( event )
	group = self.view

	local marco = display.newImage( group, "assets/marco.png", cx, cy+10 )

	local iconExit = display.newImage( group, "assets/iconExit.png", leftMarg+45, topMarg+55 )

	titulo=display.newText(group, translations["Lie Detector"][language], cx, topMarg+95, "BebasNeue", 40)

	textoBloqueo=display.newText(optionsTextoBloqueo)
	textoBloqueo:rotate(-3)

	textoValorDesbloqueo=display.newText(optionsValorDesbloqueo)
	textoValorDesbloqueo:rotate(-3)
	local iconPlay2 = display.newSprite( iconPlaySheet, iconPlaySequence )
	iconPlay2.x, iconPlay2.y = leftMarg+155, cy+250
	iconPlay2:scale(0.56,0.56)

	local iconTienda = display.newImage( group,"assets/iconTienda.png",rightMarg-160, cy+255 )

	flechaI = widget.newButton{
				defaultFile="assets/flecha_on.png",
				overFile="assets/flecha_off.png",
				onEvent = flechaIHandle
			}
	flechaD = widget.newButton{
				defaultFile="assets/flecha_on.png",
				overFile="assets/flecha_off.png",
				onEvent = flechaDHandle
			}

	flechaI.x, flechaI.y = leftMarg+50, cy+10
	flechaD.x, flechaD.y = rightMarg-50, cy+10
	flechaI:scale(-1,1)

	iconExit:addEventListener("touch",iconExitTouch)
	iconTienda:addEventListener("touch",iconTiendaTouch)
	iconPlay2:addEventListener("touch",iconPlayTouch)


	group:insert(iconPlay2)
	group:insert(flechaI)
	group:insert(flechaD)
	group:insert(textoBloqueo)
	group:insert(textoValorDesbloqueo)
	balls()

	function backgroundFront()
		marco:toFront( )
		iconExit:toFront( )
		iconPlay2:toFront( )
		iconTienda:toFront( )
		flechaI:toFront( )
		flechaD:toFront( )
		balls()
		titulo:toFront( )
		textoBloqueo:toFront( )
		textoValorDesbloqueo:toFront( )
	end
	chooseScreenshot()

end

function scene:show( event )
	group = self.view


end


function scene:hide( event )
	group = self.view
	flag1 = false
	flag2 = false
	flag3 = false

end


function scene:destroy( event )
	group = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene