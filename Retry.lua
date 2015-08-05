local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar )
local ads = require( "ads" )
local AdBuddiz = require "plugin.adbuddiz"
local gameNetwork = require( "gameNetwork" )
local t = loadTable( "settings.json" )

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
--local GA = require ( "plugin.gameanalytics" )
-- local forward references should go here
local background
local Gameover
local notas
--Moneda            
local MonedaSheet = graphics.newImageSheet( "assets4/Moneda.png", { width=38, height=41, numFrames=13} )    
local MonedaSequence = {
            { name = "inicial", start=1, count=4, time=1600, },
            { name = "comida", start=5, count=4, time=400, },
            { name = "desaparece", start=9, count=5, time=500, }} 

local moregamesSheet = graphics.newImageSheet( "assets4/moregames.png", { width=206, height=91, numFrames=2} )    
local moregamesSequence = {
            { name = "inicial", start=1, count=2, time=1500, }}



 

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

FondoMusica2= audio.loadSound( "assets4/rithm.ogg")
function showInter()
 if math.random(100)<=25 then

ads.show( "interstitial", { appId=interstitialretry } )

 end
end

fondoRetry=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, 800 )
fondoRetry:setFillColor( 0.533, 0.933, 0.996 )

retryStarburst=display.newImage( sceneGroup, "assets4/retryStarburst.png", display.contentCenterX,topMarg+150) 
retryStarburst:scale(2,2)
retryStarburst.rotation = -45
local reverse = 1

local function retryStarburstRot()
    if ( reverse == 0 ) then
        reverse = 1
        transition.to( retryStarburst, { rotation=-90, time=1000, transition=easing.inOutCubic } )
    else
        reverse = 0
        transition.to( retryStarburst, { rotation=90, time=1000, transition=easing.inOutCubic } )
    end
end
timer.performWithDelay( 600, retryStarburstRot, 1 )
timer.performWithDelay( 1700, retryStarburstRot, 1 )

--fondoRetryInferior=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY+display.actualContentHeight/4, display.actualContentWidth, 20 )
--fondoRetryInferior:setFillColor( 0.533, 0.933, 0.996 )

if highScoreFlag  then --si la flag situada en guardaPuntos() de Endless.lua esta activada ponemos new highscore
      scoreImage=display.newImage( sceneGroup, "assets4/highScore.png", display.contentCenterX,topMarg+70)   
else

scoreImage=display.newImage( sceneGroup, "assets4/Score.png", display.contentCenterX,topMarg+60) 
end

--highscoreImage=display.newImage( sceneGroup, "highScore.png", display.contentCenterX,topMarg+60) 
--Retry

    minusButtonPressed = false
    


  
--Moregames

moregames=display.newSprite(sceneGroup,moregamesSheet,moregamesSequence)
moregames:play()

moregames.x= cx
moregames.y=cy+165
moregames:scale(1,1)

function moregames:tap()
AdBuddiz.showAd() 
end
moregames:addEventListener("tap",moregames)

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
    soundBtn.x , soundBtn.y = rightMarg-50, bottomMarg-140

    end
end

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

     
    soundBtn.x , soundBtn.y = rightMarg-50, bottomMarg-140


sceneGroup:insert(soundBtn)



--HUD galletas
--Monedas = display.newSprite( sceneGroup, MonedaSheet, MonedaSequence)
Monedas = display.newImage(sceneGroup,"assets4/banana.png")
--Monedas:setSequence("inicial")
--Monedas:play()
monedaScale=0.69
Monedas:scale(monedaScale,monedaScale)
Monedas.x=rightMarg-30
Monedas.y=topMarg+30
Monedas:scale(0.9,0.9)


   local options = 
{
    parent = sceneGroup,
    text = user.galletas,     
    x = rightMarg-120,
    y = topMarg+24,
    width = 128,     --required for multi-line and alignment
    font = "telo",   
    fontSize = 41,
    align = "right"  --new alignment parameter
}

local totalGalletas=display.newEmbossedText(options)
totalGalletas:setFillColor(.424, .20, .008) 
local function goHome()
       
   composer.removeScene( "EndlessH")
   composer.removeScene( "Retry")
       composer.gotoScene( "menu2" )
      
end

local homeBtn = widget.newButton
        {
            defaultFile="assets/home.png",
            overFile="assets/home_2.png",
            onRelease = goHome,
            parent = group,
        }

        homeBtn.x = display.contentWidth/2
        homeBtn.y = bottomMarg-140
        
        
        sceneGroup:insert( homeBtn )




end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

if ( phase == "will" ) then 



   --Publi
    ads.show( "banner", { x=0, y=1000, appId=bannerretry } )--cargar anuncio admob

retryNube=display.newImage(sceneGroup,"assets4/retryNube.png", display.contentCenterX, bottomMarg-33)
retryNube:scale(1.38,1.38)

retryNubeI=display.newImage(sceneGroup,"assets4/retryNube.png", leftMarg-40, display.contentCenterY-15)
retryNubeI:scale(1.38,1.656)

retryNubeD=display.newImage(sceneGroup,"assets4/retryNube.png", rightMarg+40, display.contentCenterY-15)
retryNubeD:scale(1.38,1.656)

local ActualScore = display.newText(sceneGroup,user.actualScore, display.contentCenterX, topMarg+155, "telo", 207)
ActualScore:setFillColor(.992, .31, .02)

local actualgalletas = display.newEmbossedText(sceneGroup,"+"..user.actualgalletas, leftMarg+48, display.contentCenterY, "telo", 50)
actualgalletas:setFillColor(.992, .31, .02)

local HighScore = display.newEmbossedText(sceneGroup,user.highScore,rightMarg-55, display.contentCenterY, "telo", 50)
HighScore:setFillColor(.992, .31, .02)

local best=display.newImage(sceneGroup,"assets4/best.png", rightMarg-62, display.contentCenterY-45)
best:scale(0.83,0.83)

local cookies=display.newImage(sceneGroup,"assets4/cookies.png", leftMarg+90, display.contentCenterY-45)
cookies:scale(0.81,0.81)

function reducirnube()
transition.scaleTo( retryNubeI, { xScale=0.95, yScale=0.95, time=2000 } )
transition.moveTo( retryNubeI, {x=leftMarg-35,time=2000} )

transition.moveTo( HighScore, {x=rightMarg-50, time=2000} )
transition.moveTo( best, {x=rightMarg-57,time=2000} )

transition.moveTo( actualgalletas, {x=leftMarg+53, time=2000} )
transition.moveTo( cookies, {x=leftMarg+95, time=2000} )

transition.scaleTo( retryNubeD, { xScale=0.95, yScale=0.95, time=2000 } )
transition.moveTo( retryNubeD, {x=rightMarg+45,time=2000} )

Nubetimer1=timer.performWithDelay( 2000, aumentarnube)
end
function aumentarnube()

transition.scaleTo( retryNubeI, { xScale=1, yScale=1, time=2000 } )
transition.moveTo( retryNubeI, {x=leftMarg-45, time=2000} )

transition.moveTo( HighScore, {x=rightMarg-60, time=2000} )
transition.moveTo( best, {x=rightMarg-67, time=2000} )

transition.moveTo( actualgalletas, {x=leftMarg+43, time=2000} )
transition.moveTo( cookies, {x=leftMarg+85, time=2000} )

transition.scaleTo( retryNubeD, { xScale=1, yScale=1, time=2000 } )
transition.moveTo( retryNubeD, {x=rightMarg+35, time=2000} )

Nubetimer2=timer.performWithDelay( 2000, reducirnube)
end
reducirnube()









     elseif ( phase == "did" ) then  

FondoMusica2Channel= audio.play(FondoMusica2, {loops=(-1)})


    local function handleRetryEvent( event )

        if ( "ended" == event.phase )and (minusButtonPressed == false)  then
                    
                    analytics.logEvent( "RetrySession" )
                    composer.removeScene("EndlessH")
                    audio.stop(FondoMusica2Channel)
                   audio.rewind(FondoMusicaChannel)
                    composer.removeScene("Retry")
                    local options = {
                        effect = "slideUp",
                        time = 800,}

                        composer.gotoScene( "EndlessH",options)
                        ads.hide("banner")
                        showInter()
                    
                    minusButtonPressed = true
                     audio.play( CheersAudio )
                     nubeFlag=true
                      --transition.to( retryNube, {alpha=0,y=-60,time=100 })
        end

    end

     
    -- Image sheet options and declaration
    local options = {
        width = 206,
        height = 91,
        numFrames = 2,
    }
    local RetrySheet = graphics.newImageSheet("assets4/botonRetry.png", options )

    -- Create the widget
    local Retry = widget.newButton

    {
        sheet = RetrySheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = handleRetryEvent
    }

sceneGroup:insert(Retry)
Retry.x = display.contentCenterX
Retry.y = cy+50
Retry:scale(1.38,1.38)      



end
end
-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    display.remove( soundBtn )
    audio.stop( FondoMusica2Channel )
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene