local scene = composer.newScene()


function scene:create( event )
	group = self.view

	mayShowAd()

	bckg = display.newRect( group, cx, cy, 480, 800 )
	bckg:setFillColor( 122,122,122,0.15 )


	name = display.newText( group, translations["Receive a call from:"][language], cx, cy/8,  native.systemFont, 32 )
	--number = display.newText( group, "+1 005172232045", cx/2 + 50, cy/8 + 40,  native.systemFont, 32 )

	--aura = display.newImage(group, "aura.png", cx, cy/2 + 200 )
	char1 = display.newImage(group, "phoneprankassets/bob.png", cx/2, cy - 200)
	char1.width, char1.height = 150, 150
	function char1:tap()
		local options = {
    		effect = "fade",
    		time = 500,
    		params = { name="Sponge Bob", image="phoneprankassets/bob.png" }
		}
		composer.gotoScene( "phoneprank", options )
	end
	char1:addEventListener( "tap", char1 )

	char2 = display.newImage(group, "phoneprankassets/santa.png", cx + cx/2, cy - 200)
	char2.width, char2.height = 150, 150
	function char2:tap()
		local options = {
    		effect = "fade",
    		time = 500,
    		params = { name="Santa Claus", image="phoneprankassets/santa.png" }
		}
		composer.gotoScene( "phoneprank", options )
	end
	char2:addEventListener( "tap", char2 )

	char3 = display.newImage(group, "phoneprankassets/iron.png", cx/2, cy)
	char3.width, char3.height = 150, 150
	function char3:tap()
		local options = {
    		effect = "fade",
    		time = 500,
    		params = { name="Iron Man", image="phoneprankassets/iron.png" }
		}
		composer.gotoScene( "phoneprank", options )
	end
	char3:addEventListener( "tap", char3 )

	char4 = display.newImage(group, "phoneprankassets/scarlett.png", cx + cx/2, cy)
	char4.width, char4.height = 150, 150
	function char4:tap()
		local options = {
    		effect = "fade",
    		time = 500,
    		params = { name="Scarlett Johansson", image="phoneprankassets/scarlett.png" }
		}
		composer.gotoScene( "phoneprank", options )
	end
	char4:addEventListener( "tap", char4 )

	char5 = display.newImage(group, "phoneprankassets/obama.png", cx/2, cy + 200)
	char5.width, char5.height = 150, 150
	function char5:tap()
		local options = {
    		effect = "fade",
    		time = 500,
    		params = { name="Barack Obama", image="phoneprankassets/obama.png" }
		}
		composer.gotoScene( "phoneprank", options )
	end
	char5:addEventListener( "tap", char5 )

	char6 = display.newImage(group, "phoneprankassets/will.png", cx + cx/2, cy + 200)
	char6.width, char6.height = 150, 150
	function char6:tap()
		local options = {
    		effect = "fade",
    		time = 500,
    		params = { name="Will Smith", image="phoneprankassets/will.png" }
		}
		composer.gotoScene( "phoneprank", options )
	end
	char6:addEventListener( "tap", char6 )

	home = display.newImage(group, "assets/home.png", cx, cy + 330 )
	home.width=70
    home.height=70

	function home:tap()
		composer.gotoScene( "menu" )
	end

	home:addEventListener( "tap", home )

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