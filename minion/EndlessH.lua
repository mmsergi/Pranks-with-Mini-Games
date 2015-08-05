--Shortcuts

--              adb install -r C:\Users\Jaume\Dropbox\Apps\TimeofAdventure.apk

--             	adb install   C:\Users\Jaume\Dropbox\Apps\TimeofAdventure.apk

--              adb logcat Corona:v *:s

--Posición X,Y en terminal
     local function onTouch(event)
     print("POS.X = " .. event.x, "POS.Y = ".. event.y);
  end
   Runtime:addEventListener("touch",onTouch);







--Requerimientos iniciales

local composer = require( "composer" )
local scene = composer.newScene()
local ads = require( "ads" )
local AdBuddiz = require "plugin.adbuddiz"
local gameNetwork = require( "gameNetwork" )
local widget = require( "widget" )

json = require('json')

display.setStatusBar( display.HiddenStatusBar )
local flamaSequence
local flamaTable = {}
local MonedaTable = {}
local basketTable={}
local teleport={}
local vidas
local galletas
local Mon
local basketP
local muchoRatoPuerta
local muchoRatoPuertaSolo1flama
local inicioFlag
local spawnBasketT
local extraIpad
local pressed
local flamaDif
local margenDif
local nextLevel
local pause
local play
local flama2Intervalo
callpauseFlag=true
flechasFlagPause=false
removeMonedasTmrVivo=false
--Sprites
	--Minion
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

--Personaje Jake
    local personajeData2 = { width=28, height=40, numFrames=11,}
    local personajeSheet2 = graphics.newImageSheet( "JakeN.png", personajeData2 )    
    local personajeSequence2 = {
        { name = "frente", start=4, count=1, time=125,},
        { name = "right", start=1, count=3, time=500},
        { name = "left", start=5, count=3, time=500,},
        { name = "muerto", start=8, count=2, time=250,},
        { name = "comer", start=12, count=1, time=125,},
        { name = "comerd", start=11, count=1, time=125,},
        { name = "comerl", start=10, count=1, time=125,},}

     


--Flama Hielo
local flamaSheet = graphics.newImageSheet( "missil2.png", {width = 180, height = 183, numFrames = 6 })
local flamaSheet2 = graphics.newImageSheet( "missil22.png", {width = 180, height = 183, numFrames = 6 })
 flamaSequence = {
            { name = "inicial", start=1, count=2, time=400,loopCount=1 },
            { name = "continuo", start=1, count=2, time=400},
            { name = "desaparece", start=3, count=4, time=500,loopCount=1 },}
local function mySpriteListener( event )
         
     if ( event.phase == "ended" ) and callpauseFlag==true then
        thisSprite = event.target 
        thisSprite:setSequence( "continuo" )  
        thisSprite:play()
        elseif ( event.phase == "ended" ) and callpauseFlag==false then
        event.target:pause()
        end
         return true
        end
--Frostball
local frostballSheet = graphics.newImageSheet( "frostBall.png", {width = 69, height = 69, numFrames = 5 })
local frostballSequence = {
            { name = "inicial", start=1, count=2, time=800},
            { name = "medio", start=3, count=2, time=800},
            { name = "desaparece", start=3, count=4, time=800,},}

--Ice king
local iceSheet = graphics.newImageSheet( "MaloGru.png", {width = 62, height = 84, numFrames = 3 })
local iceSequence = {
            { name = "right", start=1, count=1, time=600},
            { name = "frente", start=2, count=1, time=600,},
            { name = "left", start=3, count=1, time=600,}, }
--Moneda            
local MonedaSheet = graphics.newImageSheet( "Moneda.png", { width=38, height=41, numFrames=13} )    
local MonedaSequence = {
            { name = "inicial", start=1, count=4, time=800, },
            { name = "comida", start=5, count=4, time=400, },
            { name = "desaparece", start=9, count=5, time=500, }} 

local basketSheet = graphics.newImageSheet( "basket.png", {width = 54,height = 43,numFrames = 6 })
local basketSequence = {
            { name = "frente", start=1, count=1, time=800,},
            { name = "explosion", start=2, count=5, time=800},}       
--Flechas
local flechaSheet = graphics.newImageSheet( "Arrows.png",{ width = 92, height = 70, numFrames = 2} )  
local flechaSequence = {
            { name = "reposo", start=1, count=1, time=800,},
            { name = "presionado", start=2, count=1, time=800},}         
-- SCENE:CREATE
function scene:create( event )

    local sceneGroup = self.view     
physics.start( )
physics.setGravity( 0, 4 )  


--Sonidos        
FondoMusica2= audio.loadSound( "Theme8.ogg")

Fail= audio.loadSound( "GameFail.ogg")
Bite= audio.loadSound( "Bite.ogg")
CheersAudio= audio.loadSound( "Cheers.ogg")
snowball= audio.loadSound( "snowball.ogg")
BasketAudio= audio.loadSound( "basket.ogg")
door= audio.loadSound( "door.ogg")

--Background
fondo = display.newImageRect("endless1.png",380,570)

sceneGroup:insert(fondo)


izq=display.newRect(display.contentWidth/4,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(izq)
izq.isVisible=false
izq.isHitTestable=true

der=display.newRect(display.contentWidth/4*3,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(der)
der.isVisible=false
der.isHitTestable=true






pared = {}
        for i = 1, 2, 1 do
        pared[i]=display.newRect(-45,display.contentHeight/2,100,display.contentHeight)
        pared[i].isVisible=false
        pared[i].name="pared" 
        sceneGroup:insert(pared[i])
        physics.addBody( pared[i], "static", {density=100, friction=1, bounce=0 ,filter={ categoryBits=1, maskBits=2 }, } )
        end
        --pared Derecha
		--pared[2].x=display.contentWidth+15
--Puerta Marrón
PuertaM = display.newImageRect(sceneGroup, "PuertaM.png", 68,110)
PuertaM.x=display.contentCenterX-127
PuertaM.y=display.contentCenterY+27
PuertaM.isVisible=true

--Puerta Azul
PuertaA = display.newImageRect( sceneGroup,"PuertaA.png",70,106)
PuertaA.x=display.contentCenterX+125
PuertaA.y=display.contentCenterY+30

PuertaA.isVisible=false
PuertaA.name="PuertaA"
physics.addBody( PuertaA, "static", {density=0, friction=0, bounce=0,filter={ categoryBits=32, maskBits=2 },isSensor=true,
shape={10,-30, 30,-30,  30,45, 10,45} } )
--Suelo
suelo=display.newRect(display.contentCenterX,display.contentCenterY+133,display.contentWidth,100)
suelo.name="suelo"
physics.addBody( suelo, "static", {density=100, friction=1, bounce=0 ,filter={ categoryBits=8, maskBits=150 }, } )
suelo.isVisible=false



--Valores iniciales
muchoRatoPuerta=false
muchoRatoPuertaSolo1flama=true
inicioFlag=true
pressed=true
flamaDif=600
margenDif=0
nextLevel=false

muereUnaVez=true
puntosRequired=30--cambiar nivelDif de puntosGalleta y puntosPuerta
user.flamaNum=0 saveValue('user.txt', json.encode(user)) --vamos sumando hasta que de el numero indicado
StopFlag=false
   -- Inicio de puntos
    user.actualgalletas = 0
    user.actualScore=0
    user.level=1
    user.session=user.session+1
    -- guarda datos
    saveValue('user.txt', json.encode(user))



--Ice King        
Ice = display.newSprite( iceSheet, iceSequence )
sceneGroup:insert(Ice)
Ice.isVisible=true

Nube = display.newImageRect( "NubeH.png",151,52)
Nube.x=display.contentCenterX
Nube.y=topMarg+100
Ice.y=topMarg+57
sceneGroup:insert(Nube)
  function reducirnube()
transition.scaleTo( Nube, { xScale=0.95, yScale=0.95, time=2000 } )
transition.moveTo( Nube, {x=display.contentCenterX+5,time=2000} )
transition.moveTo( Ice, {x=display.contentCenterX+5,time=2000} )
Nubetimer1=timer.performWithDelay( 2000, aumentarnube)

end
function aumentarnube()

transition.scaleTo( Nube, { xScale=1, yScale=1, time=2000 } )
Nubetimer2=timer.performWithDelay( 2000, reducirnube)
transition.moveTo( Nube, {x=display.contentCenterX-5,time=2000} )
transition.moveTo( Ice, {x=display.contentCenterX-5,time=2000} )

end
reducirnube()
--HUD


Level = display.newEmbossedText(sceneGroup, "Level "..user.level,display.contentCenterX,topMarg+100,"telo",25)
Level:setFillColor(0.4,0.1,0.8)
timer.performWithDelay(2000,function()transition.fadeOut( Level, { time=3000 } )end)
Level.isVisible=false
--Vidas HUD
--vidaHud=display.newImageRect("vidaMiniatura.png", leftMarg+40,topMarg+35)
--sceneGroup:insert(vidaHud)

--vidas = display.newText(sceneGroup, user.vidas,leftMarg+40,topMarg+44,"telo",15)
--vidas:setFillColor(0.424,0.20,0.008)
--sceneGroup:insert(vidas)

--Galleta HUD
--galletaHud=display.newImageRect("galletaMiniatura.png", rightMarg-40,topMarg+37)
--sceneGroup:insert(galletaHud)

--galletas = display.newText(sceneGroup, user.galletas,rightMarg-39,topMarg+45,"telo",15)
--galletas:setFillColor(0.424,0.20,0.008)

--actualScore=display.newEmbossedText(sceneGroup, user.actualScore,display.contentCenterX+63,display.contentCenterY-19,"telo",19)
actualScore=display.newText(sceneGroup, user.actualScore,display.contentCenterX+5,display.contentCenterY+3,"telo",36)
actualScore:setFillColor(.424, .20, .008)

actualScoreText=display.newText(sceneGroup, "Score",display.contentCenterX+5,display.contentCenterY+43,"telo",16)
actualScoreText:setFillColor(.424, .20, .008)
--actualScore:rotate( 351 )


    -- recarga de datos
    user = json.decode(loadValue('user.txt'))
 
    -- actualización de estado
    --vidas.text =  user.vidas


    

end--END de SCENE:CREATE

-- SCENE:SHOW("will")
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

FondoMusicaChannel= audio.play(FondoMusica2, {loops=(-1)})

        --if nubeFlag then
retryNube=display.newImage(sceneGroup,"retryNube2.png", display.contentCenterX, topMarg-39)





--fondo
fondo.x = display.contentCenterX
fondo.y = display.contentCenterY

--Ice King
Ice.x=display.contentCenterX

Ice:play()

function funcionremoveMonedasTmr()--planteamos funcion
                if removeMonedasTmrVivo then --si esta vivo lo cancelamos
                timer.cancel(removeMonedasTmr)
                end
                end
            






-- SCENE:SHOW("did")
	elseif ( phase == "did" ) then  


--Iniciamos con No Highscore, esta claro
highScoreFlag=false
--Personajes
function crearPersonaje()
personaje = display.newSprite( personajeSheet, personajeSequence )
personaje.name="personaje"
sceneGroup:insert(personaje)
personajeScale=1.8
personaje.xScale=personajeScale
personaje.yScale=personajeScale
physics.addBody( personaje, "dynamic", { density=1,friction=1, bounce=0,
    shape={-17,-30, 17,-30,  17,40, -17,40, -17,12, -17,-4}, filter={ categoryBits=2, maskBits=253 }})
--Personaje
personaje.x=display.contentCenterX-127
personaje.y=display.contentCenterY+43
print("PERSONAJE")
--Colision personaje
local function onCollisionPers(self, event )
    --Personaje MUERE

        if (event.other.name) == "Flama" then
            function muerePersonaje()
                if flamas.x>leftMarg+40 and matarInicio==true and muereUnaVez==true then --si no esta en la puerta despues de haber saltado la flama del muchoRatoPuerta entonces:
                muereUnaVez=false--quita error de cuando te cojen dos flamas a la vez
                motionx=0
                guardaPuntos()
                audio.play(Fail)
                
                personaje:pause()
                timer.performWithDelay(250,function() personaje:setSequence( "muerto" );
                personaje:play(); physics.removeBody( personaje );    end)
                
                flechaL:setSequence( "reposo" )
                flechaR:setSequence( "reposo" )
                flechaL:removeEventListener("touch",flechaL)
                flechaR:removeEventListener("touch",flechaR)    
                Runtime:removeEventListener( "enterFrame", TR )
                
                Runtime:removeEventListener("enterFrame", moverPersonaje)

                izq:removeEventListener("touch",izq)
                der:removeEventListener("touch",der)
                Runtime:removeEventListener("touch", stopNoflechas )
                Runtime:removeEventListener("enterFrame", moveguy)
                StopFlag=true
                  

                motionx=0
                muchoRatoPuerta=false
                timer.cancel(timerMuchoRatoPuerta)
               	pressed=true
                print("Muerto")
                personaje:toFront( )

                funcionremoveMonedasTmr()

                transition.to(personaje,{time=250,y=personaje.y-50,delay=250})
                transition.to(personaje,{time=2500,y=(personaje.y+500), delay=500})
                timer.performWithDelay( 1700, function () personaje.isVisible=false end)

                    if user.vidas==0 then --si no te quedan vidas
                           Runtime:removeEventListener("touch", stopNoflechas )
                Runtime:removeEventListener("enterFrame", moveguy)

                    	composer.showOverlay("vidas")
                    	
                        pause:setEnabled(false)
                        retryFlag=true
                        audio.stop(FondoMusicaChannel)
                        --timer.performWithDelay( 10, function() flechaL:removeSelf( ) flechaR:removeSelf( )end)
                        local options = {
                        effect = "slideDown",
                        time = 800,}

                        timer.performWithDelay( 1200, function () composer.gotoScene( "Retry",options) end )
                        timer.cancel(Nubetimer1) timer.cancel(Nubetimer2)
                        timer.performWithDelay( 900, function() 
                            transition.fadeOut( Ice, {time=400 })  
                            transition.fadeOut( Nube, {time=400}) 
                            transition.fadeOut( flechaL, {time=400 }) 
                            transition.fadeOut( flechaR, {time=400 }) 
                            transition.fadeOut( pause, {time=400 }) 
                            transition.fadeOut( flamas, {time=400 }) end, 
                            {onComplete=function() 
                            Nube.isVisible=false
                            flamas.isVisible=false 
                            
                                end})  
                            

                        timer.performWithDelay( 2000, function () timer.cancel( flamaTimer )physics.removeBody( suelo ) end )
                
                    else --si tienes vidas aun entonces:
                        
                        inicioFlag=true
                        timer.performWithDelay( 1700, crearPersonaje)
                        timer.performWithDelay( 2000, function() reaparecer() flechasListeners() runtimeListeners() end)
                         -- actualización de estado
                         quitaVidas()
                        
            end
            end
end--muerePersonaje()
muerePersonaje()



--Personaje Entra PuertaA
elseif (event.other.name) == "PuertaA" then
                if user.actualScore>=100000 then
                    print("Siguiente nivel")
                    
                    
                    flechaL:setSequence( "reposo" )
                    flechaR:setSequence( "reposo" )
                    flechaL:removeEventListener("touch",flechaL)
                    flechaR:removeEventListener("touch",flechaR)    
                    Runtime:removeEventListener( "enterFrame", TR )
                    Runtime:removeEventListener("touch", stop )
                    Runtime:removeEventListener("enterFrame", moverPersonaje)
                   transition.moveBy( personaje, {x=500} )
                   timer.performWithDelay( 50, function() composer.removeScene("Endless", true) composer.gotoScene("Endless2") end)
                   else
                   -- if user.session==3 then 
                    --    ads.show( "interstitial", { appId="ca-app-pub-3836849703819703/7092934470" } )
                  --  end


                    audio.play( door)
                    inicioFlag=true--se hace para llamar inicio solo una vez, aqui permitimos que se vuelva a llamar, en Inicio() lo cerramos 
                    matarInicio=false--desactivamos para que no se le pueda matar con la flama que hay para que se vaya de la puerta al Inicio
                    personaje:setSequence("right")
                    personaje:play()
                    personaje.isVisible=false 
                    PuertaA.isVisible=false  

                    if unPunto==false then
                    puntosPuerta()
                    unPunto=true 
                    end
                    reaparecer() 

                end

                end
                end
                personaje.collision = onCollisionPers
                personaje:addEventListener("collision", personaje) 
end

crearPersonaje()--se llama para crear personaje al inicio de todo



--Personaje sale de casa
function salirCaseta()
    personaje.x=tonumber(personaje.x)
    if (leftMarg+90>=personaje.x and personaje.x>= 65) then
        PuertaM.isVisible=false
        pared[1].x=0
        muchoRatoPuerta=false
        timer.cancel(timerMuchoRatoPuerta)
       
    elseif personaje.x>90 then 
        pared[1].x=-100
    end
end
function salirCasetaMuerte()
personaje.x=tonumber(personaje.x)
    if (leftMarg+90>=personaje.x and personaje.x>= 40) then
             matarInicio=true
         end
     end

 -- Move character

        -- When left arrow is touched, move character left
         function izq:touch()
         motionx = -speed;
         personaje:setSequence("left")
         personaje:play()
       
         end
         
        -- When right arrow is touched, move character right
         function der:touch()
         motionx = speed;
         personaje:setSequence("right")
         personaje:play()
        
         end
         
        -- Move character
         local function moveguy (event)
         personaje.x = personaje.x + motionx;
         if personaje.x>display.contentCenterX-123 then 
            PuertaM.isVisible=false

           end
         end
         

        -- Stop character movement when no arrow is pushed
         local function stopNoflechas (event)
         if event.phase =="ended" and StopFlag then
         personaje:setSequence("muerto")
         print("muerto!!")
         personaje:play()
         motionx = 0
        elseif event.phase =="ended" and StopFlag==false then
         personaje:setSequence("frente")
         print("locooooo")
         personaje:play()
        motionx = 0
         end
         end
  function noFlechasListeners()       
izq:addEventListener("touch",izq)
    der:addEventListener("touch",der)
    
Runtime:addEventListener("touch",stopNoflechas)
end
 noFlechasListeners() 










--Movimiento personaje
motionx = 0
speed = 7 
function moverPersonaje (event)
    personaje.x = personaje.x + motionx
    salirCaseta()
    salirCasetaMuerte()
     local function flechasPauseON()
                if flechasFlagPause==true then--sirve para poner flechas despues del play en el pauseOverlay
                        flechaL:addEventListener("touch",flechaL)
                        flechaR:addEventListener("touch",flechaR)
                        flechasFlagPause=false
                        pause.x= rightMarg-25
                    end
                end
                    flechasPauseON()
    end
--Runtime:addEventListener("enterFrame", moverPersonaje) se traslada a la función runtimeListeners

flechaScale=1.5
flechaMargenX=80
flechaCentrarAbajoY=(bottomMarg-(display.contentCenterY+120))/2+(display.contentCenterY+120)

--Flecha Izquierda
flechaL=display.newSprite(flechaSheet,flechaSequence)
flechaL.x = leftMarg+flechaMargenX
flechaL.y = flechaCentrarAbajoY
flechaL:scale(flechaScale,flechaScale)

function flechaL:touch()
    if pressed then
        motionx = -speed
        personaje:setSequence("left")
        personaje:play()
        flechaL:setSequence("presionado")
        pressed=false
    end
    end

--Flecha Derecha
flechaR=display.newSprite(flechaSheet,flechaSequence)
flechaR.x = rightMarg-flechaMargenX
flechaR.y = flechaCentrarAbajoY
flechaR:scale(-flechaScale,flechaScale)

function flechaR:touch()
    if pressed then
        motionx = speed
        personaje:setSequence("right")
        personaje:play()
        flechaR:setSequence("presionado")
        pressed=false
         end
     end

-- Para el personaje 
         function stop (event)
         if event.phase =="ended" then
            motionx = 0
            flechaL:setSequence("reposo")
            flechaR:setSequence("reposo")
            personaje:setSequence("frente")
            personaje:play() 
            pressed=true 
       elseif event.phase =="cancelled" then
            motionx = 0
            flechaL:setSequence("reposo")
            flechaR:setSequence("reposo")
            personaje:setSequence("frente")
            personaje:play() 
            pressed=true 
         end

         end
function flechasListeners()
    flechaL:addEventListener("touch",flechaL)
    flechaR:addEventListener("touch",flechaR)
    
end
flechasListeners()
-- Quitar las flechas de invisible para reincorporarlas y tambien en pauseOverlay en playhandlerevent
flechaR.isVisible=false
flechaL.isVisible=false


function flama2IntervaloFunc()--se usa para medir dificultad de bola rapida
    if user.actualScore>=0 and user.actualScore<10 then 
        flama2Intervalo=10
        elseif user.actualScore>=10 and user.actualScore<25 then
        flama2Intervalo=8
        
        elseif user.actualScore>=25 and user.actualScore<40 then
        flama2Intervalo=7   
        elseif user.actualScore>=40 and user.actualScore<60 then
        flama2Intervalo=6
        elseif user.actualScore>=60 and user.actualScore<100 then
        flama2Intervalo=5
        elseif user.actualScore>=100 then
        flama2Intervalo=4
    end
    return flama2Intervalo
    end

--Flama Hielo

local function spawnFlama(params)
user.flamaNum=user.flamaNum+1 saveValue('user.txt', json.encode(user)) --vamos sumando hasta que de el numero indicado
print(user.flamaNum)
        if user.flamaNum>=flama2IntervaloFunc() then--la flama normal sale siempre excepto que sea este numero
            
                flamas=display.newSprite(flamaSheet2, flamaSequence) 
               flamaVelocity=true
                user.flamaNum=0 saveValue('user.txt', json.encode(user))--restauramos valores

                --FROSTBALL ACTIVAR SI SE QUIERE PONER
                 --frostball=display.newSprite(sceneGroup, frostballSheet, frostballSequence)
                -- physics.addBody( frostball, "static", { density=10, friction=1, bounce=0,radius=50,filter={ categoryBits=128, maskBits=10 }} )
                 --frostball.name="frostball"
                 --frostball:scale(0.4,0.4)
                -- frostball.x=display.contentCenterX
                --frostball.y=50
                --transition.scaleTo( frostball, { xScale=1.5, yScale=1.5, time=800 } )
                --transition.to( frostball, {y=display.contentCenterY+38,time=2000} )
                --user.flamaNum=0 saveValue('user.txt', json.encode(user))--restauramos valores

                local function onCollision5(self, event )
                    if (event.other.name) == "personaje" then
                        if frostball.y<display.contentCenterY+38 then
                    muerePersonaje()
                     else
                        end
                end
                    end
                    --ACTIVAR PARA FROSTBALL
                    --frostball.collision = onCollision5
                    --frostball:addEventListener("collision", frostball)


                 function frostMove (event)
                     if event.phase =="began" then
                       print("touched")
                        event.target:setSequence("desaparece")
                        event.target:play()
                                timer.performWithDelay(400, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                                timer.performWithDelay(10, function () physics.removeBody(event.target) end)
                   elseif event.phase =="cancelled" then
                     end

                end
                --Activar para FROSTBALL
               --  frostball:addEventListener( "touch", frostMove )



            else

           

flamas=display.newSprite(flamaSheet, flamaSequence)

end
    flamas.objTable = params.objTable

    flamas.index = #flamas.objTable + 1

    flamas.myName = "Flama:" .. flamas.index

    flamas.group = params.group or nil

    flamas.group:insert(flamas)

    flamas.objTable[flamas.index] = flamas
    flamas:toFront( )

    flamaPositionPrev()--sirve para no repetir flamaposition


    --personaje:toFront( )
    flamaScale=0.4
    flamas:scale(flamaScale,flamaScale)
            flamas.x= flamaPosition()
            flamas.y= 50   
            flamas.name="Flama"
            flamas:play()

            pauseFlagFlamas=true--se pone para que no me la lie en el retry cuando volvemos. Le hemos de decir que si hay flamas
           function callpause()
            flamas:pause()
            callpauseFlag=false
            
            end
            function callplay()
            flamas:play()
            callpauseFlag=true

            end


            flamas:addEventListener( "sprite", mySpriteListener)
            physics.addBody( flamas, { density=1, friction=6, bounce=0, 
                shape={0,-29, -13,0, -13,17, 0,29, 13,17, 13,0, 0,29},filter={ categoryBits=4, maskBits=10 }} )
            flamas:setSequence( "inicial" )
            flamas:play()
            function spriteFlamaTransition()
            --no ponemos nada porque da problemas
            end

     local function onCollision(self, event )
                if (event.other.name) == "suelo"  or "personaje" then
                    event.target:removeEventListener("sprite", mySpriteListener)
                    event.target:setSequence("desaparece")
                    event.target:play()
                    event.target:setLinearVelocity(0,0)
                    timer.performWithDelay(400, function () table.remove(event.target); display.remove(event.target);event.target=nil end)
                    
                    timer.performWithDelay(10, function () physics.removeBody(event.target) end)
                    audio.play( snowball)

                end
                    end
                    flamas.collision = onCollision
                    flamas:addEventListener("collision", flamas)

if flamaVelocity==true then

 flamas:setLinearVelocity( 0, 150)
 flamaVelocity=false
end





    return flamas

    end
local function spawnFlamaT()

for i = 1, 1 do
local spawns = spawnFlama(
{
objTable = flamaTable,
group = sceneGroup,
}
)
end
end 

flamaTimer=timer.performWithDelay(flamaDif, spawnFlamaT,0)



--Transición para que las flamas vayan a su lugar una vez creadas de la mano del Ice King
function TR()
    if TRi0 then --Solo se llama cuando el personaje esta mucho rato en la puerta
        transition.to( flamas, {x=leftMarg+35+extraIpad-ei2,y=topMarg+160, time=200-margenDif, onComplete=spriteFlamaTransition})
        flamas:setLinearVelocity( 0, 0)
            TRi0=false --sirve para parar de enviar flamas a la puerta una vez sale el personaje de ella
            elseif TRi1 then
        transition.to( flamas, {x=leftMarg+75+extraIpad-ei2,y=topMarg+60, time=350-margenDif, onComplete=spriteFlamaTransition})
        TRi1=false   
         elseif TRd1 then
        transition.to( flamas, {x=leftMarg+247+extraIpad+ei2,y=topMarg+60, time=350-margenDif, onComplete=spriteFlamaTransition})
        TRd1=false
    end
end
--Runtime:addEventListener( "enterFrame", TR ) SE TRASLADA A LA FUNCION runtimeListeners

function flamaPositionPrev()--sirve para no repetir flamaposition
              
jRandom=math.random(5)            
if jRandom==user.flamaPosition then flamaPositionPrev() 
    else j=jRandom
        user.flamaPosition = jRandom saveValue('user.txt', json.encode(user)) user = json.decode(loadValue('user.txt'))--guardamos datos en json
    end
end

function flamaPosition()

        --Si es un Ipad espacia mas las flamas de hielo
        if display.actualContentWidth>321 then
        extraIpad=display.actualContentWidth/2-320/2
        ei1=15
        ei2=10
    else 
        extraIpad=0
        ei1=0
        ei2=0
    end

    if muchoRatoPuerta and muchoRatoPuertaSolo1flama  then 
        muchoRatoPuertaSolo1flama=false
       m=leftMarg+116+extraIpad
            flamas:setSequence( "superinicial" )
            flamas:play()
            Ice:setSequence( "left" )
            Ice:play()
            TRi0=true 
            
    else

        --posicionamiento de flamas de hielo 
        if j==1 then
            m=leftMarg+100+extraIpad
            flamas:setSequence( "superinicial" )
            flamas:play()
            Ice:setSequence( "left" )
            Ice:play()
            TRi1=true
            elseif  j==2 then
            m=leftMarg+116+extraIpad
            Ice:setSequence( "left" )
            Ice:play()
            
            elseif  j==3 then
            m=leftMarg+161+extraIpad
            Ice:setSequence( "frente" )
            Ice:play()
             elseif j==4 then
            m=leftMarg+206+extraIpad
            Ice:setSequence( "right" )
            Ice:play()
             elseif j==5 then
            m=leftMarg+206+extraIpad
            flamas:setSequence( "superinicial" )
            flamas:play()
            Ice:setSequence( "right" )
            Ice:play()
            TRd1=true
        end
    end
    return m
end


function teleportOnOffID()
    if Mon==1 then 
    teleport[1].isVisible=true
    teleport[1]:play()
    timer.performWithDelay( teleportSpriteTime, function()teleport[1].isVisible=false; teleport[1]:pause() end)
    elseif Mon==2 then 
    teleport[2].isVisible=true
    teleport[2]:play()
    timer.performWithDelay( teleportSpriteTime, function()teleport[2].isVisible=false; teleport[2]:pause() end)
    elseif Mon==3 then 
    teleport[3].isVisible=true
    teleport[3]:play()
    timer.performWithDelay( teleportSpriteTime, function()teleport[3].isVisible=false; teleport[3]:pause() end)
    elseif Mon==4 then 
    teleport[4].isVisible=true
    teleport[4]:play()
    timer.performWithDelay( teleportSpriteTime, function()teleport[4].isVisible=false; teleport[4]:pause() end)
    elseif Mon==5 then 
    teleport[5].isVisible=true
    teleport[5]:play()
    timer.performWithDelay( teleportSpriteTime, function()teleport[5].isVisible=false; teleport[5]:pause() end)
end
end

--Posicion monedas segun cesta
function monedaPosition()
mRandom=math.random(3)

if bRandom==1 then
        monedaP=basketP+30+mRandom*40
elseif bRandom==2 then
        --para que salga a la izquierda y derecha de la cesta
        if mRandom==1 then
        monedaP=basketP-70
        elseif mRandom==2 then
        monedaP=basketP+65
        elseif mRandom==3 then
        monedaP=basketP+105
        end   
elseif bRandom==3 then 
        --para que salga a la izquierda y derecha de la cesta
        if mRandom==1 then
        monedaP=basketP-70
        elseif mRandom==2 then
        monedaP=basketP+70
        elseif mRandom==3 then
        monedaP=basketP-115
        end   
elseif bRandom==4 then 
        monedaP=basketP-30-mRandom*40
    end
    return monedaP
    end

--Spawn Monedas
local function spawnMoneda(params)
--Monedas = display.newSprite( MonedaSheet, MonedaSequence)
Monedas = display.newImage(sceneGroup,"banana.png")
Monedas.objTable = params.objTable
Monedas.index = #Monedas.objTable + 1
Monedas.myName = "Moneda: " .. Monedas.index
Monedas.group = params.group or nil
Monedas.group:insert(Monedas)
Monedas.objTable[Monedas.index] = Monedas

          --  Monedas:setSequence("inicial")
          --  Monedas:play( )
            --posición moneda
            Monedas.x= monedaPosition()
            Monedas.y=display.contentCenterY+61
            
            monedaScale=0.45
            Monedas:scale(monedaScale,monedaScale)
            Monedas.value=5
            Monedas.name="moneda"

            removeMonedasTmrVivo=true--esta activado

            
            
            timer.performWithDelay( 1, function()physics.addBody( Monedas,{ density=0, friction=0, bounce=0.1, 
                radius=19,filter={ categoryBits=16, maskBits=10 }} )  end)

            removeMonedasTmr=timer.performWithDelay( 4000, function() display.remove( Monedas ) timer.cancel(removeMonedasTmr) 
                removeMonedasTmrVivo=false end)--desactivamos tambien el flag del timer

    function onCollision2(self, event )

                --Colision Moneda/personaje
                if (event.other.name=="personaje")  then
                event.target:toFront( )
                audio.play(Bite)
                  --Solo sale sprite de galleta comida cuando se come de frente
                timer.performWithDelay(10, function()  display.remove(event.target) end)
                timer.performWithDelay(2, function () physics.removeBody(event.target) end)
                timer.cancel(removeMonedasTmr)
                personajeSpritePosComer()
                --Solo puntuar galletas si la flag esta activada (antes pasaba que al hacer removebody en el suelo se puntuaba galleta tambien)
                
                

                sumaactualgalletas()
                function puntosGalleta()
    user.actualScore = user.actualScore  + 5
    -- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
    -- actualiza marcador
    actualScore.text = user.actualScore
    --Dificultad 
    nivelDif=17--se necesitan 30 puntos para pasar, que son 6 monedas a 5 puntos cada una (100/6=17, aprox)
    flamaDif=flamaDif-nivelDif--para reducir el tiempo en que caen bolas, vaya que vayan mas rapido y sea mas dificil ganar
    margenDif=margenDif-nivelDif--para que se haga el setSequence de la bola caiendo en el momento justo y mas acurado
    timer.cancel( flamaTimer )
    flamaTimer=timer.performWithDelay(flamaDif, spawnFlamaT,0)
    print(flamaDif)
    Cincopuntos=display.newImageRect("+5.png",51,26)
    if motionx>0 then

    Cincopuntos.x=personaje.x+30
    elseif motionx<0 then
        Cincopuntos.x=personaje.x-30
    end
    Cincopuntos.y=display.contentCenterY-10
    Cincopuntos:scale(1.8,1.8)
        transition.to( Cincopuntos, { time=1500, alpha=0, y=display.contentCenterY-50,onComplete= function() display.remove( Cincopuntos )end } )
        sceneGroup:insert(Cincopuntos)
end
                puntosGalleta()
                
               
               
                end--fin de colision personaje
            
                
             
                return true

                 
        end--fin de colision en general
        Monedas.collision=onCollision2
        Monedas:addEventListener( "collision", Monedas )
            return Monedas
            end

local function spawnMonedaT()
for i = 1, 1 do
local spawnsM = spawnMoneda(
{objTable = MonedaTable,
group = sceneGroup,})
end
end 


--spawnMonedaT()

--Basketposition
function basketPosition()
    --si Ipad entonces correccion
if display.actualContentWidth>321 then
extraIpadBas=display.actualContentWidth/2-320/2
else
extraIpadBas=0
end
--posicion de basket
bRandom=math.random(4)
basketP=bRandom*45+50+extraIpadBas
return basketP
end

--Basket
local function spawnBasket(params)
basket = display.newSprite( basketSheet, basketSequence )
basket.objTable = params.objTable
basket.index = #basket.objTable + 1
basket.myName = "basket: " .. basket.index
basket.group = params.group or nil
basket.group:insert(basket)
basket.objTable[basket.index] = basket
            basket.x = basketPosition()
            basket.y=display.contentCenterY+61
basketFlag=true      
basket.name="basket"
timer.performWithDelay(1,function()physics.addBody( basket, "static", {density=0, friction=0, bounce=0, radius=17,
    isSensor=true,filter={ categoryBits=64, maskBits=2 }})end)

 local function onCollisionBas(self, event )
--Personaje coge cesta
if (event.other.name) == "personaje" then  

                if ( event.phase == "began" ) then 
                spawnMonedaT()
                print("moneda")
                basket:setSequence( "explosion" )
                basket:play()
                audio.play( BasketAudio )
                
                timer.performWithDelay(800, function()event.target.isVisible=false end)
                elseif ( event.phase == "ended" ) then
                   timer.performWithDelay( 2, function() physics.removeBody( event.target ) end)
                end
                
                end
                return true
                end
                basket.collision = onCollisionBas
                basket:addEventListener("collision", basket)

    return basket
    end

 function spawnBasketT()
for i = 1, 1 do
local spawnsB = spawnBasket(
{objTable = basketTable,
group = sceneGroup,})
end
end

--Después de comer el personaje se pone en un sprite o otro segun su poisición
function personajeSpritePosComer()

if motionx>0 then
personaje:setSequence("comerd")
timer.performWithDelay( 125, function ()
if motionx>0 then
personaje:setSequence("right");personaje:play()
elseif motionx==0 then
personaje:setSequence("frente");personaje:play()
elseif motionx<0 then
personaje:setSequence("left");personaje:play()end end)

elseif motionx==0 then
personaje:setSequence("comer")
timer.performWithDelay( 125, function ()
if motionx>0 then
personaje:setSequence("right");personaje:play()
elseif motionx==0 then
personaje:setSequence("frente");personaje:play()
elseif motionx<0 then
personaje:setSequence("left");personaje:play()end end)

elseif motionx<0 then
personaje:setSequence("comerl")
timer.performWithDelay( 125, function ()
if motionx>0 then
personaje:setSequence("right");personaje:play()
elseif motionx==0 then
personaje:setSequence("frente");personaje:play()
elseif motionx<0 then
personaje:setSequence("left");personaje:play()end end)
end        
end
--Sumar 1 galleta al marcador
function sumaactualgalletas()
    user.actualgalletas = user.actualgalletas + 1
    user.galletas = user.galletas + 1
    -- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
    -- actualiza marcador
    --galletas.text = user.galletas
end



function puntosPuerta()
user.actualScore = user.actualScore  + 1
    -- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
    -- actualiza marcador
    actualScore.text = user.actualScore
    nivelDif=3--se necesitan 30 puntos para pasar, que son 30 puertas a 1 punto cada una (100/30=3, aprox)
    flamaDif=flamaDif-nivelDif--para reducir el tiempo en que caen bolas, vaya que vayan mas rapido y sea mas dificil ganar
    margenDif=margenDif-nivelDif--para que se haga el setSequence de la bola caiendo en el momento justo y mas acurado
    timer.cancel( flamaTimer )
    flamaTimer=timer.performWithDelay(flamaDif, spawnFlamaT,0)
    print(flamaDif)
    Unpuntos=display.newImageRect("+1.png",51,26)
    Unpuntos.x=PuertaA.x
    Unpuntos.y=PuertaA.y-50
    Unpuntos:scale(1.5,1.5)
        transition.to( Unpuntos, { time=1500, alpha=0, x=PuertaA.x, y=PuertaA.y-80,onComplete= function() display.remove( Unpuntos )end } )
        sceneGroup:insert(Unpuntos)
end



function quitaVidas()
user.vidas = user.vidas - 1
    -- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
    -- actualiza marcador
    --vidas.text = user.vidas
end
function guardaPuntos()
--Guardar puntuación
if user.actualScore>user.highScore then
    user.highScore=user.actualScore
    highScoreFlag=true
-- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
end
end

function runtimeListeners()
Runtime:addEventListener( "enterFrame", TR )
--Runtime:addEventListener("touch", stop )
Runtime:addEventListener("enterFrame", moverPersonaje)
end
runtimeListeners()


--Colision personaje-----------------------------------------------------------------------------------------
 

function reaparecer()

        motionx=0
        transition.moveTo( personaje, { x=display.contentWidth+50, y=display.contentCenterY+43, time=50 } )
        timer.performWithDelay( 200, function() personaje.x=display.contentCenterX-127 personaje.y=display.contentCenterY+43
        personaje:setSequence("frente") personaje:play()
        personaje.isVisible=true PuertaM.isVisible=true callInicio() motionx=0 end)
        
        end
function callInicio()
    if inicioFlag then
        Inicio()
    else
        
    end
end

--Inicio
function Inicio()

display.remove( Monedas )
display.remove( basket )
funcionremoveMonedasTmr()

timer.performWithDelay(1000, function() PuertaA.isVisible=true end)
timerMuchoRatoPuerta=timer.performWithDelay(6000, function() muchoRatoPuerta=true matarInicio=true end)
muchoRatoPuertaSolo1flama=true
inicioFlag=false--se hace para llamar inicio solo una vez
spawnBasketT()
unPunto=false --para que se sume solo un punto al cruzar puerta
end
Inicio()



--Pause



 local function handlePauseEvent( event )

        if ( "ended" == event.phase )  then
       function pauseEndless()
                         print("pause")
                         physics.pause()
                         timer.pause( flamaTimer)
                         if removeMonedasTmr then
                           timer.pause( removeMonedasTmr)
                       end
                         Ice:pause()
                         --play:toFront()
                         paused = true
                         if pauseFlagFlamas==true then 
                         callpause()
                            end
                            timer.pause(timerMuchoRatoPuerta)
                         flechaL:removeEventListener("touch",flechaL)
                         flechaR:removeEventListener("touch",flechaR)
                         flechaR.isVisible=false
                         flechaL.isVisible=false
                         izq.isHitTestable=false
                         der.isHitTestable=false
                        composer.showOverlay( "pauseOverlay" )
                        pause.x= rightMarg+1000
                        audio.pause(FondoMusicaChannel)
                    end
                        pauseEndless()
    end
end

  local options = {
        width = 48,
        height = 47,
        numFrames = 2,}
    local pauseSheet = graphics.newImageSheet( "pauseBut.png", options )
    pause = widget.newButton
    {sheet = pauseSheet,
     defaultFrame = 1,
     overFrame = 2,
     onEvent = handlePauseEvent}     

    sceneGroup:insert(pause)

pause.x= rightMarg-25
pause.y=topMarg+25










end
end	--END de SCENE:SHOW	

-- SCENE:HIDE("will")
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.


-- SCENE:HIDE("did")       
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end--END de SCENE:HIDE




-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.


display.remove( personaje )
display.remove( fondo )
display.remove( flechaR )
display.remove( flechaL )
display.remove( pared )
display.remove( PuertaM )
display.remove( PuertaA )
display.remove( suelo )
display.remove( vidaHud )
display.remove( vidas )
display.remove( galletaHud )
display.remove( galletas )
display.remove( actualScore )
display.remove( Ice )
display.remove( flamas )
display.remove( Monedas )
display.remove( basket )
display.remove( flamaTable )
print("DESTROYED")
timer.cancel( flamaTimer )

pauseFlagFlamas=false--se pone para decir que no hay más flamas pq se ha acabado el juego










physics.stop( )

end--END de SCENE:DESTROY	
----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -------------------------------------------------------------------------------
--physics.setDrawMode( "hybrid" )
return scene 
