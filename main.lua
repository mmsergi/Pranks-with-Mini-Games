display.setStatusBar( display.HiddenStatusBar )

composer = require "composer"
json = require "json" 
ads = require "ads" 
widget = require "widget" 
analytics = require "analytics" 
AdBuddiz = require "plugin.adbuddiz"
gameNetwork = require "gameNetwork"
GPGS = require "GPGS"
translations = require "translations"

bannerretry = "ca-app-pub-1709584335667681/2761590251"
bannersimulator = "ca-app-pub-1709584335667681/4238323453"
interstitialstart = "ca-app-pub-1709584335667681/5715056650"
interstitialretry = "ca-app-pub-1709584335667681/8668523059"

ads.init( "admob", interstitialstart, adListener ) --Admob

AdBuddiz.setAndroidPublisherKey( "260ddaa0-671b-4d8f-bf0c-769cb0b6ad9e" ) --Adbuddiz
AdBuddiz.cacheAds()  

analytics.init( "" ) --Flurry

cx, cy = display.contentCenterX, display.contentCenterY
_W, _H = display.contentWidth, display.contentHeight 
leftMarg = display.screenOriginX
rightMarg = display.contentWidth - display.screenOriginX
topMarg = display.screenOriginY
bottomMarg = display.contentHeight - display.screenOriginY

splash = display.newImage("assets/splash.png", cx, cy)

local function adListener( event )
    -- The 'event' table includes:
    -- event.name: string value of "adsRequest"
    -- event.response: message from the ad provider about the status of this request
    -- event.phase: string value of "loaded", "shown", or "refresh"
    -- event.type: string value of "banner" or "interstitial"
    -- event.isError: boolean true or false

    if (event.isError) then

        local msg = event.response
        print("Error, no se puede cargar el anuncio", msg)

        if (AdBuddiz.isReadyToShowAd()) then --si esta preparado el anuncio
             AdBuddiz.showAd()
        else  
            --mostrar un anuncio propio 
        end   

    elseif (event.phase == "loaded") then
        print("Anuncio cargado Admob")
    elseif (event.phase == "shown") then
        print("Anuncio visto Admob")
    end

end

function IAPlistener(event)

    local transaction = event.transaction

    if ( transaction.state == "purchased" ) then
        local t = loadTable( "settings.json" )
        t.ads = false
        saveTable(t, "settings.json")
    end

     store.finishTransaction( event.transaction )
end

function showGameAd()
    if (AdBuddiz.isReadyToShowAd()) then
        AdBuddiz.showAd()
    else
        ads.show( "interstitial", { x=display.screenOriginX, y=display.screenOriginY, appId=interstitialstart} )
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

local t = loadTable( "settings.json" )
	
	if t == nil then 
	    local settings = {}
        settings.user = "player01"
	     settings.highscore = 0
        settings.lastscore = 0
        settings.highscoreCopter = 0
        settings.lastscoreCopter = 0
        settings.coins = 0
        settings.unlocked = 0
        settings.music = true
	    saveTable(settings, "settings.json")
	end


local function splashView()
    splash:removeSelf( )
    composer.gotoScene( "menu" )
end

local function ad()
    ads.show( "interstitial", { x=display.screenOriginX, y=display.screenOriginY, appId=interstitialstart} )
end



--timer.performWithDelay(900, splashView)
timer.performWithDelay(900, splashView)
timer.performWithDelay(1800, ad)

options = {
   width = 50,
   height = 33,
   numFrames = 2
}

optionsc = {
   width = 20,
   height = 20,
   numFrames = 3
}

sheet = graphics.newImageSheet( "assets2/sprite.png", options )
sheetc = graphics.newImageSheet( "assets2/coin_opt.png", optionsc )

sequenceData =
{
    name="fly",
    start=1,
    count=2,
    time=200,
}

sequenceDataCoin =
{
    name="rotate",
    start=1,
    count=3,
    time=500,
    loopDirection="bounce",
}