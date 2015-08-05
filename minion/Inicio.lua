local composer = require "composer"
local ads = require( "ads" )
local scene = composer.newScene()

            
function scene:create( event )

    local sceneGroup = self.view
Logo=display.newImage( "PerilGames.jpg", display.contentCenterX,display.contentCenterY )

 sceneGroup:insert(Logo)


end
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

if ( phase == "will" ) then    



   ads.show( "interstitial", { appId="ca-app-pub-3836849703819703/5421353678" } )


     elseif ( phase == "did" ) then    

timer.performWithDelay(1500,function () composer.gotoScene( "menu") end ) 


    end
   
end



-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

-- -------------------------------------------------------------------------------

return scene








