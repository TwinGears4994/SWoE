--[[
Brian T.Wilcox
twingears@gmail.com
]]      

reVision = "Beta.4.65"
love.graphics.setDefaultFilter("nearest", "nearest")
love.window.setFullscreen( true, "desktop" )  --DEFAULT true RUNNING MODE FOR THIS EDUCATIONAL GAME, HAS LAST SAY
tPortHole = {}   				--FOR OUR SCREEN SIZES TO BE MORE PORTABLE
love.window.setTitle("Seeing Without Eyes - " .. reVision)
love.window.display = 1
--              *** GLOBAL STORAGE ***
dtCounter = love.timer.getDelta()   --can't seem to work dt without this one liner
tColours = {}           --NESTED with loadSoundColours() { {TEXT, COLOUR TABLE, SOUND }, }
tShapes = {}            --NESTED with loadSoundShapes()
tSndMain = {}           --NESTED with loadSoundMain()
tSndIntro = {}          --NESTED with loadSoundIntro()
keyboardTRIGGER = false
keyboardTUTOR = false   --CALIBRATE COLOUR WITH THE RESET CARD OPTION LIKE A BUILT IN TUTOR
waitTime = 1            --delay the first words tSndIntro[ speakIndex ][ 2 ]
dtCounter = 1           --delay on start--timeStart = love.timer.getDelta()    --need to record time to see how fast it was if correct for bonus...
iSpeak = 1
tCompPredicted = {} 		-- pColour ="pCOLOUR", pShape ="pSHAPE", pEoGCard =false, pEoGturns =turnNumEoG, pEoGErrs =turnNumERREoG, pCturn ="pCturn", pSturn ="pSturn" }
tUserPredicted = {}
tCurrentCard = {} 			-- c1 ="", c2 ="", c3 ="", c4 ="", c5 ="", cIndex =0, shape ="SHAPE", sIndex =0, doneCHOICE =false, rndQc1c5 =3 }
tColour5 = {}           --STORE SHUFFLED QUESTION FOR dt QUESTION "IS THE COLOUR?"
tScreenCard = { shape ="SHAPE", colour="COLOUR", tColour ={1,1,1,1},    --LOADED UP FOR DRAW TO PUT GRAPHICS ON THE SCREEN
  mode ="fill", sWidth =0, sHeight =0, radius =0,
  xStart =0, yStart =0, x2=0, y2=0, x3=0, y3=0, x4=0, y4=0,
  scaleX=0, scaleY=0, alpha =1}
tUserScore = {}
tCompScore = {}
tCorFdBk = { bCOLOUR = false, bSHAPE = false, colour = "", shape = "" }     --ONLY COLOUR NEEDED BUT SHAPE IF USED SCREWS UP THAT STATE TALKING/TIMING
--TO BE POPULATED FOR USER WHEN CHANGING SCORE NAME ALSO FROM FILE & #1 WOULD BE DEFAULT STARTING POINT FOR USER - IDIOCRACY FUNNY
tListNames = { "A-Z","NOT-SURE","PRAY-RAIN" }
tScoreBoard = { {numEEggs = 0, EoGColour = "White", EoGShape = "Heart", cName = "Orange", name = "COMP-BASE-LINE", numBRCards = 0, numBRSymbs = 0, numBRTurns = 1, numCards = 2, numColours = 6.5, numCor = 6.5, numErr = 7.25, numScore = 21590, numShapes = 2, numSymbs = 0, numTurns = 20, sound = "MPC-BEAT", tColourName = {1, 0.5, 0, 1}, tEoGcolour = {1, 1, 1, 1} },
{numEEggs = 0, EoGColour = "Green", EoGShape = "Heart", cName = "Blue", name = "BRIAN", numBRCards = 0, numBRSymbs = 0, numBRTurns = 5, numCards = 5, numColours = 8.5, numCor = 10.5, numErr = 7.25, numScore = 3100, numShapes = 7, numSymbs = 0, numTurns = 20, sound = "MPC-BEAT", tColourName = {0, 0, 1, 1}, tEoGcolour = {0, 1, 0, 1} },
{numEEggs = 0, EoGColour = "Green", EoGShape = "Heart", cName = "Green", name = "BRIAN", numBRCards = 0, numBRSymbs = 0, numBRTurns = 1, numCards = 0, numColours = 1, numCor = 1.5, numErr = 9.25, numScore = 120, numShapes = 0.5, numSymbs = 0, numTurns = 20, sound = "MPC-BEAT", tColourName = {0, 0, 1, 1}, tEoGcolour = {0, 1, 0, 1} }
 }