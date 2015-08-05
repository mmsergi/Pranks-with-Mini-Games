local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar )
local ads = require( "ads" )
local AdBuddiz = require "plugin.adbuddiz"
local gameNetwork = require( "gameNetwork" )
local GGPS = require( "GooglePlayServices" )

--Moneda            
local MonedaSheet = graphics.newImageSheet( "Moneda.png", { width=38, height=41, numFrames=13} )    
local MonedaSequence = {
            { name = "inicial", start=1, count=4, time=1600, },
            { name = "comida", start=5, count=4, time=400, },
            { name = "desaparece", start=9, count=5, time=500, }} 

local moregamesSheet = graphics.newImageSheet( "moregames.png", { width=206, height=91, numFrames=2} )    
local moregamesSequence = {
            { name = "inicial", start=1, count=2, time=1500, }}

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
fondo=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
fondo:setFillColor(.961, .706, .227,0.45 )



pauseRect=display.newImage(sceneGroup, "PauseRect1.png",display.contentCenterX,topMarg+170)

 local function handlePlayEvent( event )

        if ( "ended" == event.phase )  then
                         print("play")
                         physics.start()
                         timer.resume( flamaTimer)
                         if removeMonedasTmr then
                         timer.resume( removeMonedasTmr)
                     end
                        --pause:toFront()
                        if pauseFlagFlamas==true then 
                         callplay()
                            end
                         Ice:play()
                         timer.resume(timerMuchoRatoPuerta)
                         flechasFlagPause=true
                         
-- Cambiar las flechas a true!!!! si se quieren reincorporar-------------------------------------------------------------------------------------
                         --flechaR.isVisible=true
                         --flechaL.isVisible=true
                          izq.isHitTestable=true
                         der.isHitTestable=true
                         composer.hideOverlay( "pauseOverlay" )
                         audio.resume(FondoMusicaChannel)

                    end
                    
        end

  local options = {
        width = 206,
        height = 91,
        numFrames = 2,}
 local playSheet = graphics.newImageSheet( "botonResume.png", options )
  play = widget.newButton
    {sheet = playSheet,
     defaultFrame = 1,
     overFrame = 2,
     onEvent = handlePlayEvent}  
   sceneGroup:insert(play)      


play.x= display.contentCenterX
play.y=display.contentCenterY
--play:scale(1,1.4)

local ActualScore = display.newText(sceneGroup,user.actualScore, display.contentCenterX+90, topMarg+122, "telo", 55)
ActualScore:setFillColor(.435, .22, .004)

local HighScore = display.newText(sceneGroup,user.highScore,display.contentCenterX+90, topMarg+175, "telo", 55)
HighScore:setFillColor(.435, .22, .004)





    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
--totalgalletas

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


 --shop 
 local function handleShopEvent( event )

        if ( "ended" == event.phase )  then
     
                   composer.showOverlay( "shop", {isModal=true} )
                   user.scene = "EndlessH" saveValue('user.txt', json.encode(user)) user = json.decode(loadValue('user.txt'))--guardamos datos en json
        end

    end


     local options = {
        width = 48,
        height = 47,
        numFrames = 2,}
    local shopSheet = graphics.newImageSheet( "shopBut.png", options )
    local shopBut = widget.newButton
    {sheet = shopSheet,
     defaultFrame = 1,
     overFrame = 2,
     onEvent = handleShopEvent}     

    sceneGroup:insert(shopBut)
shopBut.x= leftMarg+26
shopBut.y=topMarg+26
shopBut.isVisible=false


--Moregames

moregames=display.newSprite(sceneGroup,moregamesSheet,moregamesSequence)
moregames:play()

moregames.x= rightMarg-80
moregames.y=display.contentCenterY+120
moregames:scale(0.7,0.7)

function moregames:tap()
AdBuddiz.showAd()
end
moregames:addEventListener("tap",moregames)

--Ranking
    local minusButtonPressed = false
        local function handleRankingEvent( event )

            if ( "ended" == event.phase )and (minusButtonPressed == false)  then
                analytics.logEvent( "Ranking" )
             function showLeaderboards( event )--encapsulado para ver ranking
               if ( system.getInfo("platformName") == "Android" ) then
                 
                gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"} } )
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
            height = 130,
            numFrames = 2,
        }
        local RankingSheet = graphics.newImageSheet( "botonRankingCorona.png", options )
        local Ranking = widget.newButton
        {sheet = RankingSheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = handleRankingEvent}
            

    sceneGroup:insert(Ranking)

  Ranking.x = leftMarg+80
    Ranking.y = display.contentCenterY+105
    Ranking:scale(0.7,0.7)        

--Rate
if user.highScore>=50 or user.session>=10 then --se pone un mínimo para poder puntuar la aplicación, así se evita que peña que no le ha molado puntuen mal
    rate=display.newImage( sceneGroup,"Rate.png")
    rate.x = rightMarg-60
    rate.y = bottomMarg-80
    rate:scale(0.6,0.6)
    --rate:play()

            function rate:tap()
            system.openURL("https://play.google.com/store/apps/details?id=com.gmail.jaumesahis.TimeofAdventure")
             end     
    rate:addEventListener("tap",rate)
end
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




audios.x = leftMarg+59
audios.y = bottomMarg-80
m=0.5
audios:scale(m,m)

notassheet=graphics.newImageSheet( "notas.png", {width = 68,height = 67,numFrames = 2, })
local notasdata = {{ name = "normal", start=1, count=2, time=1000,}}
local notas=display.newSprite(sceneGroup,notassheet,notasdata)

notas.x=leftMarg+67
notas.y=bottomMarg-100
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
            audio.setVolume( 1)
            elseif user.musicOn==true then  
                audios:setSequence( "off" )
                audios:play()
                notas.isVisible=false
                user.musicOn=false saveValue('user.txt', json.encode(user)) --vamos sumando hasta que de el numero indicado
                audio.setVolume( 0 )
       end
         end
         
        
audios:addEventListener("tap",audios)

audio.pause(FondoMusicaChannel)
if user.musicOn==true then--si la musica es true pon el boton a funcionar
audios:play()
notas:play()
notas.isVisible=true

elseif user.musicOn==false then
  audio.setVolume( 0 )
  audios:setSequence( "off" )
    audios:play()
end




        --Publi
    ads.show( "banner", { x=0, y=1000, appId="ca-app-pub-1709584335667681/4362211453" } )--cargar anuncio admob


    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      ads.hide()
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