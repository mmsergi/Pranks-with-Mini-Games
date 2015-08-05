local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar )
local ads = require( "ads" )
local AdBuddiz = require "plugin.adbuddiz"
local gameNetwork = require( "gameNetwork" )
local GGPS = require( "GooglePlayServices" )
local analytics = require( "analytics" )
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
--local GA = require ( "plugin.gameanalytics" )
-- local forward references should go here
local background
local Gameover
local notas

--Moneda            
local MonedaSheet = graphics.newImageSheet( "Moneda.png", { width=38, height=41, numFrames=13} )    
local MonedaSequence = {
            { name = "inicial", start=1, count=4, time=1600, },
            { name = "comida", start=5, count=4, time=400, },
            { name = "desaparece", start=9, count=5, time=500, }} 

local moregamesSheet = graphics.newImageSheet( "moregames.png", { width=206, height=91, numFrames=2} )    
local moregamesSequence = {
            { name = "inicial", start=1, count=2, time=1500, }}



 

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view


--function showInter()
 --if math.random(100)<=25 then

--ads.show( "interstitial", { appId="ca-app-pub-3836849703819703/1598130878" } )

 --end
--end





 fondo = display.newImage(sceneGroup,"Overlay1.png")
   fondo.x=display.contentCenterX
fondo.y=display.contentCenterY
if highScoreFlag  then --si la flag situada en guardaPuntos() de Endless.lua esta activada ponemos new highscore
     new=display.newImage( sceneGroup,"NewHighscore.png", display.contentCenterX+44, display.contentCenterY-93 )
        new:rotate(-35)

        print("highscore")
end
   
--    fondoRetry=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
--    fondoRetry:setFillColor( 0.533, 0.933, 0.996 )

--  retryStarburst=display.newImage( sceneGroup, "retryStarburst.png", display.contentCenterX,topMarg+150) 
--  retryStarburst:scale(1.5,1.5)
--  retryStarburst.rotation = -45
--  local reverse = 1

--  local function retryStarburstRot()
--    if ( reverse == 0 ) then
--        reverse = 1
--        transition.to( retryStarburst, { rotation=-90, time=1000, transition=easing.inOutCubic } )
--      else
--          reverse = 0
--          transition.to( retryStarburst, { rotation=90, time=1000, transition=easing.inOutCubic } )
--     end
-- end
--    timer.performWithDelay( 600, retryStarburstRot, 1 )
--    timer.performWithDelay( 1700, retryStarburstRot, 1 )

--    fondoRetryInferior=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY+display.actualContentHeight/4, display.actualContentWidth, display.actualContentHeight/2 )
--    fondoRetryInferior:setFillColor( 0.533, 0.933, 0.996 )


--highscoreImage=display.newImage( sceneGroup, "highScore.png", display.contentCenterX,topMarg+60) 
--Retry

    minusButtonPressed = false
    

--Ranking
    local minusButtonPressed = false
        local function handleRankingEvent( event )

            if ( "ended" == event.phase )and (minusButtonPressed == false)  then
                
             function showLeaderboards( event )--encapsulado para ver ranking
               if ( system.getInfo("platformName") == "Android" ) then
                 gameNetwork.request( "loadScores",
    {
        leaderboard =
        {
            
            playerScope = "Global",   -- Global, FriendsOnly
            timeScope = "Week",    -- AllTime, Week, Today
            range = { 1,5 },
            playerCentered = true
        },
        --listener = requestCallback
    }
)
                gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime",playerScope = "Global",range = { 1,25 },playerCentered = true} } )
               end
               return true
            end
            

    print("Ranking")

if gameNetwork.request("isConnected")==false then 
  print("----------------------------User needs to log in-------------------------------")
        if ( system.getInfo("platformName") == "Android" ) then
            gpgsInitCallback( event )
            
        end
    
else 
    showLeaderboards( event )
end

                   --minusButtonPressed = true
            end

        end
        local options = {
            width = 206,
            height = 92,
            numFrames = 2,
        }
        local RankingSheet = graphics.newImageSheet( "botonRankingCorona.png", options )
        local Ranking = widget.newButton
        {sheet = RankingSheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = handleRankingEvent}
            

    sceneGroup:insert(Ranking)
   

 Ranking.x = display.contentCenterX    
 Ranking.y = bottomMarg-65
    Ranking.xScale=0.7
    Ranking.yScale=0.7  

  
  
--Moregames

moregames=display.newSprite(sceneGroup,moregamesSheet,moregamesSequence)
moregames:play()

moregames.x= display.contentCenterX
moregames.y=display.contentCenterY+100
moregames:scale(0.8,0.8)

function moregames:tap()
AdBuddiz.showAd()
AdBuddiz.cacheAds() 
analytics.logEvent( "Moregames" )
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



end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

if ( phase == "will" ) then 



   --Publi
--    ads.show( "banner", { x=0, y=1000, appId="ca-app-pub-3836849703819703/4625128472" } )--cargar anuncio admob

--    retryNube=display.newImage(sceneGroup,"retryNube.png", display.contentCenterX, bottomMarg-33)

--    retryNubeI=display.newImage(sceneGroup,"retryNube.png", leftMarg-40, display.contentCenterY-15)
--    retryNubeI:scale(1.05,1.2)

--    retryNubeD=display.newImage(sceneGroup,"retryNube.png", rightMarg+40, display.contentCenterY-15)
--    retryNubeD:scale(1.05,1.2)

local ActualScore = display.newText(sceneGroup,user.actualScore, display.contentCenterX-79, display.contentCenterY-30, "telo", 36)
ActualScore:setFillColor(.365, .247, .051)

--    local actualgalletas = display.newEmbossedText(sceneGroup,"+"..user.actualgalletas, leftMarg+38, display.contentCenterY, "telo", 36)
--    actualgalletas:setFillColor(.424, .20, .008)

local HighScore = display.newEmbossedText(sceneGroup,user.highScore,display.contentCenterX+79, display.contentCenterY-30, "telo", 36)
 HighScore:setFillColor(.365, .247, .051)

--    local best=display.newImage(sceneGroup,"best.png", rightMarg-42, display.contentCenterY-35)
--    best:scale(0.61,0.61)

--    local cookies=display.newImage(sceneGroup,"cookies.png", leftMarg+57, display.contentCenterY-35)
--    cookies:scale(0.6,0.6)

--    function reducirnube()
--    transition.scaleTo( retryNubeI, { xScale=0.95, yScale=0.95, time=2000 } )
--    transition.moveTo( retryNubeI, {x=leftMarg-35,time=2000} )

--    transition.moveTo( HighScore, {x=rightMarg-40, time=2000} )
--    transition.moveTo( best, {x=rightMarg-37,time=2000} )

--    transition.moveTo( actualgalletas, {x=leftMarg+43, time=2000} )
--    transition.moveTo( cookies, {x=leftMarg+62, time=2000} )

--    transition.scaleTo( retryNubeD, { xScale=0.95, yScale=0.95, time=2000 } )
--    transition.moveTo( retryNubeD, {x=rightMarg+45,time=2000} )

--    Nubetimer1=timer.performWithDelay( 2000, aumentarnube)
--    end
--    function aumentarnube()

--    transition.scaleTo( retryNubeI, { xScale=1, yScale=1, time=2000 } )
--    transition.moveTo( retryNubeI, {x=leftMarg-45, time=2000} )

--    transition.moveTo( HighScore, {x=rightMarg-50, time=2000} )
--    transition.moveTo( best, {x=rightMarg-47, time=2000} )

--    transition.moveTo( actualgalletas, {x=leftMarg+33, time=2000} )
--    transition.moveTo( cookies, {x=leftMarg+52, time=2000} )

--    transition.scaleTo( retryNubeD, { xScale=1, yScale=1, time=2000 } )
--    transition.moveTo( retryNubeD, {x=rightMarg+35, time=2000} )

--    Nubetimer2=timer.performWithDelay( 2000, reducirnube)
--    end
--    reducirnube()

--Rate
if user.highScore>=70 or user.session>=10 then --se pone un mínimo para poder puntuar la aplicación, así se evita que peña que no le ha molado puntuen mal
    local ratesheet=graphics.newImageSheet( "Rate.png", {
        
        width = 150,
        height = 85,
        numFrames = 2, })
    local ratedata = {
                { name = "normal", start=1, count=2, time=2000,}}

    rate=display.newSprite(sceneGroup,ratesheet,ratedata)
    rate.x = rightMarg-40
    rate.y = bottomMarg-40
    rate:scale(0.5,0.5)
    --rate:play()

            function rate:tap()
            system.openURL("https://play.google.com/store/apps/details?id=com.gmail.jaumesahis.FeedtheMinion")
             end     
    rate:addEventListener("tap",rate)
end


--poner highscore en leaderboard
local function postScoreSubmit( event )
 print("HighScore publicado")
  return true
end

if ( system.getInfo( "platformName" ) == "Android" ) then
   --for GPGS, reset "myCategory" to the string provided from the leaderboard setup in Google
   myCategory = "CgkIpLfCjJcIEAIQBg"
end

gameNetwork.request( "setHighScore",{localPlayerScore = { category=myCategory, value=user.actualScore },listener = postScoreSubmit} )
--audio
    audiosheet=graphics.newImageSheet( "audios.png", {
    --required parameters
    width = 132,
    height = 102,
    numFrames = 3, })
local audiodata = {
             { name = "normal", start=1, count=2, time=500,},
            { name = "off", start=3, count=1, time=500,}}


audios=display.newSprite(sceneGroup,audiosheet,audiodata)




audios.x = leftMarg+39
audios.y = bottomMarg-40
m=0.5
audios:scale(m,m)

notassheet=graphics.newImageSheet( "notas.png", {width = 68,height = 67,numFrames = 2, })
local notasdata = {{ name = "normal", start=1, count=2, time=1000,}}
local notas=display.newSprite(sceneGroup,notassheet,notasdata)

notas.x=leftMarg+53
notas.y=bottomMarg-60
notas:scale(m,m)
notas.isVisible=false
        -- When left arrow is touched, move character left
         function audios:tap()
         if user.musicOn==false then
            audios:setSequence( "normal" )
            audios:play()
            notas:play()
            notas.isVisible=true
            user.musicOn=true saveValue('user.txt', json.encode(user)) --vamos sumando hasta que de el numero indicado
            audio.setVolume( 1 )
            elseif user.musicOn==true then  
                audios:setSequence( "off" )
                audios:play()
                notas.isVisible=false
                user.musicOn=false saveValue('user.txt', json.encode(user)) --vamos sumando hasta que de el numero indicado
                audio.setVolume( 0 )
       end
         end
         
        
audios:addEventListener("tap",audios)


if user.musicOn==true then--si la musica es true pon el boton a funcionar
audios:play()
notas:play()
notas.isVisible=true

elseif user.musicOn==false then
  audio.setVolume( 0 )
  audios:setSequence( "off" )
    audios:play()
end



    local function handleRetryEvent( event )

        if ( "ended" == event.phase )and (minusButtonPressed == false)  then
                    
                    composer.removeScene("juegoTOA",true)
                    
                    audio.pause(FondoMusicaChannel2)
                   audio.rewind(FondoMusicaChannel)
                   -- composer.removeScene("Retry")
                    local options = {
                        
                        time = 800,}
                        composer.hideOverlay( "Retry" )
                        composer.gotoScene( "juegoTOA",options)
                       -- ads.hide("banner")
                        
                    
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
    local RetrySheet = graphics.newImageSheet( "botonRetry.png", options )

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
    Retry.y = display.contentCenterY+15
Retry:scale(1,1)     

Retry:setEnabled( false )





     elseif ( phase == "did" ) then  
Retry:setEnabled( true )
audio.rewind( FondoMusicaChannel2 )
audio.resume(FondoMusicaChannel2)
 --Publicidad

function showInter()
    randomAd=math.random(100)
    print("aaaaaad")
    if randomAd>=70 then

        ads.show( "interstitial", { appId="ca-app-pub-3836849703819703/6898086877" } )
    end
end
showInter()  
 

-- if user.session=1 then
--        RankSes1=display.newImage( sceneGroup, "RankSes1.png",display.contentCenterX+25,display.contentCenterY+140 )
           
--    end


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

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene