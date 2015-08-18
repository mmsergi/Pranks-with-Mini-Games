local scene = composer.newScene()

local t = loadTable( "settings.json" )

local group

 	
	
local function iconExitTouch(event)
	    if ( event.phase == "ended") then
	    	composer.hideOverlay("zoomOutInFade")
		end
    	return true
	end




function scene:create( event )
	group = self.view
	local starBust = display.newImage( group, "assets/starBust.png", cx, cy)
	local confeti = display.newImage( group, "assets/confeti.png", cx, cy)
	local confeti2 = display.newImage( group, "assets/confeti.png", cx, cy-800)

local function starBustRot()
    if ( reverse == 0 ) then
        reverse = 1
        transition.to( starBust, { rotation=-90, time=1000, transition=easing.inOutCubic } )
    else
        reverse = 0
        transition.to( starBust, { rotation=90, time=1000, transition=easing.inOutCubic } )
    end
end
timer.performWithDelay( 300, starBustRot, 1 )
timer.performWithDelay( 1700, starBustRot, 1 )

function moveConfeti()
	
		transition.moveTo( confeti, {y=cy+800, time=2000} )
		transition.moveTo( confeti2, {y=cy, time=2000} )

end

timer.performWithDelay( 300, moveConfeti, 1 )

	local unlockedPopup = display.newImage( group, "assets/unlockedPopup.png", cx, cy)


	local iconExit = display.newImage( group, "assets/iconExit.png", rightMarg-40, topMarg+35 )
		iconExit:addEventListener("touch",iconExitTouch)
local function handleTryEvent( event )

        if ( "ended" == event.phase ) then
 			local currScene = composer.getSceneName( "current" )
                composer.removeScene( currScene )
                composer.gotoScene( "menu" )
          end
      end
local Trybtn = widget.newButton

    {
        defaultFile  = "assets/btn.png",
        onEvent = handleTryEvent
    }

group:insert(Trybtn)
Trybtn.x = cx
Trybtn.y = bottomMarg-125
   
	

end

function scene:show( event )
	group = self.view


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