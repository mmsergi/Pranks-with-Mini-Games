local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar )











-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

fondo=display.newImage("OverlayInicio.png")
sceneGroup:insert(fondo)







end --Fin scene:create( event )

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

        if ( phase == "will" ) then

fondo.x=display.contentCenterX
fondo.y=display.contentCenterY



        	  elseif ( phase == "did" ) then  

local function myTouchListener( event )

    if ( event.phase == "began" ) then
     composer.gotoScene( "juegoTOA" )
    end
    return true  --prevents touch propagation to underlying objects
end


fondo:addEventListener( "touch", myTouchListener )  --add a "touch" listener to the object


end
end
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

-- -------------------------------------------------------------------------------
--physics.setDrawMode( "hybrid" )
return scene -- cierra create scene
