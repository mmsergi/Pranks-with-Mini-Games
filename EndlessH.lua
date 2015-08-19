--Shortcuts

--              adb install -r C:\Users\Jaume\Dropbox\Apps\TimeofAdventure.apk

--             	adb install   C:\Users\Jaume\Dropbox\Apps\TimeofAdventure.apk

--              adb logcat Corona:v *:s








--Requerimientos iniciales
local scene = composer.newScene()

local t = loadTable( "settings.json" )
json = require('json')

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
local extraIpad=35
local  ei1=0
local  ei2=0
local pressed
local flamaDif
local margenDif
local nextLevel

local play
local flama2Intervalo
callpauseFlag=true
flechasFlagPause=false
removeMonedasTmrVivo=false
--Sprites
	--Minion
    local personajeData = { width=38, height=41, numFrames=14,}
    local personajeSheet = graphics.newImageSheet( "assets4/FlinnH.png", personajeData )    
    local personajeSequence = {
        { name = "frente", start=1, count=1, time=125,},
        { name = "right", frames={2,3,4,5}, time=500},
        { name = "left", frames={6,7,8,9}, time=500,},
        { name = "muerto", start=10, count=2, time=250,},
        { name = "comerd", frames={13}, time=125,},
        { name = "comerl", frames={14}, time=125,},
        { name = "comerf", frames={12}, time=125,},}

--Flama Hielo
local flamaSheet = graphics.newImageSheet( "assets4/missil2.png", {width = 180, height = 183, numFrames = 6 })
local flamaSheet2 = graphics.newImageSheet( "assets4/missil22.png", {width = 180, height = 183, numFrames = 6 })
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

--Ice king
local iceSheet = graphics.newImageSheet( "assets4/MaloGru.png", {width = 62, height = 84, numFrames = 3 })
local iceSequence = {
            { name = "right", start=1, count=1, time=600},
            { name = "frente", start=2, count=1, time=600,},
            { name = "left", start=3, count=1, time=600,}, }


local basketSheet = graphics.newImageSheet( "assets4/basket.png", {width = 54,height = 43,numFrames = 6 })
local basketSequence = {
            { name = "frente", start=1, count=1, time=800,},
            { name = "explosion", start=2, count=5, time=800},}         

-- Stop character movement when no arrow is pushed
         function stopNoflechas (event)
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
  Runtime:addEventListener("touch",stopNoflechas) 

-- SCENE:CREATE
function scene:create( event )

    local sceneGroup = self.view     
physics.start( )
physics.setGravity( 0, 4 )  


--Sonidos        
FondoMusica2= audio.loadSound( "assets4/Theme8.ogg")

Fail= audio.loadSound( "assets4/GameFail.ogg")
Bite= audio.loadSound( "assets/coin.ogg")
CheersAudio= audio.loadSound( "assets4/Cheers.ogg")
door= audio.loadSound( "assets4/door.ogg")

--Background
fondo = display.newImageRect(sceneGroup,"assets4/endless1.png",533,800)




izq=display.newRect(display.contentWidth/4,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(izq)
izq.isVisible=false
izq.isHitTestable=true

der=display.newRect(display.contentWidth/4*3,display.contentCenterY,display.contentWidth/2,display.contentHeight)
sceneGroup:insert(der)
der.isVisible=false
der.isHitTestable=true

    cointext = display.newText(sceneGroup, "0", 0, 0, "telo", 40)
    cointext:setFillColor( black )
    cointext.x, cointext.y=rightMarg-80,topMarg+24

    coinHud = display.newSprite( coinsSheet, coinsSequence )
    coinHud:scale(0.8,0.8)
    sceneGroup:insert(coinHud)
    coinHud.x, coinHud.y = rightMarg-35,topMarg+22




pared = {}
        for i = 1, 2, 1 do
        pared[i]=display.newRect(-45,display.contentHeight/2,165,display.contentHeight)
        pared[i].isVisible=false
        pared[i].name="pared" 
        sceneGroup:insert(pared[i])
        physics.addBody( pared[i], "static", {density=100, friction=1, bounce=0 ,filter={ categoryBits=1, maskBits=2 }, } )
        end
        --pared Derecha
		--pared[2].x=display.contentWidth+15
--Puerta Marrón
PuertaM = display.newImage(sceneGroup, "assets4/PuertaM.png")
PuertaM.x=display.contentCenterX-178
PuertaM.y=display.contentCenterY+47
PuertaM.isVisible=true

--Puerta Azul
PuertaA = display.newImage( sceneGroup,"assets4/PuertaA.png")
PuertaA.x=display.contentCenterX+179
PuertaA.y=display.contentCenterY+43

PuertaA.isVisible=false
PuertaA.name="PuertaA"
physics.addBody( PuertaA, "static", {density=0, friction=0, bounce=0,filter={ categoryBits=32, maskBits=2 },isSensor=true,
shape={14,-42, 42,-42,  42,62, 14,62} } )
--Suelo
suelo=display.newRect(display.contentCenterX,display.contentCenterY+168,display.contentWidth,100)
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
Ice:scale(1.38,1.38)

Nube = display.newImageRect( "assets4/NubeH.png",151,52)
Nube.x=display.contentCenterX
Nube.y=topMarg+118
Ice.y=topMarg+57
Nube:scale(1.38,1.38)
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
actualScore=display.newText(sceneGroup, user.actualScore,display.contentCenterX+5,display.contentCenterY+3,"telo",50)
actualScore:setFillColor(.424, .20, .008)

actualScoreText=display.newText(sceneGroup, "Score",display.contentCenterX+5,display.contentCenterY+59,"telo",22)
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
retryNube=display.newImage(sceneGroup,"assets4/retryNube2.png", display.contentCenterX, topMarg-39)

    





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

    flechaTutoR = display.newImage( sceneGroup, "assets4/tap_R.png", rightMarg-150,bottomMarg-150)
    flechaTutoL = display.newImage( sceneGroup, "assets4/tap_L.png", leftMarg+150,bottomMarg-150)
    flechaIndicatoria = display.newImage( sceneGroup, "assets4/flecha.png", rightMarg-110,cy+60)

        function moverFlechasTuto()
            transition.moveTo( flechaTutoR, {x=rightMarg-120,time=300} )
            transition.moveTo( flechaTutoL, {x=leftMarg+120,time=300} )
            transition.moveTo( flechaIndicatoria, {x=rightMarg-120,time=300} )
            
            flechasTutoTmr1=timer.performWithDelay( 300, moverFlechasTuto2)
        end
        function moverFlechasTuto2()
            transition.moveTo( flechaTutoR, {x=rightMarg-150,time=300} )
            transition.moveTo( flechaTutoL, {x=leftMarg+150,time=300} )
            transition.moveTo( flechaIndicatoria, {x=rightMarg-100,time=300} )
            flechasTutoTmr2=timer.performWithDelay( 300, moverFlechasTuto)
        end
    moverFlechasTuto()
flechaIndicatoria.isVisible=false

if user.session==1 then
    flechaIndicatoriaTmr=timer.performWithDelay(1500, function() flechaIndicatoria.isVisible=true end)
elseif user.session>1 then
    flechaIndicatoriaTmr=timer.performWithDelay(5000, function() flechaIndicatoria.isVisible=true end)
end

--Iniciamos con No Highscore, esta claro

highScoreFlag=false
--Personajes
function crearPersonaje()
personaje = display.newSprite( personajeSheet, personajeSequence )
personaje.name="personaje"
sceneGroup:insert(personaje)
personajeScale=2.5
personaje.xScale=personajeScale
personaje.yScale=personajeScale
physics.addBody( personaje, "dynamic", { density=1,friction=1, bounce=0,
    shape={-23,-41, 23,-41,  23,55, -23,55, -23,16, -23,-6}, filter={ categoryBits=2, maskBits=253 }})
--Personaje
personaje.x=display.contentCenterX-180
personaje.y=display.contentCenterY+60
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
                personaje:play(); physics.removeBody( personaje ); print("jajajajajja")   end)
                
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
                           
                Runtime:removeEventListener("enterFrame", moveguy)

                    	--composer.showOverlay("vidas")
                    	
                       
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

                    timer.cancel(flechaIndicatoriaTmr)
                    flechaIndicatoria.isVisible=false

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
    if (leftMarg+124>=personaje.x and personaje.x>= 90) then
        PuertaM.isVisible=false
        pared[1].x=-10
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
        display.remove( flechaTutoR )
        display.remove( flechaTutoL )
        
        
         end
         
        -- When right arrow is touched, move character right
         function der:touch()
         motionx = speed;
         personaje:setSequence("right")
         personaje:play()
        display.remove( flechaTutoR )
        display.remove( flechaTutoL )
        
         end
         
        -- Move character
         local function moveguy (event)
         personaje.x = personaje.x + motionx;
         if personaje.x>display.contentCenterX-123 then 
            PuertaM.isVisible=false

           end
         end
         

        
izq:addEventListener("touch",izq)
    der:addEventListener("touch",der)
    

 










--Movimiento personaje
motionx = 0
speed = 9
function moverPersonaje (event)
    personaje.x = personaje.x + motionx
    salirCaseta()
    salirCasetaMuerte()
     local function flechasPauseON()
                if flechasFlagPause==true then--sirve para poner flechas despues del play en el pauseOverlay
                        flechaL:addEventListener("touch",flechaL)
                        flechaR:addEventListener("touch",flechaR)
                        flechasFlagPause=false
                        
                    end
                end
                    flechasPauseON()
    end
--Runtime:addEventListener("enterFrame", moverPersonaje) se traslada a la función runtimeListeners

flechaScale=1.5
flechaMargenX=80
flechaCentrarAbajoY=(bottomMarg-(display.contentCenterY+120))/2+(display.contentCenterY+120)

--Flecha Izquierda
flechaL=display.newSprite(iceSheet,iceSequence)
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
flechaR=display.newSprite(iceSheet,iceSequence)
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
    flamaScale=0.552
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
                shape={0,-40, -18,0, -18,23, 0,40, 18,23, 18,0, 0,40},filter={ categoryBits=4, maskBits=10 }} )
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
        transition.to( flamas, {x=leftMarg+10+extraIpad-ei2,y=topMarg+160, time=200-margenDif, onComplete=spriteFlamaTransition})
        flamas:setLinearVelocity( 0, 0)
            TRi0=false --sirve para parar de enviar flamas a la puerta una vez sale el personaje de ella
            elseif TRi1 then
        transition.to( flamas, {x=leftMarg+75+extraIpad-ei2,y=topMarg+60, time=350-margenDif, onComplete=spriteFlamaTransition})
        TRi1=false   
         elseif TRd1 then
        transition.to( flamas, {x=leftMarg+350+extraIpad+ei2,y=topMarg+60, time=350-margenDif, onComplete=spriteFlamaTransition})
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
      
      
        
 

    if muchoRatoPuerta and muchoRatoPuertaSolo1flama  then 
        muchoRatoPuertaSolo1flama=false
       m=leftMarg+160+extraIpad
            flamas:setSequence( "superinicial" )
            flamas:play()
            Ice:setSequence( "left" )
            Ice:play()
            TRi0=true 
            
    else

        --posicionamiento de flamas de hielo 
        if j==1 then
            m=leftMarg+138+extraIpad
            flamas:setSequence( "superinicial" )
            flamas:play()
            Ice:setSequence( "left" )
            Ice:play()
            TRi1=true
            elseif  j==2 then
            m=leftMarg+150+extraIpad
            Ice:setSequence( "left" )
            Ice:play()
            
            elseif  j==3 then
            m=leftMarg+215+extraIpad
            Ice:setSequence( "frente" )
            Ice:play()
             elseif j==4 then
            m=leftMarg+300+extraIpad
            Ice:setSequence( "right" )
            Ice:play()
             elseif j==5 then
            m=leftMarg+320+extraIpad
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
        monedaP=basketP+30+mRandom*56
elseif bRandom==2 then
        --para que salga a la izquierda y derecha de la cesta
        if mRandom==1 then
        monedaP=basketP-96
        elseif mRandom==2 then
        monedaP=basketP+90
        elseif mRandom==3 then
        monedaP=basketP+138
        end   
elseif bRandom==3 then 
        --para que salga a la izquierda y derecha de la cesta
        if mRandom==1 then
        monedaP=basketP-100
        elseif mRandom==2 then
        monedaP=basketP+96
        elseif mRandom==3 then
        monedaP=basketP-160
        end   
elseif bRandom==4 then 
        monedaP=basketP-30-mRandom*56
    end
    return monedaP
    end

--Spawn Monedas
local function spawnMoneda(params)
Monedas = display.newSprite( coinsSheet, coinsSequence )
Monedas:setSequence( "estatica" )
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
            Monedas.y=display.contentCenterY+85
            
            monedaScale=0.8
            Monedas:scale(monedaScale,monedaScale)
            Monedas.value=5
            Monedas.name="moneda"

            removeMonedasTmrVivo=true--esta activado

            
            
            timer.performWithDelay( 1, function()physics.addBody( Monedas,{ density=0, friction=0, bounce=0.1, 
                radius=21,filter={ categoryBits=16, maskBits=10 }} )  end)

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
    Cincopuntos=display.newImageRect("assets4/+5.png",51,26)
    if motionx>=0 then

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

extraIpadBas=30
end
--posicion de basket
bRandom=math.random( 4 )

basketP=bRandom*65+50+extraIpadBas
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
basket:scale(1.38,1.38)
basket.objTable[basket.index] = basket
            basket.x = basketPosition()
            basket.y=display.contentCenterY+85
basketFlag=true      
basket.name="basket"
timer.performWithDelay(1,function()physics.addBody( basket, "static", {density=0, friction=0, bounce=0, radius=23,
    isSensor=true,filter={ categoryBits=64, maskBits=2 }})end)

 local function onCollisionBas(self, event )
--Personaje coge cesta
if (event.other.name) == "personaje" then  

                if ( event.phase == "began" ) then 
                spawnMonedaT()
                print("moneda")
                basket:setSequence( "explosion" )
                basket:play()
                
                audio.play( CheersAudio )
                
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
    cointext.text=user.actualgalletas
    -- guarda datos
    saveValue('user.txt', json.encode(user))
    -- recarga datos
    user = json.decode(loadValue('user.txt'))
    -- actualiza marcador
    --galletas.text = user.galletas
    t.coins=t.coins+1
    saveTable(t, "settings.json")
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
    Unpuntos=display.newImageRect("assets4/+1.png",51,26)
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
        timer.performWithDelay( 200, function() personaje.x=display.contentCenterX-180 personaje.y=display.contentCenterY+60
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

flechaIndicatoriaTmr=timer.performWithDelay(5000, function() flechaIndicatoria.isVisible=true end)
timer.performWithDelay(1000, function() PuertaA.isVisible=true end)
timerMuchoRatoPuerta=timer.performWithDelay(6000, function() muchoRatoPuerta=true matarInicio=true end)
muchoRatoPuertaSolo1flama=true
inicioFlag=false--se hace para llamar inicio solo una vez
spawnBasketT()
unPunto=false --para que se sume solo un punto al cruzar puerta
end
Inicio()



--Pause








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

display.remove( cointext )
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
timer.cancel( flechasTutoTmr1 )
timer.cancel( flechasTutoTmr2 )
print("DESTROYED")
timer.cancel( flamaTimer )
display.remove( flechaIndicatoria )
timer.cancel(flechaIndicatoriaTmr)
Runtime:removeEventListener("touch", stopNoflechas )
pauseFlagFlamas=false--se pone para decir que no hay más flamas pq se ha acabado el juego

StopFlag=false








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
