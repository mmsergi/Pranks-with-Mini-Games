local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

--Moneda            
local MonedaSheet = graphics.newImageSheet( "Moneda.png", { width=38, height=41, numFrames=13} )    
local MonedaSequence = {
            { name = "inicial", start=1, count=4, time=1600, },
            { name = "comida", start=5, count=4, time=400, },
            { name = "desaparece", start=9, count=5, time=500, }} 

 local options = {
        width = 158,
        height = 35,
        numFrames = 2,
    }
    tituloShopSheet = graphics.newImageSheet( "tituloShop.png", options )

local scene = composer.newScene()

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view


fondoShop=display.newImage(sceneGroup,"fondoShop.png", display.contentCenterX,display.contentCenterY)

   
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

   --HUD galletas
--Monedas = display.newSprite( sceneGroup, MonedaSheet, MonedaSequence)
Monedas = display.newImage(sceneGroup,"banana.png")
--Monedas:setSequence("inicial")
--Monedas:play()
monedaScale=0.5
Monedas:scale(monedaScale,monedaScale)
Monedas.x=rightMarg-22
Monedas.y=topMarg+22
Monedas:scale(0.9,0.9)

   local options = 
{
    parent = sceneGroup,
    text = user.galletas,     
    x = rightMarg-105,
    y = topMarg+24,
    width = 128,     --required for multi-line and alignment
    font = "telo",   
    fontSize = 30,
    align = "right"  --new alignment parameter
}

local totalGalletas=display.newEmbossedText(options)
totalGalletas:setFillColor(.424, .20, .008) 
 


--nube titulo

nubeTitulo=display.newImage(sceneGroup, "nubeTitulo.png", display.contentCenterX, topMarg+100)
function reducirnube()
transition.scaleTo( nubeTitulo, { xScale=0.95, yScale=0.95, time=2500 } )
transition.moveTo( nubeTitulo, {x=display.contentCenterX-8,time=2500} )

Nubetimer1=timer.performWithDelay( 2500, aumentarnube)
end
function aumentarnube()

transition.scaleTo( nubeTitulo, { xScale=1, yScale=1, time=2500 } )
transition.moveTo( nubeTitulo, {x=display.contentCenterX+8, time=2500} )

Nubetimer2=timer.performWithDelay( 2500, reducirnube)
end
reducirnube()


--tituloShop

local function handleTituloShopEvent1( event )

        if ( "ended" == event.phase )  then
        --SOON
                   
                   --composer.hideOverlay( "shop")
                   --composer.showOverlay( "characters",{isModal=true} )
                   
        end

    end
    -- Characters
    local tituloShop1= widget.newButton

    {
        sheet = tituloShopSheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = handleTituloShopEvent1,
        label="Characters",
        labelColor={ default={.424, .20, .008 }, over={ .788, 0, 0 } },
        font="telo",
        fontSize=20,
    }
	sceneGroup:insert(tituloShop1)

	    -- Backgrounds
	    local tituloShop2= widget.newButton

	    {
	        sheet = tituloShopSheet,
	        defaultFrame = 1,
	        overFrame = 2,
	        onEvent = handleTituloShopEvent2,
	        label="Backgrounds",
	        labelColor={ default={.424, .20, .008 }, over={ .788, 0, 0 } },
	        font="telo",
	        fontSize=20,
            labelAlign="right"
	    }
		sceneGroup:insert(tituloShop2)

		    -- Power-ups
		    local tituloShop3= widget.newButton

		    {
		        sheet = tituloShopSheet,
		        defaultFrame = 1,
		        overFrame = 2,
		        onEvent = handleTituloShopEvent3,
		        label="Power-ups",
		        labelColor={ default={.424, .20, .008 }, over={ .788, 0, 0 } },
		        font="telo", 
		        fontSize=20,

		    }
			sceneGroup:insert(tituloShop3)

			    -- Cookies
			    local tituloShop4= widget.newButton

			    {
			        sheet = tituloShopSheet,
			        defaultFrame = 1,
			        overFrame = 2,
			        onEvent = handleTituloShopEvent4,
			        label="Cookies",
			        labelColor={ default={.424, .20, .008 }, over={ .788, 0, 0 } },
			        font="telo",
			        fontSize=20,
			    }
				sceneGroup:insert(tituloShop4)

    tituloShop1.x=display.contentCenterX tituloShop2.x=display.contentCenterX tituloShop3.x=display.contentCenterX tituloShop4.x=display.contentCenterX
	tituloShop1.y=display.contentCenterY-70
	tituloShop2.y=display.contentCenterY+10
	tituloShop3.y=display.contentCenterY+90
	tituloShop4.y=display.contentCenterY+170


shopMin1=display.newImage(sceneGroup,"shopMin1.png",display.contentCenterX,display.contentCenterY+45)
shopMin1:scale(1.39,1.39)



local s= 2
tituloShop1:scale(s,s)
tituloShop2:scale(s,s)
tituloShop3:scale(s,s)
tituloShop4:scale(s,s)




--Soon
fondo=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
fondo:setFillColor( 0,0,0,0.5 )

soon=display.newImage( sceneGroup, "soon.png",display.contentCenterX,display.contentCenterY-50 )
soon.rotation=-25
soon:scale(0.9,0.9)
--shop
 local function handleShopEvent( event )

        if ( "ended" == event.phase ) then
     
                    
                    local prevScene = composer.getSceneName( "current" )

                    --composer.gotoScene( prevScene )
                    --composer.removeScene("shop")
                    composer.hideOverlay( "shop" )
                     if prevScene=="EndlessH" then
                        composer.showOverlay( "pauseOverlay")
                    end
        end

    end


     local options = {
        width = 48,
        height = 47,
        numFrames = 2,}
    local shopSheet = graphics.newImageSheet( "return.png", options )
    local shopBut = widget.newButton
    {sheet = shopSheet,
     defaultFrame = 1,
     overFrame = 2,
     onEvent = handleShopEvent}     

    sceneGroup:insert(shopBut)
shopBut.x= leftMarg+26
shopBut.y=topMarg+26






    elseif ( phase == "did" ) then
    
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
       
    elseif ( phase == "did" ) then
     

    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view


end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene