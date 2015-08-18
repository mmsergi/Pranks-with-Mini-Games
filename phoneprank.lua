local scene = composer.newScene()

cx, cy = display.contentCenterX, display.contentCenterY

local ring = audio.loadSound( "phoneprankassets/ring.mp3" )

function trans1()
	transi1 = transition.to( aura, { time=500, xScale=1.5, yScale=1.5, transition=easing.outQuad , onComplete=trans2} )
end

function trans2()
	transi2 = transition.to( aura, { time=500, xScale=2, yScale=2, transition=easing.inQuad , onComplete=trans1} )
end


function scene:create( event )
	group = self.view

	bckg = display.newRect( group, cx, cy + 128, 480, 800 )
	bckg:setFillColor( 122,122,122,0.15 )

	local nameOptions = 
	{
	    parent = group,
	    text = event.params.name,
	    y = cy/8,
	    font = native.systemFontBold,   
	    fontSize = 32,
	    align = "left"  --new alignment parameter
	}
	name = display.newText( nameOptions )
	name.anchorX, name.x = 0, 45

	number = display.newText( group, "+1 005172232045", cx/2 + 50, cy/8 + 40,  native.systemFont, 32 )

	aura = display.newImage(group, "phoneprankassets/aura.png", cx, cy/2 + 200 )
	photo = display.newImage(group, event.params.image, cx, cy/2 + 200 )

	bluebar = display.newImage(group, "phoneprankassets/bluebar.png", cx, cy/3 + 20 )


	trans1()

	accept = display.newImage(group, "phoneprankassets/accept.png", cx - cx/2, cy + 300 )
	function accept:tap()
		audio.stop(channel)
		bluebar:removeSelf( )
		greenbar = display.newImage(group, "phoneprankassets/greenbar.png", cx, cy/3 + 20 )
		transition.to( accept, { time=300, x=-150, transition=easing.outQuad} )
		transition.cancel( transi1 )
		transition.cancel( transi2 )
		aura:removeSelf( )
		transition.to( decline, { time=500, x=cx, transition=easing.outQuad} )

	end
	accept:addEventListener( "tap", accept )


	decline = display.newImage(group, "phoneprankassets/decline.png", cx + cx/2, cy + 300 )
	function decline:tap()
		audio.stop(channel)
		transition.cancel( transi1 )
		transition.cancel( transi2 )
		composer.removeScene( "phoneprank" )
		composer.gotoScene( "menuphone" )

	end
	decline:addEventListener( "tap", decline )


	audio.setVolume(1)
	channel = audio.play( ring, {loops=-1})

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