--Shortcuts

--              adb install -r C:\Users\Jaume\Dropbox\Apps\FeedtheMinion.apk

--              adb install   C:\Users\Jaume\Dropbox\Apps\FeedtheMinion.apk

--              adb logcat Corona:v *:s

--Posición X,Y en terminal
     local function onTouch(event)
     print("POS.X = " .. event.x, "POS.Y = ".. event.y);
  end
   Runtime:addEventListener("touch",onTouch);







--Requerimientos iniciales
local analytics = require( "analytics" )
local composer = require( "composer" )
local scene = composer.newScene()
local ads = require( "ads" )
local AdBuddiz = require "plugin.adbuddiz"
local gameNetwork = require( "gameNetwork" )
local widget = require( "widget" )



local flamaPosition
local flamaTable={}

json = require('json')

display.setStatusBar( display.HiddenStatusBar )

--Sprites
    local personajeData = { width=35, height=48, numFrames=18,}
    local personajeSheet = graphics.newImageSheet( "minion.png", personajeData )    
    local personajeSequence = {
        { name = "frente", start=1, count=1, time=125,},
        { name = "right", frames={3,5}, time=250},
        { name = "left", frames={10,8}, time=250,},
        { name = "rapidoD", start=3, count=4, time=800,},
        { name = "rapidoI", frames={10,9,8,7}, time=800,},
        { name = "muerto", start=14, count=2, time=250,},
        { name = "comerd", frames={16,12,3,5}, time=800,},
        { name = "comerl", frames={17,13,10,8}, time=800,},
        { name = "comerf", frames={18,1}, time=400,loopCount=1}}


--Flamas

    local flamasData = { width=39, height=49, numFrames=4,}
    local flamasSheet = graphics.newImageSheet( "banana.png", flamasData )
    local flamasSheet2 = graphics.newImageSheet( "banana2.png", flamasData )        
    local flamasSequence = {
        { name = "inicial", start=1, count=1, time=125,},
        { name = "cae",  start=2, count=3, time=600},
        { name = "comer",  start=2, count=1, time=250},}
        
--Coco

    local cocoData = { width=42, height=50, numFrames=4,}
    local cocoSheet = graphics.newImageSheet( "coco.png", cocoData )    
    local cocoSequence = {
        { name = "inicial", start=1, count=1, time=125,},
        { name = "cae",  start=2, count=3, time=250},
        { name = "comer",  start=2, count=1, time=250},}
--Icono

    local iconoData = { width=40, height=48, numFrames=2,}
    local iconoSheet = graphics.newImageSheet( "cartelIcono.png", iconoData )    
    local iconoSequence = {
        { name = "coco", start=1, count=1, time=125,},
        { name = "platano",  start=2, count=3, time=250},}
        








local scene = composer.newScene()

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
physics.start( )
physics.setGravity( 0, 7 )  

--Sonidos        
FondoMusica2= audio.loadSound( "Theme8.ogg")

Fail= audio.loadSound( "GameFail.ogg")
Bite= audio.loadSound( "basket.ogg")
fondo = display.newImage(sceneGroup,"endless1.png",display.contentCenterX,display.contentCenterY)
logro= audio.loadSound( "Cheers.ogg")

highScoreFlag=false
Dificultad=700
if user.session==0 then
 randomFlama=10
elseif user.session==1 then
randomFlama=25
else
    randomFlama=math.random( 200 )
end
 capaFlag=true
platanoFlag=false  
nomasplatano=false

actualScore=display.newText(sceneGroup, user.actualScore,display.contentCenterX+5,display.contentCenterY+105,"telo",36)
actualScore:setFillColor(.424, .20, .008)

user.actualScore = 0 saveValue('user.txt', json.encode(user)) user = json.decode(loadValue('user.txt'))--guardamos datos en json
                     actualScore.text = user.actualScore   


pared = {}
        for i = 1, 2, 1 do
        pared[i]=display.newRect(-45,display.contentHeight/2,100,display.contentHeight)
        pared[i].isVisible=false
        pared[i].name="pared" 
        sceneGroup:insert(pared[i])
        physics.addBody( pared[i], "static", {density=100, friction=1, bounce=0 ,filter={ categoryBits=1, maskBits=2 }, } )
        end
        pared[1].x=rightMarg+45
--Suelo
suelo=display.newRect(display.contentCenterX,display.contentCenterY+270,display.contentWidth,100)
suelo.name="suelo"
physics.addBody( suelo, "static", {density=100, friction=1, bounce=0 ,filter={ categoryBits=8, maskBits=150 }, } )
suelo.isVisible=false
    



personaje = display.newSprite( personajeSheet, personajeSequence )
personaje.name="personaje"
sceneGroup:insert(personaje)
personajeScale=2.2
personaje.xScale=personajeScale
personaje.yScale=personajeScale
physics.addBody( personaje, "dynamic", { density=1,friction=1, bounce=0,
    shape={-17,-30, 17,-30,  17,40, -17,40, -17,12, -17,-4}, filter={ categoryBits=2, maskBits=253 }})
--Personaje
personaje.x=display.contentCenterX-127
personaje.y=display.contentCenterY+180

izq=display.newRect(display.contentWidth/4,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(izq)
izq.isVisible=false
izq.isHitTestable=true

der=display.newRect(display.contentWidth/4*3,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(der)
der.isVisible=false
der.isHitTestable=true

motionx = 0
speed = 7 
  -- When left arrow is touched, move character left
         function izq:touch()
         motionx = -speed;
         personaje:setSequence("rapidoI")
         personaje:play()
      
         end
         
        -- When right arrow is touched, move character right
         function der:touch()
         motionx = speed;
         personaje:setSequence("rapidoD")
         personaje:play()

         end
         
    izq:addEventListener("touch",izq)
    der:addEventListener("touch",der)
             
function moverPersonaje (event)
    personaje.x = personaje.x + motionx

end
Runtime:addEventListener("enterFrame", moverPersonaje)


function stopPersonaje(event)
 if event.phase =="ended" then
       personaje:setSequence("frente")
         personaje:play()
         motionx=0
     end
 end
Runtime:addEventListener("touch", stopPersonaje)













end
-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
   local failFlag=true
FondoMusicaChannel= audio.play(FondoMusica2, {loops=(-1)})




local function spawnFlama(params)



if randomFlama>=Dificultad then 
    flamas=display.newSprite( cocoSheet,cocoSequence  )

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                radius=24,filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="coco"

            randomFlama=math.random( 1000 )
    elseif randomFlama<=15 then 
    flamas=display.newImage("capa.png")

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                radius=24,filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="capa"

            randomFlama=math.random( 1000 )
elseif randomFlama>15 and randomFlama<=40 then 
    flamas=display.newSprite( flamasSheet2,flamasSequence)

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                radius=24,filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="platano2"

            randomFlama=math.random( 1000 )
    else

flamas=display.newSprite( flamasSheet,flamasSequence  )

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                shape={0,-29, -13,0, -13,1, 0,1, 13,1, 13,0, 0,20},filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="platano"

           randomFlama=math.random( 1000 )
end

    flamas.objTable = params.objTable

    flamas.index = #flamas.objTable + 1

    flamas.myName = "Flama:" .. flamas.index

    flamas.group = params.group or nil

    flamas.group:insert(flamas)

    flamas.objTable[flamas.index] = flamas
   
    flamas.x=math.random( 9 )*(display.actualContentWidth-150)/5
    flamas.y=topMarg+100
    
    flamaScale=1
    flamas:scale(flamaScale,flamaScale)
  
            
            
           
            

     local function onCollision(self, event )
                if (event.other.name) == "suelo"  then
                        if event.target.name== "platano" or event.target.name== "coco" or event.target.name== "platano2"then
                            event.target:setSequence("cae")
                            event.target:play()
                        end
                
                    timer.performWithDelay(10, function () table.remove(event.target); display.remove(event.target);event.target=nil end)

                   elseif (event.other.name) == "personaje" and event.target.name=="platano" and failFlag==true then
                    audio.play(Bite)
                                    if platanoFlag==true then
                                        user.actualScore = user.actualScore+2 saveValue('user.txt', json.encode(user)) user = json.decode(loadValue('user.txt'))--guardamos datos en json
                                 actualScore.text = user.actualScore
                                 event.target:setSequence("comer")
                                event.target:play()
                                    Dificultad=Dificultad-2
                                    print("Dificultad = "..Dificultad)
                                timer.performWithDelay(100, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                                 Unpuntos=display.newImageRect("+2.png",51,26)
                                Unpuntos.x=personaje.x
                                Unpuntos.y=personaje.y-60
                                Unpuntos:scale(1.5,1.5)
                                    transition.to( Unpuntos, { time=1500, alpha=0, x=personaje.x, y=personaje.y-90,onComplete= function() display.remove( Unpuntos )end } )
                                    sceneGroup:insert(Unpuntos)
                                else
                                user.actualScore = user.actualScore+1 saveValue('user.txt', json.encode(user)) user = json.decode(loadValue('user.txt'))--guardamos datos en json
                                 actualScore.text = user.actualScore
                                 event.target:setSequence("comer")
                                event.target:play()
                                    Dificultad=Dificultad-1
                                    print("Dificultad = "..Dificultad)
                                timer.performWithDelay(100, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                                 Unpuntos=display.newImageRect("+1.png",51,26)
                                Unpuntos.x=personaje.x
                                Unpuntos.y=personaje.y-60
                                Unpuntos:scale(1.5,1.5)
                                    transition.to( Unpuntos, { time=1500, alpha=0, x=personaje.x, y=personaje.y-90,onComplete= function() display.remove( Unpuntos )end } )
                                    sceneGroup:insert(Unpuntos)
                                end
                    if motionx>0 then
                    personaje:setSequence( "comerd" )
                    personaje:play()
             

                    elseif motionx<0 then
                        personaje:setSequence( "comerl" )
                        personaje:play()
                        elseif motionx==0 then
                        personaje:setSequence( "comerf" )
                        personaje:play()
                
                    end
                    elseif (event.other.name) == "personaje" and event.target.name=="platano2" and failFlag==true then
                        
                        tmr03=timer.performWithDelay(10, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                        if nomasplatano==false then
                          platanoFlag=true  
                          nomasplatano=true

                          por2=display.newImage( sceneGroup,"x2.png",cx,topMarg+50 )
                          por2:scale(0.9,0.9)

                    audio.play( logro)
                    tmr03=timer.performWithDelay(5000, function () transition.blink( por2, { time=1000 } )end)
                    tmr04=timer.performWithDelay(7000, function () timer.cancel( tmr03 ) timer.cancel( tmr04 ) display.remove( por2 )
                        platanoFlag=false nomasplatano=false end)
                end




elseif (event.other.name) == "personaje" and event.target.name=="coco" and capaFlag==false then

                            timer.performWithDelay(10, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                
                elseif (event.other.name) == "personaje" and event.target.name=="capa" and failFlag==true then
                    if capaFlag==true then
                    capa2=display.newImage( sceneGroup,"capa2.png", personaje.x, personaje.y )
                    capa2:scale(2.2,2.2)
                    capaFlag=false
                    audio.play( logro)
                    end
                    timer.performWithDelay(10, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                    function movercapa()
                        capa2.x=personaje.x
                        capa2.y=personaje.y
                    end
                    Runtime:addEventListener( "enterFrame", movercapa )
                    tmr01=timer.performWithDelay(5000, function() transition.blink( capa2, { time=1000 } )end)
                    tmr02=timer.performWithDelay(7000, function () table.remove(capa2); display.remove(capa2);event.target=nil 
                        Runtime:removeEventListener( "enterFrame", movercapa ) capaFlag=true timer.cancel(tmr01) timer.cancel(tmr02)end)
                    end
                    end
                    flamas.collision = onCollision
                    flamas:addEventListener("collision", flamas)

                    


    return flamas

    end
local function spawnFlamaT()



for i = 1, 1 do
local spawns = spawnFlama(
{
objTable = flamaTable,
group = flamasGroup,
}
)
end
end 

flamaTimer=timer.performWithDelay( 150, spawnFlamaT,0 )

cartelIcono=display.newSprite( sceneGroup,iconoSheet,iconoSequence )
cartelIcono:setSequence( "platano" )
cartelIcono.x=display.contentCenterX+5
cartelIcono.y=display.contentCenterY+48
cartelIcono:scale(0.8,0.8)

flamasGroup=display.newGroup( )
sceneGroup:insert(flamasGroup)
    palmeraI=display.newImage( sceneGroup, "palmeraI.png", leftMarg+48,topMarg+62 )  
      palmeraM=display.newImage( sceneGroup, "palmeraM.png", display.contentCenterX-5,topMarg+62 )
      palmeraD=display.newImage( sceneGroup, "palmeraD.png", rightMarg-40,topMarg+65 )     
      



local function onCollision2(self, event )
                if (event.other.name) == "coco" and capaFlag==true then

                    
                    izq:removeEventListener("touch",izq)
                    der:removeEventListener("touch",der)
                    Runtime:removeEventListener("enterFrame", moverPersonaje)
                    Runtime:removeEventListener("touch", stopPersonaje)
                    
                    audio.stop(FondoMusicaChannel)

                    if failFlag then
                    audio.play(Fail)
                    failFlag=false
                    print("locoo")
                end
                    --acciones personaje
                    timer.performWithDelay(250,function() personaje:setSequence( "muerto" );
                    personaje:play(); physics.removeBody( personaje );    end)
                    transition.to(personaje,{time=250,y=personaje.y-50,delay=250})
                    transition.to(personaje,{time=2500,y=(personaje.y+500), delay=500})
                    timer.performWithDelay( 1500, function () personaje.isVisible=false end)
                    print("Muerto")
                    if por2 then
                        display.remove(por2)
                    end
                    personaje:toFront( )
                  function guardaPuntos()
--Guardar puntuación
if user.actualScore>user.highScore then
    user.highScore=user.actualScore
    highScoreFlag=true
    user.session=user.session+1
-- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
end
end
guardaPuntos()

                    timer.performWithDelay( 1500, function () composer.showOverlay( "Retry" )end)
                     timer.performWithDelay( 500, function () timer.cancel( flamaTimer ) end )
                    
                       
end
end
                    personaje.collision = onCollision2
                    personaje:addEventListener("collision", personaje)


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
display.remove( personaje )
display.remove( flamas )
timer.cancel( flamaTimer )
if tmr04 then
timer.cancel(tmr04)
end
if tmr03 then
timer.cancel(tmr03)
end
if tmr02 then
timer.cancel(tmr02)
end
if tmr01 then
timer.cancel(tmr01)
end    
end
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------
--physics.setDrawMode( "hybrid" )
return scene