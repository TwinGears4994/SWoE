--[[
Brian T.Wilcox UCc1-308
twingears@gmail.com
https://github.com/TwinGears4994/SWoE
2024-2025 Seeing Without Eyes - Solo Training
Colour calibration & Shape testing; blind folded with MINDFOLD or what ever one uses to block screen/room light fully is how i like to do this.
Colours & Shape are spoken as user selects what they feel is a match to what's on the screen.
Score in upper left corner, symbols will also appear in the same area which represent the COMP and USER
"End of Game" cards, currently Green Flower is my/the SYMBOL for USERS EoG card chosen.

NOTICE: Art folder/directory contain copyright art by Chuck, which is i Brian T.Wilcox UCc1-308 since the mid or late 1980's, which may ONLY be used within this source code/program archive supplied by myself. Again email above if needed...

NOTICE: NO-DOG-LATIN-USED-WITHIN-GNU-LICENSE, means this license has no current or commonly use CODE-SYNTAX-OF-LEGAL-CORRUPTION; thus can be applied Lawfully regardless of any FOREIGN-CORRUPTION;
For more information about GLOSSA/ASL, pg 665-666 of 17th Edition of "The Chicago Manual of Style", Section 11, Subsection 128 [ 11.128 ]
program(s) /source code is authors python code remake with Love2D code 2019-2025. with the exception of files in /fonts - that's not the authors creation.

LICENSE;
This source code is free software: file main.lua and files in source
folder/directory ending in .lua namely;
LIST FILES.lua

you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, version 3.
This source code is distributed in the hope that it will be useful,
but WITHOUT-ANY-WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS-FOR-A-PARTICULAR-PURPOSE. See the GNU General Public License for
more details.
You have received a copy of the GNU General Public License along with this
source code.

Inside the SWoE.love (actually an archive using zip) looks like this:
/fonts
/source/
/source/Art
/source/sounds
main.lua
conf.lua
ScoreBoard.csv
gpl-3.0.pdf
]]
math.randomseed( os.time() )
utf8 = require("utf8")

function love.load(arg)
  if arg[#arg] == "-debug" then         --debugger for ZeroBrane
    require("mobdebug").start()
  end
  require 'source.Filesystem'
  require 'source.Keyboard'
  require 'source.Joystick'
  require 'source.Shape'
  require 'source.Colour'
  require 'source.Constants'
  require 'source.Art'
  require 'source.Score'
  require 'source.Sound'
  require 'source.Players'
  require 'source.StateMachine'
  require 'source.Draw'
  require 'source.Memory'
  require 'source.SWoE'
  
  --POPULATE SOUND STORAGE CONTAINERS - 1st PART OF NEW BUILD DONE -- TESTED PERFECT!
  loadSoundColours()                    --AUTO LOAD { TEXT, COLOUR TABLE, SOUNDS } into tColours = {}
  loadSoundShapes()                     --AUTO LOAD SHAPES FOLDER SOUNDS into tShapes = {} 
  loadSoundMain()                       --tSndMain = {}
  loadSoundIntro()                      --tSndIntro = {}
  love.audio.setVolume(.7)  --.7
--  music:setVolume(.5)
--NEW SCOREBOARD SAVING AND LOADING OF FILE: .local/share/love/SWoE/ScoreBoard.csv
--  tListNames = removeDuplicateSBNames( tListNames ) --DEFAULT LIST FOR USER SCOREBOARD QUICK NAME SELECTION
  funcInject( tCompScore, "Score" ) --"Predict" OR "CurCard"  --tCompScore:reset()  --RUN LATER TO POPULATE / RESET
  funcInject( tUserScore, "Score" )         --tUserScore:reset()
  funcInject( tCompPredicted, "Predict" )   --tCompPredicted:reset()
  funcInject( tUserPredicted, "Predict" )   --tUserPredicted:reset()
  funcInject( tCurrentCard, "CurCard" )     --tCurrentCard:reset()
  funcInject( tPortHole, "PortHole" )       --tPortHole:reset()
  tPortHole:reset()                         --POPULATE VARIABLES
  funcInject( tScoreBoard, "SB" )           --SB NEEDS TO BE AFTER PORTHOLE       
  tScoreBoard:reset()
  -- *** FONT SETUP ***
  gameFontLarge = love.graphics.newFont( 'fonts/DejaVuSans-Bold.ttf', tPortHole.fontPixLarge )
  gameFontSmall = love.graphics.newFont( 'fonts/DejaVuSans-Bold.ttf', tPortHole.fontPixLarge )
  love.graphics.setFont( gameFontSmall )  --gameFontLarge
  --love.keyboard.setTextInput(true)
end

function love:update(dt)  -- *** TIMING FOR SPEECH LIVES HERE - NARRATOR CAN BE INTURUPTED :) ***
  dt = love.timer.getDelta()
  dtCounter = dtCounter + dt
  --LAYOUT THE SWITCHING MECHINISMS
  if tSM.curState == "CRANK-START" then            --PUT THE STATEMACHINE IN MOTION
    resetPlayers()
    tSM:aLfileCk()                  --NEW BOOL TO SETUP aLoop INDEX TO 1
  elseif tSM.idxLoop == 1 then          --1st aLoop
    aLoop()
  elseif tSM.idxLoop == 2 then  		--bLoop
    bLoop()
  elseif tSM.idxLoop == 3 then  		--cLoop
    cLoop()
  elseif tSM.idxLoop == 4 and dtCounter > waitTime then    --dLoop BR USER
    dLoop()
  elseif tSM.idxLoop == 5 then 			--and dtCounter > waitTime then    --eLoop BR COMP
    eLoop()
  elseif tSM.idxLoop == 6 then    	--fLoop SB AND EDIT-SB
    fLoop()
  elseif tSM.idxLoop == 7 then    	--fLoop REMOTE-VIEWING-OF-LCS-TA-STORY-TELLING OR LIVING BIBLE FOR LORDS AND LADIES, CURRENTLY JUST FILE PLACE HOLDERS - CHANGE OLD PYTHON CODE 1ST
    gLoop()
  end
end

function love:draw()  --drawSymbol()  drawCard() drawEoGSB() drawPerTurnSB() --USER ON TOP OF SCOREBOARD LIKE BEFORE, drawHighLightSB( i, _x, _y )
  --tDrawState = { "BLACKOUT","GUESS-EoG","Q1TURNS","Q2ERRORS","PER-TURN","EDIT-SB","SCOREBOARD" }
  if tSM.curDState == "BLACKOUT" then
    drawBlackOut()
  elseif tSM.curDState == "EDIT-SB" then
    local _x, _y = drawEoGSB()
    buildCard(  tUserPredicted.pColour, tUserPredicted.pShape, .7 )
    drawCard()    --DRAW BACKGROUND CARD 1st, 2nd SCOREBOARD
    --DRAW EoG SYMBOL IF WE PLAYER GOT IT OR COMPUTER
    drawHighLightSB( tScoreBoard.iUserEditSB, _x, _y, tUserPredicted.pColour )
  elseif tSM.curDState == "SCOREBOARD" then  --TRIGGER BY "SB" OR "INTRO"
    --SINCE EoG-CARD COULD BE EARNED 2x, NOT LIKELY BUT COULD BE WE RECORDED TO FILE 0/1/2 NOT T/F
    if tScoreBoard[ tScoreBoard.iUserEditSB ].numEEggs > 0 and 
    tScoreBoard[ tScoreBoard.iUserEditSB ].name == "COMP-BASE-LINE" then
      drawSymbolSB( "COMP-BASE-LINE" )  --DISPLAY EoG FACT BY COMPUTER
    elseif tScoreBoard[ tScoreBoard.iUserEditSB ].numEEggs > 0 then
      drawSymbolSB( "USER" )  --DISPLAY EoG FACT BY USER
    end
    drawCard()    --DRAW BACKGROUND CARD 1st, 2nd SCOREBOARD
    drawEoGSB()   --NOW TO SCALE AND LOOKS VERY NICE PERFECTLY FRAMED UP 5% BOARDERS
  elseif tSM.curDState == "GUESS-EoG" then
    if tSM.curState == "EoG-pCOMP" then
      drawCard()
      drawSymbol( "COMP" )
    else
      drawCard()
      drawSymbol( "USER" )
    end
  elseif tSM.curDState == "Q1TURNS" then   --HOW MANY TURNS EoG  -PREDICTION
    drawQ1()
  elseif tSM.curDState == "Q2ERRORS" then  --HOW MANY ERROR IN GAME - PREDICTION
    drawQ2()
  elseif tSM.curDState == "PER-TURN" then
    drawCard()
    drawPerTurnSB()
    if tUserPredicted.bptDisplayedSYMB == true or tCompPredicted.bptDisplayedSYMB == true then
      drawSymbol()
    end
  end
end