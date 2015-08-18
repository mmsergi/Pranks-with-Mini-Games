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
    saveTable(t, "settings.json")
    coinsText.text = t.coins
  end
  if ( event.type == "adEnd" ) then
    -- The ad experience has been closed- this
    -- is a good place to resume your app
  end
end

local function playVideoAd()
	analytics.logEvent( "VideoAdClick" )
	ads.show( "incentivized" )
end

local function goBack()
	composer.gotoScene( "menu" )
	composer.removeScene( "tienda" )
end

local function installAd()
	analytics.logEvent( "InstallAdClick" )
	if math.random()>.5 then
  		system.openURL( "https://play.google.com/store/apps/details?id=com.masah.adventuresinside" )
  	else
  		system.openURL( "https://play.google.com/store/apps/details?id=com.wavepps.frozenbubbles" )
  	end

  	t.coins = t.coins + 30
    saveTable(t, "settings.json")
    coinsText.text = t.coins
end

local function freeGame()
    analytics.logEvent( "ShopFreeGameClick" )
    AdBuddiz.showAd()
end

local function likeFb()
	analytics.logEvent( "likeFacebookClick" )
	system.openURL( "https://www.facebook.com/sejaapps" )
	t.coins = t.coins + 5
	t.facebook = false
    saveTable(t, "settings.json")
    coinsText.text = t.coins
	likeBtn:removeSelf( )
end

function scene:create( event )
	group = self.view

	ads.init( "vungle", "com.seja.liedetector", vungleAdListener) -- Vungle
	ads:setCurrentProvider("vungle")
	
	background = display.newImage( group, "assets/shopbckg.png", cx, cy )
	background.alpha = 0.9

	videoBtn = widget.newButton{

	    defaultFile = "assets/videoBtn.png",
	    onRelease = playVideoAd
	}
	videoBtn.x = display.contentWidth/2 
	videoBtn.y = 250

	installBtn = widget.newButton{

	    defaultFile = "assets/installBtn.png",
	    onRelease = installAd
	}
	installBtn.x = display.contentWidth/2 
	installBtn.y = 400

	gameBtn = widget.newButton{

	    defaultFile = "assets/freegame.png",
	    onRelease = freeGame
	}
	gameBtn.x = display.contentWidth/2 
	gameBtn.y = 550

	if t.facebook then

		likeBtn = widget.newButton{

		    defaultFile = "assets/like.png",
		    onRelease = likeFb
		}
		likeBtn.x = display.contentWidth/2 + 100
		likeBtn.y = 730

		group:insert(likeBtn)
	end

	backBtn = widget.newButton
	{
	    defaultFile="assets/home.png",
	    overFile="assets/home_2.png",
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
	group:insert(installBtn)
	group:insert(gameBtn)
	
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