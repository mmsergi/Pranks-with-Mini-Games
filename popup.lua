local scene = composer.newScene()

local t = loadTable( "settings.json" )

local group



 function chooseScreenshot()
 	
	if flag1 then 
		display.remove( screenshot )
		local screenshot=display.newImage( group, "assets/s_Lie.png",cx, cy )

	elseif flag2 then
		display.remove( screenshot )
		local screenshot=display.newImage( group, "assets/s_Call.png",cx, cy )
	elseif flag3 then
		display.remove( screenshot )
		local screenshot=display.newImage( group, "assets/s_Laser.png",cx, cy )
	end
backgroundFront()
end

local function balls()
	if flag1 then 
		local titulo=display.newText(group, translations["Lie Detector"][language], cx, topMarg+79, "BebasNeue", 42)
		C1 = display.newCircle( group, cx-40, bottomMarg-51, 15 )
		C1:setFillColor(.60, .671, .988)
		C2 = display.newCircle( group, cx, bottomMarg-51, 10 )
		C3 = display.newCircle( group, cx+40, bottomMarg-51, 10 )
	elseif flag2 then
		local titulo=display.newText(group, translations["Fake Call"][language], cx, topMarg+79, "BebasNeue", 42)
		C1 = display.newCircle( group, cx-40, bottomMarg-51, 10 )
		C2 = display.newCircle( group, cx, bottomMarg-51, 15 )
		C2:setFillColor(.60, .671, .988)
		C3 = display.newCircle( group, cx+40, bottomMarg-51, 10 )
	elseif flag3 then
		local titulo=display.newText(group, translations["Laser Sword"][language], cx, topMarg+79, "BebasNeue", 42)
		C1 = display.newCircle( group, cx-40, bottomMarg-51, 10 )
		C2 = display.newCircle( group, cx, bottomMarg-51, 10 )
		C3 = display.newCircle( group, cx+40, bottomMarg-51, 15 )
		C3:setFillColor(.60, .671, .988)
	end
	
end
local function iconExitTouch(event)
	    if ( event.phase == "ended") then
	    	composer.hideOverlay( "popup" )
		end
    	return true
	end

local function iconTiendaTouch(event)
	    if ( event.phase == "ended") then
	    	composer.hideOverlay( "popup" )
	    	composer.removeScene( "menu" )
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

local function flechaITouch(event)
	if ( event.phase == "ended") then
	    if t.unlocked==0 then
	    	if flag2 then
	    		flag2=false
	    		flag1=true
	    		chooseScreenshot()
	    	elseif flag3 then
	    		flag3=false
	    		flag2=true
	    		chooseScreenshot()
	    	end
	    elseif t.unlocked==1 then
	    	if flag3 then
	    		flag3=false
	    		flag2=true
	    		chooseScreenshot()
	    	end
		end
	end
    	return true
end

local function flechaDTouch(event)
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
	    	end
	    elseif t.unlocked==1 then
	    	if flag2 then
	    		flag2=false
	    		flag3=true
	    		chooseScreenshot()
	    	end
		end
	end
    	return true
end

function scene:create( event )
	group = self.view

local marco = display.newImage( group, "assets/marco.png", cx, cy )
local iconExit = display.newImage( group, "assets/iconExit.png", rightMarg-51, topMarg+40 )
local iconPlay2 = display.newSprite( iconPlaySheet, iconPlaySequence )
iconPlay2.x, iconPlay2.y = rightMarg-160, cy+230
iconPlay2:scale(0.56,0.56)

local iconTienda = display.newImage( group,"assets/iconTienda.png", leftMarg+155, cy+248 )

local flechaI = display.newImage( group,"assets/flecha.png", leftMarg+50, cy)
flechaI:scale(-1,1)
local flechaD = display.newImage( group,"assets/flecha.png", rightMarg-50, cy)


iconExit:addEventListener("touch",iconExitTouch)
iconTienda:addEventListener("touch",iconTiendaTouch)
iconPlay2:addEventListener("touch",iconPlayTouch)
flechaI:addEventListener("touch",flechaITouch)
flechaD:addEventListener("touch",flechaDTouch)

group:insert(iconPlay2)
balls()

function backgroundFront()
	marco:toFront( )
	iconExit:toFront( )
	iconPlay2:toFront( )
	iconTienda:toFront( )
	flechaI:toFront( )
	flechaD:toFront( )
	balls()
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