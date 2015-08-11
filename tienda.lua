local group

local scene = composer.newScene()

local t = loadTable( "settings.json" )

function vungleAdListener( event )
  if ( event.type == "adStart" and event.isError ) then
    -- Ad has not finished caching and will not play
  end
  if ( event.type == "adStart" and not event.isError ) then
    -- Ad will play
  end
  if ( event.type == "cachedAdAvailable" ) then
    -- Ad has finished caching and is ready to play
  end
  if ( event.type == "adView" ) then
    t.coins = t.coins + 10
    coinsText.text = t.coins
    saveTable(t, "settings.json")
  end
  if ( event.type == "adEnd" ) then
    -- The ad experience has been closed- this
    -- is a good place to resume your app
  end
end

local function playVideoAd()
	ads.show( "incentivized" )
end

local function goBack()
	composer.gotoScene( "menu" )
	composer.removeScene( "tienda" )
end

function scene:create( event )
	group = self.view

	ads.init( "vungle", "com.seja.liedetector", vungleAdListener) -- Vungle
	ads:setCurrentProvider("vungle")
	
	background = display.newImage( group, "assets/fondoMenu.png", cx, cy )

	videoBtn = widget.newButton{
	    width = 300,
	    height = 150,
	    defaultFile = "assets/btnDef.png",
	    overFile = "assets/btnRel.png",
	    onRelease = playVideoAd
	}
	videoBtn.x = display.contentWidth/2 
	videoBtn.y = 200

	postBtn = widget.newButton{
	    width = 300,
	    height = 150,
	    defaultFile = "assets/btnDef.png",
	    overFile = "assets/btnRel.png",
	    onRelease = postFB
	}
	postBtn.x = display.contentWidth/2 
	postBtn.y = 400

	backBtn = widget.newButton
	{
	    defaultFile="assets/back.png",
	    overFile="assets/back_2.png",
	    onRelease = goBack
	}

	backBtn.x = leftMarg+50
	backBtn.y = bottomMarg-50

	local hud = require( "hud" )
    group:insert(hudCoins)
    group:insert(coins)
    group:insert(coinsText)
	showNumCoins(coinsText, numCoins, 1)

	group:insert(videoBtn)
	group:insert(postBtn)
	group:insert(backBtn)

end

function scene:show( event )
	group = self.view

end

function scene:hide( event )
	group = self.view
	
end

function scene:destroy( event )
	group = self.view
	ads:setCurrentProvider("admob")
	package.loaded["hud"] = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene