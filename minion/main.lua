---------------------------------------------------------------------------------
-- Game Analytics for Corona SDK: Composer example 
---------------------------------------------------------------------------------
local composer = require "composer"
local analytics = require( "analytics" )
cx=display.contentCenterX
cy=display.contentCenterY
_W = display.contentWidth
_H = display.contentHeight
leftMarg = display.screenOriginX
rightMarg = display.contentWidth - display.screenOriginX
topMarg = display.screenOriginY
bottomMarg = display.contentHeight - display.screenOriginY
----Game Services


----Game Services

local gameNetwork = require( "gameNetwork" )
local playerName

local function loadLocalPlayerCallback( event )
   playerName = event.data.alias
   saveSettings()  --save player data locally using your own "saveSettings()" function
end

local function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
   return true
end

local function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=false, listener=gameNetworkLoginCallback } )

  if gameNetwork.request("isConnected")then print("------------------------------------user logged--------------------------------------") end

end

 function gameNetworkSetup()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.init( "google", gpgsInitCallback )
   else
      gameNetwork.init( "gamecenter", gameNetworkLoginCallback )
   end
end

------HANDLE SYSTEM EVENTS------
local function systemEvents( event )
   print("systemEvent " .. event.type)
   if ( event.type == "applicationSuspend" ) then
      print( "suspending..........................." )
   elseif ( event.type == "applicationResume" ) then
      print( "resuming............................." )
   elseif ( event.type == "applicationExit" ) then
      print( "exiting.............................." )
   elseif ( event.type == "applicationStart" ) then
      gameNetworkSetup()  --login to the network here
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )









--Publicidad Admob

local ads = require( "ads" )
   
local adNetwork = "admob"

local function adListener( event )
    -- The 'event' table includes:
    -- event.name: string value of "adsRequest"
    -- event.response: message from the ad provider about the status of this request
    -- event.phase: string value of "loaded", "shown", or "refresh"
    -- event.type: string value of "banner" or "interstitial"
    -- event.isError: boolean true or false

 if ( event.isError ) then
        local msg = event.response
        print( "Error, no se puede cargar el anuncio!!!!", msg )
             AdBuddiz.showAd()

    elseif ( event.phase == "loaded" ) then
        print( "Anuncio cargado Admob" )
    elseif ( event.phase == "shown" ) then
        print("Anuncio visto Admob")
    end

end

ads.init( "admob", "ca-app-pub-3836849703819703/5421353678",adListener )

ads.load( "interstitial", { appId="ca-app-pub-3836849703819703/5421353678" } )--inicio


--Publicidad AdBudizz
local AdBuddiz = require "plugin.adbuddiz"
  AdBuddiz.setAndroidPublisherKey( "82c5b745-f602-47ab-9fea-47c0dd081efa" )
  --AdBuddiz.setIOSPublisherKey( "TEST_PUBLISHER_KEY_IOS" )
  AdBuddiz.cacheAds()

------FLURRY
local analytics = require( "analytics" )

-- initialize with proper API key corresponding to your application
analytics.init( "VTSN4S2ZT2R2HY5YKT5F" )

-- log events
--analytics.logEvent( "Event" )




json = require('json')

-- Save specified value to specified encrypted file
function saveValue(strFilename, strValue)
 
  local theFile = strFilename
  local theValue = strValue
  local path = system.pathForFile( theFile, system.DocumentsDirectory )
 
  local file = io.open( path, "w+" )
  if file then -- If the file exists, then continue. Another way to read this line is 'if file == true then'.
    file:write(theValue) -- This line will write the contents of the table to the .json file.
    io.close(file) -- After we are done with the file, we close the file.
    return true -- If everything was successful, then return true
  end
end

-- Load specified encrypted file, or create new file if it does not exist
function loadValue(strFilename)
  local theFile = strFilename
  local path = system.pathForFile( theFile, system.DocumentsDirectory )
  local file = io.open( path, "r" )
 
  if file then -- If file exists, continue. Another way to read this line is 'if file == true then'.
    local contents = file:read( "*a" ) -- read all contents of file into a string
    io.close( file ) -- Since we are done with the file, close it.
    return contents -- Return the table with the JSON contents
  else
    return '' -- Return nothing
  end
end

user = json.decode(loadValue('user.txt'))

oldScore=json.decode(loadValue('scorefile.txt'))




--Valores iniciales de la base de datos

if not user then
  _G.user = {
    galletas = 0, -- stores total number of coins
    vidas=0,
    level = 1, -- stores user level
    session=0,
    musicOn=true,
    actualScore=0,
    playerName=""
  }end
---------------------------------------------------------------
--Valores de siguientes actualizaciones
--EJEMPLO:

--if not user.musicOn then
--_G.user.musicOn=true
--end
---------------------------------------------------------------


if not user.highScore then 
  if oldScore then
  _G.user.highScore=oldScore
elseif not oldScore then
  _G.user.highScore=0
end
end

if not user.actualgalletas then
 _G.user.actualgalletas=0
end

if not user.flamaPosition then
 _G.user.flamaPosition=1
end
if not user.flamaNum then
 _G.user.flamaNum=0
end
if not user.tuto then
 _G.user.tuto=0
end
  saveValue('user.txt', json.encode(user))

exitFlag=false
local function onSystemEvent( event )
if event.type == "applicationExit" then

exitFlag=true
  if exitFlag then
  local exit = display.newImage("exit.png", cx, cy )  
timer.performWithDelay( 1500, function() AdBuddiz.showAd() end )
local function Adbuddizlistener( event ) 
    
    if event.value == "didClick" then
      print( "didClick" )
      native.requestExit()
      Runtime:removeEventListener( "AdBuddizEvent", Adbuddizlistener )
    end
    if event.value == "didHideAd" then
      print( "didHideAd" )
      native.requestExit()
      Runtime:removeEventListener( "AdBuddizEvent", Adbuddizlistener )
    end
    if event.value == "didFailToShowAd" then
      print( "didFailToShowAd - "..event.detail )
      native.requestExit()
      Runtime:removeEventListener( "AdBuddizEvent", Adbuddizlistener )
     end
  end
  Runtime:addEventListener( "AdBuddizEvent", Adbuddizlistener )
  end

end
end

--Runtime:addEventListener( "system", onSystemEvent )





--local GA = require ( "plugin.gameanalytics" )
---------------------------------------------------------------------------------
-- Setup storyboard
---------------------------------------------------------------------------------
composer.gotoScene( "Inicio")

---------------------------------------------------------------------------------
-- Set Game Analytics properties and initialize it.
---------------------------------------------------------------------------------
-- Important notice: Initialization of Game Analytics should always happend after 
-- you setup composer and call composer.gotoScene
---------------------------------------------------------------------------------


--GA.submitSystemInfo = true
--GA.init ( {
  --  game_key = '015c8631fafe16a057f6a1488d9c0487',
  --  secret_key = '80d4a4ad44e243d20c726f5d58a525eeb9ec1569',
 --   build_name = "1.0",
 --} )

--local gameNetwork = require( "gameNetwork" )
--local playerName

--local function loadLocalPlayerCallback( event )
 --  playerName = event.data.alias
 --  saveSettings()  --save player data locally using your own "saveSettings()" function
--end

--local function gameNetworkLoginCallback( event )
 --  gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
--   return true
--end

--local function gpgsInitCallback( event )
--   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
--end

--local function gameNetworkSetup()
 --  if ( system.getInfo("platformName") == "Android" ) then
  --    gameNetwork.init( "google", gpgsInitCallback )
 --  else
  --    gameNetwork.init( "gamecenter", gameNetworkLoginCallback )
  -- end
--end

------HANDLE SYSTEM EVENTS------
--local function systemEvents( event )
  -- print("systemEvent " .. event.type)
  -- if ( event.type == "applicationSuspend" ) then
  --    print( "suspending..........................." )
  -- elseif ( event.type == "applicationResume" ) then
   --   print( "resuming............................." )
  -- elseif ( event.type == "applicationExit" ) then
  --    print( "exiting.............................." )
  -- elseif ( event.type == "applicationStart" ) then
   --   gameNetworkSetup()  --login to the network here
  -- end
  -- return true
--end

--Runtime:addEventListener( "system", systemEvents )


