
local scene = composer.newScene()
local t = loadTable( "settings.json" )
local background
local Gameover
local notas


local moregamesSheet = graphics.newImageSheet( "assets4/moregames.png", { width=206, height=91, numFrames=2} )    
local moregamesSequence = {
            { name = "inicial", start=1, count=2, time=1500, }}



 

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view




 fondo = display.newImage(sceneGroup,"assets3/Overlay1.png")
   fondo.x=display.contentCenterX
fondo.y=display.contentCenterY
if highScoreFlag  then --si la flag situada en guardaPuntos() de Endless.lua esta activada ponemos new highscore
     new=display.newImage( sceneGroup,"assets3/NewHighscore.png", display.contentCenterX+55, display.contentCenterY-110 )
        new:rotate(-35)

        print("highscore")
end
   
 
  
--Moregames

moregames=display.newImage( sceneGroup,"assets3/moregames.png", cx, cy+180)


moregames:scale(0.65,0.65)

function moregames:tap()
 showMoreGamesAd()
end
moregames:addEventListener("tap",moregames)





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

totalGalletas.isVisible=false


 mayShowAd()
    checkLocks(t)
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

if ( phase == "will" ) then 


local ActualScore = display.newText(sceneGroup,user.actualScore, display.contentCenterX-110, display.contentCenterY-30, "telo", 50)
ActualScore:setFillColor(.365, .247, .051)



local HighScore = display.newEmbossedText(sceneGroup,user.highScoreMinion,display.contentCenterX+110, display.contentCenterY-30, "telo",50)
 HighScore:setFillColor(.365, .247, .051)

    
    local hud = require( "hud" )
    sceneGroup:insert( hudCoins)
    sceneGroup:insert( coins)
    sceneGroup:insert( coinsText)
    showNumCoins(coinsText, numCoins, duration) 



    local function handleRetryEvent( event )

        if ( "ended" == event.phase ) then
                     
                    composer.removeScene("juegoTOA")
                   
                   audio.rewind(FondoMusicaChannel)
                   
                    
                        composer.removeScene( "Retry_Minion" )
                        composer.gotoScene( "juegoTOA")
                        
                    
                    
        
        end

    end

     
    -- Image sheet options and declaration
    local options = {
        width = 206,
        height = 91,
        numFrames = 2,
    }
    local RetrySheet = graphics.newImageSheet( "assets4/botonRetry.png", options )

    -- Create the widget
   Retry = widget.newButton

    {
        sheet = RetrySheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = handleRetryEvent
    }

sceneGroup:insert(Retry)
Retry.x = display.contentCenterX
Retry.y = display.contentCenterY+50
Retry:scale(1.2,1.2)     

Retry:setEnabled( false )





     elseif ( phase == "did" ) then  
Retry:setEnabled( true )

   MusicaRetry= audio.loadSound( "assets3/retryMinionMusic.ogg")
MusicaRetryChannel= audio.play(MusicaRetry, {loops=(-1)})

local function goHome()
       
   composer.removeScene( "juegoTOA")
   composer.removeScene( "Retry_Minion")
       composer.gotoScene( "menu2" )
      
end

local homeBtn = widget.newButton
        {
            defaultFile="assets/back.png",
            overFile="assets/back_2.png",
            onRelease = goHome,
            parent = group,
        }

        homeBtn.x = leftMarg+50
        homeBtn.y = bottomMarg-50
        
        
        sceneGroup:insert( homeBtn )

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
    soundBtn.anchorX , soundBtn.anchorY = 1, 1 
    soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 25

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

     
    soundBtn.anchorX , soundBtn.anchorY = 1, 1 
    soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 25


sceneGroup:insert(soundBtn)



end
end
-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      
    display.remove( soundBtn )
    package.loaded["hud"] = nil
    elseif ( phase == "did" ) then
      

    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
  
    
    audio.stop(MusicaRetryChannel)
    audio.dispose( MusicaRetry )
    MusicaRetry = nil 
    display.remove( soundBtn )
    package.loaded["hud"] = nil

end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene