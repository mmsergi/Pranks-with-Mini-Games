local scene = composer.newScene()

local t = loadTable( "settings.json" )

local group

 	
	
local function iconExitTouch(event)
	    if ( event.phase == "ended") then
	    unlockedFlag=false
		    if composer.getSceneName( "current" )=="Retry_Minion" then
		    	MusicaRetry= audio.loadSound( "assets3/retryMinionMusic.ogg")
		    	MusicaRetryChannel= audio.play(MusicaRetry, {loops=(-1)})
		    elseif composer.getSceneName( "current" )=="Retry" then
		    	FondoMusica2= audio.loadSound( "assets4/rithm.ogg")
		    	FondoMusica2Channel= audio.play(FondoMusica2, {loops=(-1)})
		    end
   


	      if t.music==true then
	        	audio.setVolume(1)
	        elseif t.music==false then
	        	audio.setVolume(0)
	        end
	    	composer.hideOverlay("zoomOutInFade")
		end
    	return true
	end




function scene:create( event )
	group = self.view
	 unlockedFlag=true
	  audio.stop(MusicaRetryChannel)
    audio.dispose( MusicaRetry )
    MusicaRetry = nil 
    
    audio.stop(FondoMusica2Channel)
    audio.dispose( FondoMusica2 )
    FondoMusica2 = nil 

	local success = audio.loadSound( "assets/success.ogg")
	local starBust = display.newImage( group, "assets/starBust.png", cx, cy)
	local confeti = display.newImage( group, "assets/confeti.png", cx, cy)
	local confeti2 = display.newImage( group, "assets/confeti.png", cx, cy-800)
	local confeti3 = display.newImage( group, "assets/confeti.png", cx, cy-1600)
	local confeti4 = display.newImage( group, "assets/confeti.png", cx, cy-2400)

audio.setVolume(1)

	audio.play(success)
local function starBustRot()
    if ( reverse == 0 ) then
        reverse = 1
        transition.to( starBust, { rotation=-90, time=800, transition=easing.inOutCubic} )
    else
        reverse = 0
        transition.to( starBust, { rotation=90, time=800, transition=easing.inOutCubic } )
    end
end
timer.performWithDelay( 200, starBustRot, 1 )
timer.performWithDelay( 1150, starBustRot, 1 )
timer.performWithDelay( 2050, starBustRot, 1 )
timer.performWithDelay( 2900, starBustRot, 1 )

function moveConfeti()
		
		transition.moveTo( confeti, {y=cy+1600, time=3600} )
		transition.moveTo( confeti2, {y=cy+800, time=3600} )
		transition.moveTo( confeti3, {y=cy, time=3600} )

end

timer.performWithDelay( 300, moveConfeti, 1 )

	local unlockedPopup = display.newImage( group, "assets/unlockedPopup.png", cx, cy)


	local iconExit = display.newImage( group, "assets/iconExit.png", rightMarg-50, topMarg+45 )
		iconExit:addEventListener("touch",iconExitTouch)
		iconExit:scale(1.2,1.2)
local function handleTryEvent( event )

        if ( "ended" == event.phase ) then

        unlockedFlag=false
	        if t.music==true then
	        	audio.setVolume(0)
	        elseif t.music==false then
	        	audio.setVolume(1)
	        end
 			local currScene = composer.getSceneName( "current" )
            composer.removeScene( "juegoTOA")
            composer.removeScene( "EndlessH")
            composer.removeScene( "game")
            composer.removeScene( "gamein")
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