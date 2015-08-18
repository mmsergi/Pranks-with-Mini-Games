local scene = composer.newScene()

local t = loadTable( "settings.json" )

local group


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
    group:insert(soundBtn)

    end
end

local function goHome()
	composer.gotoScene( "menu" )
	composer.removeScene( "menu2" )
end

function scene:create( event )
	group = self.view

	mayShowAd()

	if t.music==false then
		audio.setVolume(0)
	end

	local intro = audio.loadSound("assets/intro.ogg")
	audio.play( intro )
	
	local background = display.newImage( group, "assets/background2.png", cx, cy )
	
	local titulo = display.newText( group, translations["Juegos"][language], cx, topMarg+80, "BebasNeue", 80 )
    titulo:setFillColor( 0 )
    titulo.alpha=0.6
    local titulo2 = display.newText( group, translations["Juegos"][language], cx-5, topMarg+75, "BebasNeue", 80 )
    titulo2:setFillColor( 1 )
   
   --Tablas para randomizar la posición de los iconos
    local positionX = { leftMarg+125, rightMarg-125,leftMarg+125, rightMarg-125}
    local positionY = { cy-170,cy-170,cy+120,cy+120}

    local chosePosition = {1, 2, 3, 4}

function RandomizeOnce()
    
    i = math.random( #chosePosition )
    num1 = chosePosition[i]
    table.remove(chosePosition,i)
    j = math.random( #chosePosition )
    num2 = chosePosition[j]
    table.remove(chosePosition,j)

    k = math.random( #chosePosition )
    num3 = chosePosition[k]
    table.remove(chosePosition,k)

    q = math.random( #chosePosition )
    num4 = chosePosition[q]
    table.remove(chosePosition,q)
   
    if t.RandomizeOnceDone==false then
        t.num1= num1
        t.num2= num2
        t.num3= num3
        t.num4= num4
        t.RandomizeOnceDone=true
    saveTable(t, "settings.json")
end
end
RandomizeOnce()

function initialScoreText()
    
    if t.highscoreLaser == 0 then 
        local hsText1 = display.newText( group, "Play",positionX[t.num1],positionY[t.num1]+130,"BebasNeue",50 )
        hsText1:setFillColor(1,0,0)
    else
        local hsText1 = display.newText( group, "High Score",positionX[t.num1],positionY[t.num1]+105,"LobsterTwo-Regular",30 )
        hsText1:setFillColor( 0 )
        local hs1 = display.newText( group, t.highscoreLaser,positionX[t.num1],positionY[t.num1]+140,"LobsterTwo-Regular",40 )
        hs1:setFillColor( 0 )
    end

    if user.highScore == 0 then 
        local hsText2 = display.newText( group, "Play",positionX[t.num2],positionY[t.num2]+130,"BebasNeue",50 )
        hsText2:setFillColor(1,0,0)
    else 
        local hsText2 = display.newText( group, "High Score",positionX[t.num2],positionY[t.num2]+105,"LobsterTwo-Regular",30 )
        hsText2:setFillColor( 0 )
        local hs2 = display.newText( group, user.highScore,positionX[t.num2],positionY[t.num2]+140,"LobsterTwo-Regular",40 )
        hs2:setFillColor( 0 )
    end

    if t.highscoreCopter == 0 then 
        local hsText3 = display.newText( group, "Play",positionX[t.num3],positionY[t.num3]+130,"BebasNeue",50 )
        hsText3:setFillColor(1,0,0)
    else
        local hsText3 = display.newText( group, "High Score",positionX[t.num3],positionY[t.num3]+105,"LobsterTwo-Regular",30 )
        hsText3:setFillColor( 0 )
        local hs3 = display.newText( group, t.highscoreCopter,positionX[t.num3],positionY[t.num3]+140,"LobsterTwo-Regular",40 )
        hs3:setFillColor( 0 )
    end

    if user.highScoreMinion == 0 then 
        local hsText4 = display.newText( group, "Play",positionX[t.num4],positionY[t.num4]+130,"BebasNeue",50 )
        hsText4:setFillColor(1,0,0)
     else
        local hsText4 = display.newText( group, "High Score",positionX[t.num4],positionY[t.num4]+105,"LobsterTwo-Regular",30 )
        hsText4:setFillColor( 0 )
        local hs4 = display.newText( group, user.highScoreMinion,positionX[t.num4],positionY[t.num4]+140,"LobsterTwo-Regular",40 )
        hs4:setFillColor( 0 )
    end
end

    
    local rect1 = display.newImage( group, "assets/Rect.png",positionX[t.num1],positionY[t.num1]+120)
    local rect2 = display.newImage( group, "assets/Rect.png",positionX[t.num2],positionY[t.num2]+120)
    local rect3 = display.newImage( group, "assets/Rect.png",positionX[t.num3],positionY[t.num3]+120)
    local rect4 = display.newImage( group, "assets/Rect.png",positionX[t.num4],positionY[t.num4]+120)

    local btn1 = display.newImage( group, "assets/iconoCat.png",positionX[t.num1],positionY[t.num1])
    local btn2 = display.newImage( group, "assets/iconDoors.png", positionX[t.num2],positionY[t.num2] )
	local btn3 = display.newImage( group, "assets/iconCopter.png", positionX[t.num3],positionY[t.num3])
    local btn4 = display.newImage( group, "assets/iconCocos.png", positionX[t.num4],positionY[t.num4] )
    initialScoreText()


    function btn1:tap()

        analytics.logEvent( "LaserCatSession" )
        composer.gotoScene( "gamein" )
    end
    
    btn1:addEventListener("tap",btn1)

    
	

    function btn2:tap()
        analytics.logEvent( "DoorsSession" )
        composer.gotoScene( "EndlessH" )
    end
    
    btn2:addEventListener("tap",btn2)

    
	

    function btn3:tap()
        analytics.logEvent( "CopterSession" )
        composer.gotoScene( "game" )
    end
    
    btn3:addEventListener("tap",btn3)

    function btn4:tap()
        analytics.logEvent( "CoconutSession" )
        composer.gotoScene( "juegoTOA" )
    end
    
    btn4:addEventListener("tap",btn4)

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

	local homeBtn = widget.newButton
		{
		    defaultFile="assets/home.png",
		    overFile="assets/home_2.png",
		    onRelease = goHome,
		    parent = group,
		    height = 70,
		    width = 70,
		}

		homeBtn.x = 50
		homeBtn.y = bottomMarg-50

	group:insert( homeBtn )
	group:insert( soundBtn )


end

function scene:show( event )
	group = self.view


end


function scene:hide( event )
	group = self.view
	
	audio.pause(intro)

	composer.removeScene( "menu2" )

end


function scene:destroy( event )
	group = self.view
display.remove( soundBtn )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene