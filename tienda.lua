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
    totalcoins.text = t.coins.." C"
  end
  if ( event.type == "adEnd" ) then
    -- The ad experience has been closed- this
    -- is a good place to resume your app
  end
end

local postOptions = {
    service = "facebook",
    message = "Check out this photo!",
    listener = eventListener,
    image = {
        { filename = "assets/fondoMenu.png", baseDir = system.ResourceDirectory },
        { filename = "assets/btnDef.png", baseDir = system.ResourceDirectory }
    },
    url = "http://coronalabs.com"
}

ads.init( "vungle", vungleID, vungleAdListener) -- Vungle

function playVideoAd()
	ads.show( "incentivized" )
end

function postFB()
	native.showPopup( "social", options )
end

function scene:create( event )
	group = self.view
	
	background = display.newImage( group, "assets/fondoMenu.png", cx, cy )

	totalcoins = display.newText(group, t.coins.." C", display.contentWidth - 75, 25, native.systemFontBold, 28)
	totalcoins:setFillColor( 0, 0, 0 )

	videoBtn = widget.newButton{
	    width = 300,
	    height = 150,
	    defaultFile = "assets/btnDef.png",
	    overFile = "assets/btnRel.png",
	    onRelease = playVideoAd
	}
	videoBtn.x = display.contentWidth/2 
	videoBtn.y = 400

	postBtn = widget.newButton{
	    width = 300,
	    height = 150,
	    defaultFile = "assets/btnDef.png",
	    overFile = "assets/btnRel.png",
	    onRelease = postFB
	}
	postBtn.x = display.contentWidth/2 
	postBtn.y = 600

end

function scene:show( event )
	group = self.view

end


function scene:hide( event )
	group = self.view
	

end


function scene:destroy( event )
	group = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene