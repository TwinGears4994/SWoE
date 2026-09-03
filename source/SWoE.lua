--[[
Brian T.Wilcox
twingears@gmail.com
]]
function aLoop()
-- aLoop = { "FILE-CHK", "FILE-LOAD", "FILE-SAVE" }
  if tSM.aLoop[ tSM.idxState ] == "FILE-CHK" then
    if createFilesys() then       --IF FILE SIZE >0
      tSM:walk( true )   --bREWIND AS true =+1
    else
      tSM:switch( false )           --"INTRO" THERE FOR SWITCHING TO bLoop
    end
  elseif tSM.aLoop[ tSM.idxState ] == "FILE-LOAD" then
    tScoreBoard = loadScore( tScoreBoard )
    tSM:walk( true )                    --SAVE THE NEWLY FILTERED ETC SB TO FILE
  elseif tSM.aLoop[ tSM.idxState ] == "FILE-SAVE" then
    saveScore( tScoreBoard )
    tSM:bLresetGame()             --"INTRO" THERE FOR SWITCHING TO bLoop
  end
end
--bLoop = { "INTRO", "EoG-pCOMP", "EoG-COMP-FB", "EoG-pUSER", "Q1TURNS", "Q2ERRORS", "MASK-ON" }
function bLoop()    -- *** MAIN GAME C LOOP ***
  if tSM.bLoop[ tSM.idxState ] == "INTRO" and dtCounter > waitTime then
    if narSection( "INTRO" ) then --if FUNCTION then - TRIED THIS TO SEE IF IT WOULD RUN AND IT DID! THIS IDEA CHANGES A LOT MORE CODE NOW LIKE NARRATOR RE-WRITE, IT'S INSPIRED THE SM TO CHANGE A FEW DAYS LATER TODAY DEC 22nd
      tSM:fLenterSB()
    end
    -- *** COMPUTER GUESSES AT LAST CARD IN GAME, FOR USER TO SEE ***
  elseif tSM.bLoop[ tSM.idxState ] == "EoG-pCOMP" and dtCounter > waitTime then
    tScoreBoard = compPredictEoG( tScoreBoard )
    --NEW WHERE COMPUTER IS LOCKED INTO IT'S SCOREBOARD AVERAGE ROUNDED DOWN MIND YOU...
    tCompPredicted.pEoGErrs = math.floor( tScoreBoard.avgSB.allComp )
    tSM:walk( true )
  elseif tSM.bLoop[ tSM.idxState ] == "EoG-COMP-FB" and dtCounter > waitTime then
    if narSection( "EoG-COMP-FB" ) then
      iSpeak = 1
      tSM:walk( true )
    end
    -- *** RANDOM SHAPE & COLOUR SPOKEN FOR CALIBRATION TESTING FUN ***
  elseif tSM.bLoop[ tSM.idxState ] == "EoG-pUSER" and dtCounter > waitTime then
    if tCurrentCard.navTalk then    --JOYSTICK UP ON DPAD DETECTED TALK OUT SHAPE & COLOUR
      if narSection( "EoG-pUSER" ) then
        iSpeak = 1
        tCurrentCard.navTalk = false
      end
    end
    -- *** CHANGE EoG # VALUE OF TURNS AS USERS GAME ***
  elseif tSM.bLoop[ tSM.idxState ] == "Q1TURNS" and dtCounter > waitTime then
    if narSection( "Q1TURNS" ) then     
      waitTime = 7                   --DELAY NARRATOR REPEAT
    end
    -- *** CHANGE EoG # VALUE OF ERRORS USER WILL MAKE IN THIS GAME ***
  elseif tSM.bLoop[ tSM.idxState ] == "Q2ERRORS" and dtCounter > waitTime then
    if narSection( "Q2ERRORS" ) then
      waitTime = 7                   --DELAY NARRATOR REPEAT
    end
  elseif tSM.bLoop[ tSM.idxState ] == "MASK-ON" and dtCounter > waitTime then
    if narSection( "MASK-ON" ) then
      dtCounter = 0
      tSM:switch()
    end
  end
end
--cLoop = { "GUESS-COMP","TUTOR","RESET-CARD","GUESS-USER","SCORE-COMP","SCORE-USER","EoG" },
function cLoop()    -- *** MAIN GAME C LOOP ***
  if tSM.curState == "TUTOR" and dtCounter > waitTime then
    iSpeak = 1
    if tUserScore.level <= 9 then
      if narSection( "TUTOR" ) then
        --tSM:walk( true )  --MARCH 2nd MADE NO DIFFERENCE IN TUTOR, IT'S TRIMMING OFF SHAPE dt
      else
       tSM:walk( true )
      end
    end
  elseif tSM.curState == "RESET-CARD" and dtCounter > waitTime then
    screenReset()
    waitTime = .5         --TIME PADDING FOR NEW QUESTION
    iSpeak = 1
    tSM:walk( true )
  elseif tSM.curState == "QUESTION" and dtCounter > waitTime then
    if tUserScore.level < 9 then
      if narSection( "IS-THE-COLOUR" ) then
        tSM:walk( true )
      end
    elseif tUserScore.level == 9 then
      tSM:walk( true )
    end
  elseif tSM.curState == "GUESS-COMP" then
    tCompPredicted.pCturn = compGuessL2L9() -- *** COMP GUESS FROM SAME AUDIO CHOICES AS USER GETS FOR CLOSEST BASELINE REFERENCE ***
    tCompPredicted.pSturn = rndShape()    --COMP PICKED NEW SHAPE
    tSM:walk( true )
  elseif tSM.curState == "SCORE-COMP" then  --COMP ALWAYS PLAYS MAIN GAME, NO PASS
    tCompPredicted, tCompScore = scoreChanges( tCompPredicted, tCompScore )
    tCompScore.level = tUserScore.level   --COMPUTER PLAYER IS TO MIRROR PLAYER AS TO CREATE BASELINE FOR RANDOM GUESSING
    tSM:walk( true )
    dtCounter = 0
    --CHECK OVER EoG AND THEN LOOP BACK TO BEGINNING OF cLoop OR SWITCH TO dLoop
  elseif tSM.curState == "EoG1" then
    --SETUP USERS EoG INDEXES ENTERING BONUS ROUNT
    if tUserPredicted.bEoG1 then
      tScoreBoard.iListColour = colourEcco( "idx", tUserPredicted.pColour , 0)
      _, tScoreBoard.iListShape = shapeEcco( tUserPredicted.pShape ,0)
    end
    tSM:walk( true )
  elseif tSM.curState == "NARR1" and dtCounter > waitTime then
    if #tSM.tNarrTalk > 0 and narSection("NARRATOR") then
      tSM.tNarrTalk = {}
      if tUserPredicted.bEoG1 and tCompPredicted.bEoG1 then
        tSM:switch( false )   --JUMPING OVER BR dLoop "BR-FLASH-CARD"
      else
        tSM:walk( false )
        tSM:walk( true )    --RESET-CARD IN 2 MOVEMENTS
      end
    end
  end
end

function dLoop()    -- *** USER BR GAME DLOOP ***
  local tTiming = { .6,.7,.8,.9,1,1,.9,.8,.7,.6 }
  if tSM.curState == "BR-FLASH-CARD" then
    if not tUserPredicted.bEoG2 then
      dtCounter = 0
      screenReset()
      waitTime = tTiming[ tCurrentCard.cardBRtiming ]
      tCurrentCard.cardBRtiming = tCurrentCard.cardBRtiming +1
      if tCurrentCard.cardBRtiming > #tTiming then
        tCurrentCard.cardBRtiming = 1
      end
    else --if tUserPredicted.bEoG2 then
      tSM:walk( true )
    end
    
  elseif tSM.curState == "SCORE-USER" then
    if not tUserPredicted.bEoG2 then
      tUserPredicted, tUserScore, tSM.tNarrTalk = scoreChanges( tUserPredicted, tUserScore, "USER" )
    end
    tSM:walk( true )
    
  elseif tSM.curState == "EoG2" then   --DEFAULT SCORE INJECTION AT END OF GAME
    if tUserPredicted.bEoG2 and not tUserPredicted.bEXIT then
      tUserScore, tScoreBoard = scoreInsert( "FAR-OUT" ,tUserScore, tUserPredicted, tScoreBoard )
      --if tScoreBoard.iUserEditSB < 27 then
      tScoreBoard.bScoreEDITED = true   --
      --else
        --tScoreBoard.bScoreEDITED = false  --TOGGLE TO OFF IF INDEX >26 NOT ON SCREEN VIEW
      --end
      tUserPredicted.bEXIT = true
    end
    tSM:walk( true )
    
  elseif tSM.curState == "NARR2" and dtCounter > waitTime then
    if #tSM.tNarrTalk > 0 and narSection("NARRATOR") then
      tSM.tNarrTalk = {}
      if tUserPredicted.bEXIT then
        tSM:switch( false )  --MOVING OVER TO COMP BR eLOOP
      else
        tSM:walk( false )   --KEEP ON PLAYING
      end
    elseif not tUserPredicted.bGoBR then
      tSM:switch( false )  --MOVING OVER TO COMP BR eLOOP
    end
  end
end

function eLoop()    -- *** COMPUTER BR GAME ELOOP ***
  --local tTiming = { .3 }
  if tSM.curState == "BR-FLASH-CARD" then
    if not tCompPredicted.bEoG2 then
      screenReset()
    end
    tSM:walk( true )  --INTO "BR-COMP" FOR COMPUTER TO FINISH IT'S BONUS ROUNDS
  elseif tSM.curState == "BR-COMP" then
    if not tCompPredicted.bEoG2 then    --NORMAL BR GUESS PER-TURN
      local _choice = math.random( 1,2 )
      if _choice == 1 then
        tCompPredicted.pCturn = compGuessL2L9() --COMP GUESS COLOUR
        tCompPredicted.pSturn = rndShape()    --COMP PICKED NEW SHAPE
      else
        -- *** COMPUTER SHOULD BE HOLDING IT'S EoG CARD *** --ODDS ARE BETTER SCORE
        tCompPredicted.pCturn = tCompPredicted.pColour
        tCompPredicted.pSturn = tCompPredicted.pShape
      end
    end
    tSM:walk( true )  --"SCORE-COMP" MOVE INTO
  elseif tSM.curState == "SCORE-COMP" then
    if not tCompPredicted.bEoG2 then --FOLLOWING UP COMP BR TURN
      tCompPredicted, tCompScore = scoreChanges( tCompPredicted, tCompScore, "COMP" )
    end
    if tCompPredicted.bEoG2 then
      tCompScore, tScoreBoard = scoreInsert( "COMP",tCompScore, tCompPredicted, tScoreBoard )
      tScoreBoard.bScoreEDITED = true
      tCompPredicted.bEXIT = true
    end
    tSM.tNarrTalk = {}
    table.insert(tSM.tNarrTalk, {"main",24} )      --"DRIP" SO WE KNOW THE CARD CHANGED
    tSM:walk( true )
  elseif tSM.curState == "NARR2" and dtCounter > waitTime then
    if #tSM.tNarrTalk > 0 then
      if narSection("NARRATOR") then
        tSM.tNarrTalk = {}
      end
    end
    if tCompPredicted.bEXIT then
      if tScoreBoard.iUserEditSB >26 then
        tSM:switch( false )
      else
        tSM:switch( true )  --MOVING OVER TO SB eLOOP, false blocks both USER and COMP from EDITING SB
      end
    else
      tSM:walk( false )
    end
  end
end

function fLoop()    -- *** MAIN GAME E LOOP *** 
  if tSM.curState == "SCOREBOARD" and dtCounter > waitTime then
    buildCard( tScoreBoard[ tScoreBoard.iUserEditSB ].EoGColour, 
      tScoreBoard[ tScoreBoard.iUserEditSB ].EoGShape, 1 )
    --narSection( "SCOREBOARD" )  --PLAYS NOTHING YET! & WOULD CONTROL THE TIMING LOOPING
    tScoreBoard.iUserEditSB = tScoreBoard.iUserEditSB +1  --INCREASE HIGHTLIGHTED SCORE
    if tScoreBoard.iUserEditSB > #tScoreBoard then
      tScoreBoard.iUserEditSB = 1   --LOOP BACK TO BEGINNING OF SCORE LIST
    end
    tScoreBoard.waitCount = tScoreBoard.waitCount +1      --TIME OUT COUNTER FOR EDITING SB
    dtCounter = 0
    waitTime = 1
  end
end