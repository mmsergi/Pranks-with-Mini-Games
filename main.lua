--PUSH NOTIFICATIONS

-- This function gets called when the user opens a notification or one is received when the app is open and active.
-- Change the code below to fit your app's needs.
function DidReceiveRemoteNotification(message, additionalData, isActive)
    if (additionalData.coins) then
      native.showAlert( "Congratulations!", "You've received "..additionalData.coins.." coins", { "OK" } )
      local t = loadTable( "settings.json" )
      t.coins = t.coins + additionalData.coins
      saveTable(t, "settings.json")
    end
end

local OneSignal = require("plugin.OneSignal")
-- Uncomment SetLogLevel to debug issues.
-- OneSignal.SetLogLevel(4, 4)
OneSignal.Init("448fb2a0-466f-11e5-9bef-63a623365162", "561514406398", DidReceiveRemoteNotification)

----------------------------------------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

composer = require "composer"
json = require "json" 
ads = require "ads" 
widget = require "widget" 
analytics = require "analytics" 
AdBuddiz = require "plugin.adbuddiz"
translations = require "translations"

-- values to unlock jokes
unlock1 = 0
unlock2 = 50
unlock3 = 100

firstAd = true
unlockedFlag=false

function destroyHUD()
  if tmrCoins1 then
    timer.cancel(tmrCoins1)
  end

  if tmrCoins2 then
    timer.cancel(tmrCoins2)
  end   
  package.loaded["hud"] = nil 
end  

local function adListener(event)
  if (event.phase == "shown" and firstAd==true) then
    firstAd = false
    print("firstAd mostrado y cerrado")
  end
end

interstitial = "ca-app-pub-1709584335667681/2756526250"

ads.init( "admob", interstitial, adListener) --Admob

AdBuddiz.setAndroidPublisherKey( "c736441f-6336-4189-ab00-a01fdc839f41" ) --Adbuddiz
AdBuddiz.cacheAds()  

analytics.init( "9YJ6DSJRH96YY6Z7GN53" ) --Flurry

cx, cy = display.contentCenterX, display.contentCenterY
_W, _H = display.contentWidth, display.contentHeight 
leftMarg = display.screenOriginX
rightMarg = display.contentWidth - display.screenOriginX
topMarg = display.screenOriginY
bottomMarg = display.contentHeight - display.screenOriginY

splash = display.newImage("assets/splash.png", cx, cy)

coinsData = { width=68, height=63, numFrames=10,}
coinsSheet = graphics.newImageSheet( "assets/coins.png", coinsData )    
coinsSequence = {
  { name = "estatica", start=1, count=1, time=8500,},
  { name = "dinamica", start=1, count=10, time=2500,},} 

function showMoreGamesAd()
    local currScene = composer.getSceneName( "current" )
    composer.removeScene( currScene )
    composer.removeScene( "juegoTOA")
    composer.removeScene( "EndlessH")
    composer.removeScene( "game")
    composer.removeScene( "gamein")
    analytics.logEvent( "MoreGamesClick" )
   
    destroyHUD()
    composer.removeScene( "stats")
    composer.removeScene( "Retry")
    composer.removeScene( "Retry_Minion")
    composer.removeScene( "scorelose" )
     composer.gotoScene( "menu2" )
end

function mayShowAd()
  print("admob ad 20%")
  if math.random() > .8 and firstAd == false then
    ads.show( "interstitial", {appId=interstitial} )
    print("ad shown")
  end
end

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

if not user then
  _G.user = {
    galletas = 0, 
    vidas=0,
    level = 1, 
    session=0,
    musicOn=true,
    highScore=0,
    highScoreMinion=0,
    actualgalletas=0,
    flamaPosition=1,
    actualScore=0,
    flamaNum=0,
    tuto=0,
    playerName=""
  }end

function saveTable(t, filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

function loadTable(filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
         local contents = file:read( "*a" )
         myTable = json.decode( contents )
         io.close( file )
         return myTable 
    end
    return nil
end

function checkLocks(ta)
  initalUnlocked = ta.unlocked
  if ta.coins>=(unlock1) then
    ta.unlocked=1
  end

  if ta.coins>=(unlock2) then
    ta.unlocked=2
  end

  if ta.coins>=(unlock3) then
    ta.unlocked=3
  end

  if ((ta.unlocked-initalUnlocked) > 0 and ta.unlocked~=1) then
      analytics.logEvent( "unlocked", { number=ta.unlocked } )
      composer.showOverlay( "unlockedPopup", {effect="zoomOutIn", isModal = true})
  end

  saveTable(ta, "settings.json")
end

local t = loadTable( "settings.json" )
	
	if t == nil then 
	    local settings = {}
	    settings.highscoreLaser = 0
        settings.highscoreCopter = 0
        settings.coins = 0
        settings.unlocked = 0
        settings.music = true
        settings.RandomizeOnceDone = false
        settings.num1 = 1
        settings.num2 = 2
        settings.num3 = 3
        settings.num4 = 4
        settings.facebook = true
        settings.install = true
	    saveTable(settings, "settings.json")
	end

local function splashView()
    splash:removeSelf( )
    composer.gotoScene( "menu" )
end

timer.performWithDelay(1, splashView)

options = {
   width = 50,
   height = 33,
   numFrames = 2
}

sheet = graphics.newImageSheet( "assets2/sprite.png", options )

sequenceData =
{
    name="fly",
    start=1,
    count=2,
    time=200,
}

-- Called when a key event has been received
local function onKeyEvent( event )

  if ( event.keyName == "back" ) then

    local currentScene = composer.getSceneName("current")
    print(currentScene)

    if (currentScene == "menu2") then
      composer.removeScene( currentScene )
      composer.gotoScene( "menu" )
      return true
    elseif (currentScene == "lieDetector" or currentScene == "laser" or currentScene == "menuphone") then 
      composer.removeScene( currentScene )
      composer.gotoScene( "menu" )
      return true
    elseif (currentScene == "stats" or currentScene == "scorelose" or currentScene == "Retry" or currentScene == "Retry_Minion") then 
      composer.removeScene( currentScene )
      composer.gotoScene( "menu2" )
      return true
    end

  end

  -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
  -- This lets the operating system execute its default handling of the key
  return false
end

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )