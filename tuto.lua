local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local circulo
local minusButtonPressed = false
local function handleButtonEvent( event )

    if ( "ended" == event.phase )and (minusButtonPressed == false)  then
    audio.play(gato)
    minusButtonPressed = true
        composer.gotoScene( "EndlessH", {effect="crossFade", time=800})
end
end
-- Image sheet options and declaration
local options = {
    width = 206,
    height = 91,
    numFrames = 2,
}
local buttonSheet = graphics.newImageSheet( "botonResume.png", options )

-- Create the widget
local button1 = widget.newButton

{
    sheet = buttonSheet,
    defaultFrame = 1,
    overFrame = 2,
    
    onEvent = handleButtonEvent
}

local options = {
        width = 158,
        height = 35,
        numFrames = 2,
    }
    tituloShopSheet = graphics.newImageSheet( "tituloShop.png", options )
-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

local scrollView
local icons = {}
local function iconListener( event )
    local id = event.target.id
    if ( event.phase == "moved" ) then
        local dx = ( event.x - event.xStart ) 
        if ( math.abs(dx) > 10 ) then

            if id=="1" then
                
                if dx<0 then 
                scrollView:scrollToPosition{ x = -380,time = 800,}
                transition.fadeOut( circulos[2], {time=800} )
                transition.fadeIn( circulos[1], {time=800} )

                end
            end
            if id=="2" then

                if dx<0 then 
                scrollView:scrollToPosition{ x = -760,time = 800,}
                transition.fadeOut( circulos[3], {time=800} )
                transition.fadeIn( circulos[2], {time=800} )
               
                elseif dx>0 then 
                scrollView:scrollToPosition{ x = 0,time = 800,}
                transition.fadeOut( circulos[1], {time=800} )
                transition.fadeIn( circulos[2], {time=800} )
                 
                end
            end
            if id=="3" then

                if dx<0 then 
                scrollView:scrollToPosition{ x = -1140,time = 800,}
                transition.fadeOut( circulos[4], {time=800} )
                transition.fadeIn( circulos[3], {time=800} )
                transition.fadeIn( button1, {delay=1000,time=1300} )
                elseif dx>0 then 
                scrollView:scrollToPosition{ x = -380,time = 800,}
                transition.fadeOut( circulos[2], {time=800} )
                transition.fadeIn( circulos[3], {time=800} )

                
                end
            end
            if id=="4" then

              
                if dx>0 then 
                scrollView:scrollToPosition{ x = -760,time = 800,}
                transition.fadeOut( circulos[3], {time=800} )
                transition.fadeIn( circulos[4], {time=800} )
                transition.fadeOut( button1, {time=400} )
                end
            end


        
         

    elseif ( event.phase == "ended" ) then
        --take action if an object was touched
        print( "object", id, "was touched" )
  
end

 
    end
    return true
end

        scrollView = widget.newScrollView
        {
            width = display.actualContentWidth,
            height = display.actualContentHeight,
            verticalScrollDisabled = true
        }
        scrollView.x = display.contentCenterX
        scrollView.y = display.contentCenterY

            icons[1]=display.newImage( scrollView,"tuto1.png",display.contentCenterX,display.contentCenterY )
            icons[2]=display.newImage( scrollView,"tuto2.png",display.contentCenterX+380,display.contentCenterY )
            icons[3]=display.newImage( scrollView,"tuto3.png",display.contentCenterX+760,display.contentCenterY )
            icons[4]=display.newImage( scrollView,"tuto4.png",display.contentCenterX+1140,display.contentCenterY )

            icons[1].id = "1"
            icons[2].id = "2"
            icons[3].id = "3"
            icons[4].id = "4"

            icons[1]:addEventListener( "touch", iconListener )
            icons[2]:addEventListener( "touch", iconListener )
            icons[3]:addEventListener( "touch", iconListener )
            icons[4]:addEventListener( "touch", iconListener )


            scrollView:insert(icons[1])
            scrollView:insert(icons[2])
            scrollView:insert(icons[3])
            scrollView:insert(icons[4])
            sceneGroup:insert(scrollView)
    
   
 circulosAzules={}
 for i = 1, 4 do
            
circulosAzules[i]=display.newCircle( sceneGroup, leftMarg+i*display.actualContentWidth/5, bottomMarg-20, 12)
circulosAzules[i]:setFillColor( .047, .584, .941)
end
 circulos={}
 for i = 1, 4 do
            
circulos[i]=display.newCircle( sceneGroup, leftMarg+i*display.actualContentWidth/5, bottomMarg-20, 12)
circulos[i]:setFillColor( 1,1,1)
transition.fadeOut( circulos[1], {time=1} )
end



sceneGroup:insert(button1)


-- Center the button
button1.x = display.contentCenterX
button1.y = display.contentCenterY
transition.fadeOut( button1, {time=1} )


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