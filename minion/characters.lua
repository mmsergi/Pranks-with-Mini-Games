local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

--Moneda            
local MonedaSheet = graphics.newImageSheet( "Moneda.png", { width=38, height=41, numFrames=13} )    
local MonedaSequence = {
            { name = "inicial", start=1, count=4, time=1600, },
            { name = "comida", start=5, count=4, time=400, },
            { name = "desaparece", start=9, count=5, time=500, }} 
--marcos            
local marcosSheet = graphics.newImageSheet( "marcosShop.png", { width=124, height=133, numFrames=2} )    
local marcosSequence = {
            { name = "inicial", start=1, count=1, time=1600, },
            { name = "vendido", start=2, count=1, time=400, },}

local dentroMarcosSheet = graphics.newImageSheet( "dentroMarcos.png", { width=124, height=133, numFrames=2} )    
local dentroMarcosSequence = {
            { name = "flinn", start=1, count=1, time=1600, },
            { name = "Jack", start=2, count=1, time=400, },}            
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
Monedas = display.newSprite( sceneGroup, MonedaSheet, MonedaSequence)
Monedas:setSequence("inicial")
Monedas:play()
Monedas.x=rightMarg-20
Monedas.y=topMarg+22
Monedas:scale(0.9,0.9)

--totalgalletas
function sumagalletas()
user.galletas=user.galletas+user.actualgalletas
-- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
end
sumagalletas()

local totalGalletas=display.newEmbossedText(sceneGroup,user.galletas, rightMarg-72, topMarg+25, "telo", 30)
totalGalletas:setFillColor(.424, .20, .008) 
 
--shop
 local function handleShopEvent( event )

        if ( "ended" == event.phase ) then

					composer.showOverlay( "shop")
                   	
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
--flinn
dentroFlinn=display.newSprite(sceneGroup,dentroMarcosSheet, dentroMarcosSequence)
dentroFlinn.x=leftMarg+80
dentroFlinn.y=display.contentCenterY-90



--jack
dentroJack=display.newSprite(sceneGroup,dentroMarcosSheet, dentroMarcosSequence)
dentroJack.x=rightMarg-80
dentroJack.y=display.contentCenterY-90
dentroJack:setSequence( "Jack" )

--artículos
marcos = {}
        for i = 1, 10, 1 do
        marcos[i]=display.newSprite(sceneGroup, marcosSheet, marcosSequence)
        marcos[i].x=leftMarg-80
		marcos[i].y=display.contentCenterY-20
	   end


marcos[1].x=leftMarg+80
marcos[1].y=display.contentCenterY-90
marcos[1]:setSequence( "vendido" )


marcos[2].x=rightMarg-80
marcos[2].y=display.contentCenterY-90




precioJack=display.newText( sceneGroup, "117", rightMarg-80, display.contentCenterY-52, "telo",25 )
precioJack:setFillColor(.424, .20, .008) 

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
tituloShop1:setEnabled( falsse )
local s= 2
tituloShop1:scale(s,s)
tituloShop1.x=display.contentCenterX
tituloShop1.y=topMarg+90



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