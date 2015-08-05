local composer = require( "composer" )
local scene = composer.newScene()
local ads = require( "ads" )
local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar )
local AdBuddiz = require "plugin.adbuddiz"
local fondo
local titulo
local gameNetwork = require( "gameNetwork" )
local GGPS = require( "GooglePlayServices" )
local analytics = require( "analytics" )

local moregamesSheet = graphics.newImageSheet( "moregames.png", { width=206, height=91, numFrames=2} )    
local moregamesSequence = {
            { name = "inicial", start=1, count=2, time=1500, }}

local fondoSheet = graphics.newImageSheet( "fondo.png", { width=380, height=569, numFrames=2} )    
local fondoSequence = {
            { name = "inicial", start=1, count=2, time=1200, }}




-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view





   CheersAudio= audio.loadSound( "Cheers.ogg")

    
FondoMusica= audio.loadSound( "rithm.ogg")

fondo = display.newSprite(fondoSheet,fondoSequence)

fondo:play()

sceneGroup:insert(fondo)

titulosheet=graphics.newImageSheet( "titulo.png", {
    --required parameters
    width = 289,
    height = 160,
    numFrames = 4, })
local titulodata = {
            { name = "normal", start=1, count=4, time=1400,}}

titulo=display.newSprite(sceneGroup,titulosheet,titulodata)


end --Fin scene:create( event )

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

        if ( phase == "will" ) then
--Moregames

moregames=display.newSprite(sceneGroup,moregamesSheet,moregamesSequence)
moregames:play()

moregames.x= display.contentCenterX
moregames.y=display.contentCenterY+170
moregames:scale(0.7,0.7)

function moregames:tap()
AdBuddiz.showAd()
AdBuddiz.cacheAds() 
analytics.logEvent( "Moregames" )
end
moregames:addEventListener("tap",moregames)

--Rate
if user.highScore>=50 then --se pone un mínimo para poder puntuar la aplicación, así se evita que peña que no le ha molado puntuen mal
    local ratesheet=graphics.newImageSheet( "Rate.png", {
        
        width = 150,
        height = 85,
        numFrames = 2, })
    local ratedata = {
                { name = "normal", start=1, count=2, time=2000,}}

    rate=display.newSprite(sceneGroup,ratesheet,ratedata)
    rate.x = rightMarg-50
    rate.y = bottomMarg-40
    rate:scale(0.6,0.6)
    --rate:play()

            function rate:tap()
            system.openURL("https://play.google.com/store/apps/details?id=com.gmail.jaumesahis.FeedtheMinion")
             end     
    rate:addEventListener("tap",rate)
end






fondo.x=display.contentCenterX
fondo.y=display.contentCenterY

titulo.x=display.contentCenterX
titulo.y=display.screenOriginY+85
local minusButtonPressed = false
local function handleButtonEvent( event )

    if ( "ended" == event.phase )and (minusButtonPressed == false)  then
    audio.play( CheersAudio)
    audio.pause(FondoMusicaChannel2)
    minusButtonPressed = true
 if user.tuto==0 then
      composer.gotoScene( "GetReady", {effect="crossFade", time=800})
       user.tuto = 1 saveValue('user.txt', json.encode(user)) user = json.decode(loadValue('user.txt'))--guardamos datos en json
  else
         composer.gotoScene( "juegoTOA" )
           
   end

end
end
-- Image sheet options and declaration
local options = {
    width = 206,
    height = 91,
    numFrames = 2,
}
local buttonSheet = graphics.newImageSheet( "botonPlay.png", options )

-- Create the widget
local button1 = widget.newButton

{
    sheet = buttonSheet,
    defaultFrame = 1,
    overFrame = 2,
    
    onEvent = handleButtonEvent
}

sceneGroup:insert(button1)


-- Center the button
button1.x = display.contentCenterX
button1.y = display.contentCenterY


--Ranking
    local minusButtonPressed = false
        local function handleRankingEvent( event )

            if ( "ended" == event.phase )and (minusButtonPressed == false)  then
                
             function showLeaderboards( event )--encapsulado para ver ranking
               if ( system.getInfo("platformName") == "Android" ) then
                 
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
    Ranking.y = display.contentCenterY+80
    Ranking:scale(0.7,0.7)






        	  elseif ( phase == "did" ) then  
titulo:play()

audiosheet=graphics.newImageSheet( "audios.png", {
    --required parameters
    width = 132,
    height = 102,
    numFrames = 3, })
local audiodata = {
            { name = "normal", start=1, count=2, time=500,},
            { name = "off", start=3, count=1, time=500,}}

audios=display.newSprite(sceneGroup,audiosheet,audiodata)


        -- When left arrow is touched, move character left
         function audios:tap()
         if user.musicOn==false then
            audios:setSequence( "normal" )
            audios:play()
            notas:play()
            notas.isVisible=true
            user.musicOn=true saveValue('user.txt', json.encode(user)) 
            audio.setVolume(1)
            elseif user.musicOn==true then  
                audios:setSequence( "off" )
                audios:play()
                notas.isVisible=false
                user.musicOn=false saveValue('user.txt', json.encode(user)) 
                audio.setVolume( 0 )
       end
         end
         
        
audios:addEventListener("tap",audios)



audios.x = leftMarg+39
audios.y = bottomMarg-40
m=0.5
audios.xScale=m
audios.yScale=m

notassheet=graphics.newImageSheet( "notas.png", {
    --required parameters
    width = 68,
    height = 67,
    numFrames = 2, })
local notasdata = {
            { name = "normal", start=1, count=2, time=1000,}}

notas=display.newSprite(sceneGroup,notassheet,notasdata)


notas.x=leftMarg+53
notas.y=bottomMarg-60
notas.xScale=m
notas.yScale=m
notas.isVisible=false



FondoMusicaChannel2= audio.play(FondoMusica, {loops=(-1)})
if user.musicOn==true then--si la musica es true pon el boton a funcionar
audios:play()
notas:play()
notas.isVisible=true

elseif user.musicOn==false then
  audio.setVolume( 0 )
  audios:setSequence( "off" )
    audios:play()
end







end
end
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

-- -------------------------------------------------------------------------------
--physics.setDrawMode( "hybrid" )
return scene -- cierra create scene
