--Shortcuts

--              adb install -r C:\Users\Jaume\Dropbox\Apps\FeedtheMinion.apk

--              adb install   C:\Users\Jaume\Dropbox\Apps\FeedtheMinion.apk

--              adb logcat Corona:v *:s


local scene = composer.newScene()
local t = loadTable( "settings.json" )

local flamaPosition
local flamaTable={}
local initialCoins=t.coins
local por2
--Sprites
    local personajeData = { width=35, height=48, numFrames=18,}
    local personajeSheet = graphics.newImageSheet( "assets3/minion.png", personajeData )    
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
    local flamasSheet = graphics.newImageSheet( "assets3/banana.png", flamasData )
    local flamasSheet2 = graphics.newImageSheet( "assets3/banana2.png", flamasData )        
    local flamasSequence = {
        { name = "inicial", start=1, count=1, time=125,},
        { name = "cae",  start=2, count=3, time=600},
        { name = "comer",  start=2, count=1, time=250},}
        
--Coco

    local cocoData = { width=42, height=50, numFrames=4,}
    local cocoSheet = graphics.newImageSheet( "assets3/coco.png", cocoData )    
    local cocoSequence = {
        { name = "inicial", start=1, count=1, time=125,},
        { name = "cae",  start=2, count=3, time=250},
        { name = "comer",  start=2, count=1, time=250},}

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
physics.start( )
physics.setGravity( 0, 7 )  

--Sonidos        
FondoMusica2= audio.loadSound( "assets3/theme.ogg")
coin= audio.loadSound( "assets/coin.ogg")
coin= audio.loadSound( "assets/coin.ogg")
Fail= audio.loadSound( "assets4/GameFail.ogg")
Bite= audio.loadSound( "assets4/Bite.ogg")
fondo = display.newImage(sceneGroup,"assets3/endless1.png",display.contentCenterX,display.contentCenterY)
logro= audio.loadSound( "assets4/Cheers.ogg")



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

actualScore=display.newText(sceneGroup, user.actualScore,display.contentCenterX+5,display.contentCenterY+150,"telo",50)
actualScore:setFillColor(.424, .20, .008)

user.actualScore = 0 saveValue('user.txt', json.encode(user)) user = json.decode(loadValue('user.txt'))--guardamos datos en json
                     actualScore.text = user.actualScore   


pared = {}
        for i = 1, 2, 1 do
        pared[i]=display.newRect(-30,display.contentHeight/2,100,display.contentHeight)
        pared[i].isVisible=false
        pared[i].name="pared" 
        sceneGroup:insert(pared[i])
        physics.addBody( pared[i], "static", {density=100, friction=1, bounce=0 ,filter={ categoryBits=1, maskBits=2 }, } )
        end
        pared[1].x=rightMarg+35

--Suelo
suelo=display.newRect(display.contentCenterX,display.contentCenterY+370,display.contentWidth,100)
suelo.name="suelo"
physics.addBody( suelo, "static", {density=100, friction=1, bounce=0 ,filter={ categoryBits=8, maskBits=150 }, } )
suelo.isVisible=false
    



personaje = display.newSprite( personajeSheet, personajeSequence )
personaje.name="personaje"
sceneGroup:insert(personaje)
personajeScale=3
personaje.xScale=personajeScale
personaje.yScale=personajeScale
physics.addBody( personaje, "dynamic", { density=1,friction=1, bounce=0,
    shape={-24,-41, 24,-41,  24,55, -24,55, -24,17, -24,-6}, filter={ categoryBits=2, maskBits=253 }})
--Personaje
personaje.x=display.contentCenterX-127
personaje.y=display.contentCenterY+265

izq=display.newRect(display.contentWidth/4,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(izq)
izq.isVisible=false
izq.isHitTestable=true

der=display.newRect(display.contentWidth/4*3,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(der)
der.isVisible=false
der.isHitTestable=true

motionx = 0
speed = 10 
  -- When left arrow is touched, move character left
         function izq:touch()
         motionx = -speed;
         personaje:setSequence("rapidoI")
         personaje:play()
        display.remove( flechaTutoR )
        display.remove( flechaTutoL )
         end
         
        -- When right arrow is touched, move character right
         function der:touch()
         motionx = speed;
         personaje:setSequence("rapidoD")
         personaje:play()
        display.remove( flechaTutoR )
        display.remove( flechaTutoL )
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

por2=display.newImage( sceneGroup,"assets3/x2.png",cx+7,cy+70 )
por2.alpha=0


local function spawnFlama(params)
if Dificultad<=500 then
    Dificultad=500
end

if por2Flag then
    print("entra")
                        por2Flag=false
                        por2.alpha=1 
                    audio.play( logro)
                    tmr03=timer.performWithDelay(5000, function () transBlink=transition.blink( por2, { time=1000 } )end)
                    tmr04=timer.performWithDelay(7000, function () timer.cancel( tmr03 )  por2.alpha=0
                        transition.cancel( transBlink ) print("finito") platanoFlag=false nomasplatano=false timer.cancel( tmr04 ) end)
                     
                    flamas:toFront( )
end

if randomFlama>= Dificultad then 
    flamas=display.newSprite( cocoSheet,cocoSequence  )

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                radius=24,filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="coco"
            flamas:scale(1,1)

            randomFlama=math.random( 1000 )
    elseif randomFlama<=15 then 
    flamas=display.newImage("assets3/capa.png")

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                radius=24,filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="capa"
            flamas:scale(1,1)

            randomFlama=math.random( 1000 )
elseif randomFlama>15 and randomFlama<=40 then 
    flamas=display.newSprite( flamasSheet2,flamasSequence)

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                radius=24,filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="platano2"
            flamas:scale(1,1)

            randomFlama=math.random( 1000 )
elseif randomFlama>40 and randomFlama<=60 then
    flamas = display.newSprite( coinsSheet, coinsSequence )
    flamas:setSequence( "estatica" )
    physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                radius=24,filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="coin"
            flamas:scale(0.8,0.8)
            randomFlama=math.random( 1000 )
    else

flamas=display.newSprite( flamasSheet,flamasSequence  )

            physics.addBody( flamas, { density=0, friction=6, bounce=0, 
                shape={0,-29, -13,0, -13,1, 0,1, 13,1, 13,0, 0,20},filter={ categoryBits=4, maskBits=10 }} )
            flamas.name="platano"
            flamas:scale(1,1)
           randomFlama=math.random( 1000 )
end

    flamas.objTable = params.objTable

    flamas.index = #flamas.objTable + 1

    flamas.myName = "Flama:" .. flamas.index

    flamas.group = params.group or nil

    flamas.group:insert(flamas)

    flamas.objTable[flamas.index] = flamas
   
    flamas.x=math.random( 7 )*61
    flamas.y=topMarg+100
    
    flamaScale=1.38
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
                                 Unpuntos=display.newImageRect("assets3/+2.png",51,26)
                                Unpuntos.x=personaje.x
                                Unpuntos.y=personaje.y-60
                                Unpuntos:scale(2,2)
                                  display.remove( flechaTutoR )

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
                                 Unpuntos=display.newImageRect("assets3/+1.png",51,26)
                                Unpuntos.x=personaje.x
                                Unpuntos.y=personaje.y-60
                                Unpuntos:scale(2,2)
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
                          por2Flag=true
                        end

                

elseif (event.other.name) == "personaje" and event.target.name=="coin" and failFlag==true then
                        tmr03=timer.performWithDelay(10, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                        audio.play( coin)
                        print("moneda")
                        t.coins=t.coins+50
                        saveTable(t, "settings.json")
                        cointext.text=t.coins-initialCoins



elseif (event.other.name) == "personaje" and event.target.name=="coco" and capaFlag==false then

                            timer.performWithDelay(10, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                
                elseif (event.other.name) == "personaje" and event.target.name=="capa" and failFlag==true then
                    if capaFlag==true then
                    capa2=display.newImage( sceneGroup,"assets3/capa2.png", personaje.x, personaje.y )
                    capa2:scale(3,3)
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



flamasGroup=display.newGroup( )
sceneGroup:insert(flamasGroup)
    palmeraI=display.newImage( sceneGroup, "assets3/palmeraI.png", leftMarg+48,topMarg+62 )  
      palmeraM=display.newImage( sceneGroup, "assets3/palmeraM.png", display.contentCenterX-5,topMarg+62 )
      palmeraD=display.newImage( sceneGroup, "assets3/palmeraD.png", rightMarg-40,topMarg+65 )     
      
        palmeraI:scale(1.38,1.38)
        palmeraM:scale(1.38,1.38)
        palmeraD:scale(1.38,1.38)
    cointext = display.newText(sceneGroup, "0", 0, 0, "telo", 40)
    cointext:setFillColor( 1 )
    cointext.x, cointext.y=rightMarg-100,bottomMarg-50

    coinHud = display.newSprite( coinsSheet, coinsSequence )
    coinHud:scale(0.8,0.8)
    sceneGroup:insert(coinHud)
    coinHud.x, coinHud.y = rightMarg-50,bottomMarg-50

local function onCollision2(self, event )
                if (event.other.name) == "coco" and capaFlag==true and failFlag==true then





                    
                    izq:removeEventListener("touch",izq)
                    der:removeEventListener("touch",der)
                    Runtime:removeEventListener("enterFrame", moverPersonaje)
                    Runtime:removeEventListener("touch", stopPersonaje)
                    
                    audio.stop(FondoMusicaChannel)

                    
                    audio.play(Fail)
                    failFlag=false
                     audio.stop(Fail)
                    audio.dispose( Fail )
                    Fail = nil 
                
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
                    display.remove(cointext)
                    display.remove( (coinHud) )
                    personaje:toFront( )
                  function guardaPuntos()
--Guardar puntuación
if user.actualScore>user.highScoreMinion then
    user.highScoreMinion=user.actualScore
    highScoreFlag=true
    user.session=user.session+1
-- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
end
end
guardaPuntos()

                    timer.performWithDelay( 1500, function () composer.gotoScene( "Retry_Minion" )end)
                     timer.performWithDelay( 500, function () timer.cancel( flamaTimer ) end )
                    
                       
end
end
                    personaje.collision = onCollision2
                    personaje:addEventListener("collision", personaje)


    elseif ( phase == "did" ) then
    
flechaTutoR = display.newImage( sceneGroup, "assets4/tap_R.png", rightMarg-150,cy+100)
    flechaTutoL = display.newImage( sceneGroup, "assets4/tap_L.png", leftMarg+150,cy+100)

        function moverFlechasTuto()
            transition.moveTo( flechaTutoR, {x=rightMarg-120,time=300} )
            transition.moveTo( flechaTutoL, {x=leftMarg+120,time=300} )
            
            flechasTutoTmr1=timer.performWithDelay( 300, moverFlechasTuto2)
        end
        function moverFlechasTuto2()
            transition.moveTo( flechaTutoR, {x=rightMarg-150,time=300} )
            transition.moveTo( flechaTutoL, {x=leftMarg+150,time=300} )
            flechasTutoTmr2=timer.performWithDelay( 300, moverFlechasTuto)
        end
    moverFlechasTuto()






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
       display.remove( flechaTutoL )
        display.remove( fondo )
display.remove( actualScore )
display.remove( pared )
display.remove( suelo )
display.remove( personaje )
display.remove( izq )
display.remove( der )
display.remove( por2 )
display.remove( flamas )
display.remove( Unpuntos )
display.remove( capa2 )
display.remove( palmeraI )
display.remove( palmeraD )
display.remove( palmeraM )
display.remove( coinHud )
display.remove( cointext )
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
timer.cancel( flechasTutoTmr1 )
timer.cancel( flechasTutoTmr2 )   
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