----Game Services

local gameNetwork = require( "gameNetwork" )
local playerName

 function loadLocalPlayerCallback( event )
   playerName = event.data.alias
   saveSettings()  --save player data locally using your own "saveSettings()" function
   showLeaderboards( event )
end

         function saveSettings()--sirve para guardar en texto el nombre del jugador
         user.playerName = playerName
             -- guarda datos
             saveValue('user.txt', json.encode(user))
             -- recarga datos
             user = json.decode(loadValue('user.txt'))
         end

 function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )

   return true
end

 function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )

  if gameNetwork.request("isConnected")then print("------------------------------------user logged--------------------------------------") 
      showLeaderboards( event )
    end
end

print("GGPS cargado")