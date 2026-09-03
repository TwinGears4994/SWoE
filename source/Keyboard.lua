--[[
Brian T.Wilcox
twingears@gmail.com
]]
function love.keypressed(key)     --RUN FROM .update(dt)
--  key = "DOG LATIN IS-TRICKY-MONKEY-BUSINESS"
  if key == "escape" then
    narratorTalk( 1, { {"main",24} } )
    goESC()
  elseif key == "up" then                   --RESET SHAPE & COLOUR
    goUp()    --    love.touchmoved( )
  elseif  key == "left" then                --NEXT SHAPE MATCH SPOKEN
    goLeft()
  elseif  key == "right" then               --NEXT COLOUR MATCH SPOKEN
    goRight()
  elseif key == "down" then                 --SELECTION FINAL
    goDown()
  elseif key == "e" and tSM.curState == "SCOREBOARD" then --or "EDIT-SB" then
    tSM:walk( false )
    tSM:dState( false, true , false  )
    tScoreBoard.bScoreEDITED = true
  --elseif key == "q" and tSM.curState == "SCOREBOARD" then
    --tScoreBoard.bQUARTER = true   --NO LCS-TA WITHOUT MANUAL QUARTER OR SWoE
  end
end

function goESC()
  if tSM.curState == "SCOREBOARD" then
    if tScoreBoard.bScoreEDITED then
      saveScore( tScoreBoard )
    end
    love.event.quit()
  else
    tSM:fLenterSB()
  end
end

function toggle(_bool)
  return not _bool
end

-- TIME-OUT FOR IF USER STARTS A GAME AND DOESN'T FINNISH INPUT - GO BACK TO SCOREBOARD WALK AWAY OPTION
function goUp()
  tUserPredicted.pSturn = tShapes[ tScoreBoard.iListShape ][1]
  tUserPredicted.pCturn = tColours[ tScoreBoard.iListColour ][1]
  if tSM.idxLoop == 2 then
    if tSM.curState == "INTRO" then            --INTERUPT INTRO NARRATOR
      tSM:fLenterSB()
    elseif tSM.curState == "EoG-pUSER" then     --CALIBRATE COLOUR & SHAPE BUT UP RND OF THIS ;)
      --RANDOM COLOUR & SHAPE - SEE THE DATA BEYOND THE MASK
      screenReset()
      tCurrentCard.navTalk = true  --NEW SOUND OFF TRIGGER
      dtCounter = 0
      --BUILD NARRATOR TALK FOR (dt) ?
--      speakShape( tCurrentCard.shape )  --SPACE OUT THE TALKING WITH SOME (dt)
--      speakColour( tCurrentCard.c1 )
    end
  elseif tSM.idxLoop == 3 and tUserScore.level <= 9 and not ( tUserPredicted.EoGturns == tUserScore.curGameTurn ) then --NO RESETTING THE LAST CARD IN TRAINING AID GAME NOR THE BONUS-ROUND NOR <L9
    iSpeak = 1
    waitTime = 0
    dtCounter = 0
    tSM:walk( false ) --"TUTOR"
  elseif tSM.idxLoop == 6 then
    if tSM.curState == "SCOREBOARD" then   --INTERUPT SB AND BEGINS GAME
      tSM:bLresetGame( true )
  -- *** 1-LIST COLOURS / 2-SONGS or BEATS / 3-NAMES / 4-iLETTER PART OF NAME  *** --EDITING MODE
    elseif tSM.curState == "EDIT-SB" then -- and tStateMach.curState == "EDIT-SB" then   --LENGTHEN TIMER ON ENTERENCE
      tScoreBoard.waitCount = 0     --JUST LIKE OLD SB, IT WOULD TIMEOUT AFTER BEING LEFT ALONE AND SCORE NAME SET
      if tScoreBoard.iTwinGears == 1 then
        tScoreBoard.iListColour = tScoreBoard.iListColour +1
        if tScoreBoard.iListColour >= #tColours -1 then --REMEMBER THERE IS A "COLOUR" VALUE IN THE COLOURS SO -1 LESS ITEM THUS == TABLE SIZE
          tScoreBoard.iListColour = 1
        end   --ASIGN CURRENT SELECTION OF COLOUR
        tScoreBoard[ tScoreBoard.iUserEditSB ].cName = tColours[ tScoreBoard.iListColour ][1]    --ASSIGN "COLOUR"
        tScoreBoard[ tScoreBoard.iUserEditSB ].tColourName = tColours[ tScoreBoard.iListColour ][4]   --ASSIGN NEW COLOUR TABLE

      elseif tScoreBoard.iTwinGears == 2 then    --SOUND SELECTION
        tScoreBoard.iTwinGears = tScoreBoard.iTwinGears +1  --TEMP WORK AROUND FOR A LACK OF SOUNDS

      elseif tScoreBoard.iTwinGears == 3 then    --SCROLL THROUGH THE LIST OF NAMES FOR USER TO PICK
        tScoreBoard.iListName = tScoreBoard.iListName +1
        if tScoreBoard.iListName > #tListNames then
          tScoreBoard.iListName = 1
        end
        tScoreBoard[ tScoreBoard.iUserEditSB ].name = tListNames[ tScoreBoard.iListName ]    --ASSIGN NEW "NAME" FROM LIST
        --TABLE SHOULD BE UPDATED IN <LEFT-RIGHT> WHERE EVENT ARE 2 OUT OF 4 iTwinGears, LETS JUST GET IT OVER WITH HERE FOR NOW
        tScoreBoard[ tScoreBoard.iUserEditSB ].tName = 
        { tScoreBoard[ tScoreBoard.iUserEditSB ].name:match( (tScoreBoard[ tScoreBoard.iUserEditSB ].name:gsub(".", "(.)")) ) } --SPLITE NAME INTO TABLE OF CHARACTERS

      elseif tScoreBoard.iTwinGears == 4 then   -- MINUS -AZ UP - SCORE BOARD USER NAME INPUT
        local abc = { " ","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","-",".","0","1","2","3","4","5","6","7","8","9" }
        --LOCATE AND UPDATE OUR LETTER INDEX THEN 1 UP THAT
        local _name = tScoreBoard[ tScoreBoard.iUserEditSB ].name
        local _letter = string.sub( _name, tScoreBoard.iLetterRow, tScoreBoard.iLetterRow )
        tScoreBoard.iLetter = locateIndex( abc, _letter )
        tScoreBoard.iLetter = tScoreBoard.iLetter +1
        if tScoreBoard.iLetter > #abc then
          tScoreBoard.iLetter = 1
        end
        --UPDATE CHANGED LETTER IN ROW POSITION
        tScoreBoard[ tScoreBoard.iUserEditSB ].name = reBuildName( tScoreBoard[ tScoreBoard.iUserEditSB ].name, tScoreBoard.iLetterRow, abc[ tScoreBoard.iLetter ] )
        --tScoreBoard.iLetter * tScoreBoard.yPixels
      end
    end
  end
end

function goDown()     --    local list colours / songs or beats / names / parts of name
  waitTime = 0
  dtCounter = 0
  if tSM.idxLoop == 2 then
    if tSM.curDState == "GUESS-EoG" then        -- ** <L&R> check filtering...
      tUserPredicted.pSturn = tShapes[ tScoreBoard.iListShape ][1]
      tUserPredicted.pCturn = tColours[ tScoreBoard.iListColour ][1]
    end
    if tSM.curState == "INTRO" then         --INTERUPT NARRATOR INTRO
      tSM:fLenterSB()
    elseif tSM.curState == "EoG-pUSER" then     --USER SELECTED EoG CARD
      tSM.idxDState = 3                         --MOVING ONTO "Q1TURNS"
      tSM:walk( true )
    elseif tSM.curState == "Q1TURNS" then
      tCompPredicted.EoGturns = tUserPredicted.EoGturns   --COMP PREDICT # OF TURNS IN GAME MEANING GUESS WHAT USER PICKS AS GAME LENGTH (SCORES HAVE DATA)
      tUserPredicted.pEoGErrs = math.floor(tScoreBoard.avgSB.allUser *tUserPredicted.EoGturns) -- *10) /10
      tSM.idxDState = 4                         --MOVING ONTO "Q2ERRORS"
      tSM:walk( true )
    elseif tSM.curState == "Q2ERRORS" then
      waitTime = 0                              --SHAKE OFF THE Q1 TIME REPEAT DELAY
      tSM.idxDState = 5                         --MOVING ONTO "PER-TURN"
      tSM:walk( true )
    elseif tSM.curState == "MASK-ON" then
      tSM:switch()      --MOVE INTO cLoop "RESET-CARD"
    end
    
  elseif tSM.idxLoop == 3 then
    if tSM.curDState == "PER-TURN" then   -- ** <L&R> check filtering...
      tUserPredicted.pSturn = tShapes[ tScoreBoard.iListShape ][1]
      tUserPredicted.pCturn = tColours[ tScoreBoard.iListColour ][1]
    end
    if tSM.curState == "QUESTION" then
      tSM:walk( true )
    elseif tSM.curState == "SCORE-USER" then
      tUserPredicted, tUserScore, tSM.tNarrTalk = scoreChanges( tUserPredicted, tUserScore, "USER" )
      tSM:walk( true )
    end
      
  elseif tSM.idxLoop == 4 then
    if tSM.curState == "BR-FLASH-CARD" then
      if not tUserPredicted.bEoG2 then
        tSM:walk( true )  --COMPUTER IS STILL IN THE GAME
      end
    end
  elseif tSM.idxLoop == 6 then
    if tSM.curState == "SCOREBOARD" then    --INTERUPT SB AND BEGINS GAME
      tSM:bLresetGame( true )
  -- *** 1-LIST COLOURS / 2-SONGS or BEATS / 3-NAMES / 4-iLETTER PART OF NAME  *** --EDITING MODE
    elseif tSM.curState == "EDIT-SB" then   --LENGTHEN TIMER ON ENTERENCE
    tScoreBoard.waitCount = 0     --JUST LIKE OLD SB, IT WOULD TIMEOUT AFTER BEING LEFT ALONE AND SCORE NAME SET
      if tScoreBoard.iTwinGears == 1 then
        tScoreBoard.iListColour = tScoreBoard.iListColour -1
        if tScoreBoard.iListColour < 1 then --REMEMBER THERE IS A "COLOUR" VALUE IN THE COLOURS SO -1 LESS ITEM THUS == TABLE SIZE
          tScoreBoard.iListColour = #tColours -1
        end   --ASIGN CURRENT SELECTION OF COLOUR
        tScoreBoard[ tScoreBoard.iUserEditSB ].cName = tColours[ tScoreBoard.iListColour ][1]    --ASSIGN "COLOUR"
        tScoreBoard[ tScoreBoard.iUserEditSB ].tColourName = tColours[ tScoreBoard.iListColour ][4]   --ASSIGN NEW COLOUR TABLE
        -- *** 2-SONGS or BEATS *** --EDITING MODE
      elseif tScoreBoard.iTwinGears == 2 then    --SOUND SELECTION
        tScoreBoard.iTwinGears = tScoreBoard.iTwinGears -1  --TEMP WORK AROUND FOR A LACK OF SOUNDS
        -- *** 3-NAMES *** --EDITING MODE
      elseif tScoreBoard.iTwinGears == 3 then    --SCROLL THROUGH THE LIST OF NAMES FOR USER TO PICK
        tScoreBoard.iListName = tScoreBoard.iListName -1
        if tScoreBoard.iListName < 1 then
          tScoreBoard.iListName = #tListNames
        end
        tScoreBoard[ tScoreBoard.iUserEditSB ].name = tListNames[ tScoreBoard.iListName ]    --ASSIGN NEW "NAME" FROM LIST
        --TABLE SHOULD BE UPDATED IN <LEFT-RIGHT> WHERE EVENT ARE 2 OUT OF 4 iTwinGears, LETS JUST GET IT OVER WITH HERE FOR NOW
        tScoreBoard[ tScoreBoard.iUserEditSB ].tName = 
        { tScoreBoard[ tScoreBoard.iUserEditSB ].name:match( (tScoreBoard[ tScoreBoard.iUserEditSB ].name:gsub(".", "(.)")) ) } --SPLITE NAME INTO TABLE OF CHARACTERS
        -- *** 4-iLETTER PART OF NAME *** --EDITING MODE
      elseif tScoreBoard.iTwinGears == 4 then   -- MINUS -AZ UP - SCORE BOARD USER NAME INPUT
        local abc = { " ","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","-",".","0","1","2","3","4","5","6","7","8","9" }
        --LOCATE AND UPDATE OUR LETTER INDEX THEN 1 UP THAT
        local _name = tScoreBoard[ tScoreBoard.iUserEditSB ].name
        local _letter = string.sub( _name, tScoreBoard.iLetterRow, tScoreBoard.iLetterRow )
        tScoreBoard.iLetter = locateIndex( abc, _letter )
        tScoreBoard.iLetter = tScoreBoard.iLetter -1
        if tScoreBoard.iLetter < 1 then
          tScoreBoard.iLetter = #abc
        end
        --UPDATE CHANGED LETTER IN ROW POSITION
        tScoreBoard[ tScoreBoard.iUserEditSB ].name = reBuildName( tScoreBoard[ tScoreBoard.iUserEditSB ].name, tScoreBoard.iLetterRow, abc[ tScoreBoard.iLetter ] )
      end
    end
  end
end

function goLeft()
  if tSM.idxLoop == 2 then
    if tSM.curState == "INTRO" then            --INTERUPT INTRO NARRATOR
      tSM:fLenterSB()
    end
    --CHANGING THE SHAPE OF THE EoG CARD
    if tSM.curState == "EoG-pUSER" then
      tScoreBoard.iListShape = tScoreBoard.iListShape +1
      if tScoreBoard.iListShape == #tShapes then
        tScoreBoard.iListShape = 1
      end
      --UPDATE WHERE COMPUTER COLOUR & SHAPE LEAVE CARD AT - AS IT WAS BEFORE
      tUserPredicted.pShape = tShapes[ tScoreBoard.iListShape ][1]
      tUserPredicted.pColour = tColours[ tScoreBoard.iListColour ][1]
      speakShape( tUserPredicted.pShape )
      buildCard( tUserPredicted.pColour, tUserPredicted.pShape, 1 )
    elseif tSM.curState == "Q1TURNS" and tUserPredicted.EoGturns > 10 then
      tUserPredicted.EoGturns = tUserPredicted.EoGturns -1
    elseif tSM.curState == "Q2ERRORS" and tUserPredicted.pEoGErrs > 0 then
      tUserPredicted.pEoGErrs = tUserPredicted.pEoGErrs -.5
    end
  
  elseif tSM.idxLoop == 3 then
    if tSM.curState == "SCORE-USER" then
      tScoreBoard.iListShape = tScoreBoard.iListShape +1
      if tScoreBoard.iListShape == #tShapes then
        tScoreBoard.iListShape = 1
      end
      tUserPredicted.pSturn = tShapes[ tScoreBoard.iListShape ][1]
      speakShape( tUserPredicted.pSturn )
    end
    
  elseif tSM.idxLoop == 4 then
    if tSM.curState == "BR-FLASH-CARD" and tUserPredicted.bGoBR then
      tScoreBoard.iListShape = tScoreBoard.iListShape +1
      if tScoreBoard.iListShape == #tShapes then
        tScoreBoard.iListShape = 1
      end
      tUserPredicted.pSturn = tShapes[ tScoreBoard.iListShape ][1]
      speakShape( tUserPredicted.pSturn )
    end
    
  elseif tSM.idxLoop == 6 then
    if tSM.curState == "SCOREBOARD" then   --INTERUPT SB AND BEGINS bLoop 
      tSM:bLresetGame( true )
    elseif tSM.curState == "EoG-pCOMP" then    --INTERUPT NARRATOR TALKING ABOUT COMPUTERS GUESSED CARD
      iSpeak = 1
      tSM:walk( true )
  -- *** 1-LIST COLOURS / 2-SONGS or BEATS / 3-NAMES / 4-iLETTER PART OF NAME  *** --EDITING MODE
    elseif tSM.curState == "EDIT-SB" then -- and tStateMach.curState == "EDIT-SB" then    -- MINUS +NAME INDEX RIGHT - SCORE BOARD USER NAME INPUT
      tScoreBoard.waitCount = 0     --JUST LIKE OLD SB, IT WOULD TIMEOUT AFTER BEING LEFT ALONE AND SCORE NAME SET
      if tScoreBoard.iTwinGears == 4 and tScoreBoard.iLetterRow > 1 then
        tScoreBoard.iLetterRow = tScoreBoard.iLetterRow -1
      elseif tScoreBoard.iTwinGears > 1 and tScoreBoard.iTwinGears <= 4 then --or ( tScoreBoard.iTwinGears == 4 and tScoreBoard.iLetterRow == 1 ) then
        tScoreBoard.iTwinGears = tScoreBoard.iTwinGears -1
      end
      -- *** 1-LIST COLOURS / 2-SONGS or BEATS / 3-NAMES / 4-iLETTER PART OF NAME  *** --EDITING MODE
      -- *** 1-LIST COLOURS / 2-SONGS or BEATS / 3-NAMES / 4-iLETTER PART OF NAME  *** --EDITING MODE
    end
  end
end

function goRight()
  if tSM.idxLoop == 2 then
    if tSM.curState == "INTRO" then            --INTERUPT NARRATOR bLoop
      tSM:fLenterSB()
    end
    --CHANGING THE COLOUR OF THE EoG CARD
    if tSM.curState == "EoG-pUSER" then
      tScoreBoard.iListColour = tScoreBoard.iListColour +1
      if tScoreBoard.iListColour >= #tColours then
        tScoreBoard.iListColour = 1
      end
      --UPDATE WHERE COMPUTER COLOUR & SHAPE LEAVE CARD AT - AS IT WAS BEFORE
      tUserPredicted.pColour = tColours[ tScoreBoard.iListColour ][1]
      tUserPredicted.pShape = tShapes[ tScoreBoard.iListShape ][1]
      speakColour( tUserPredicted.pColour )
      buildCard( tUserPredicted.pColour, tUserPredicted.pShape, 1 )
    elseif tSM.curState == "Q1TURNS" then      --INCREASE # OF TURNS THE GAME WILL PLAY FOR
      tUserPredicted.EoGturns = tUserPredicted.EoGturns +1
    elseif tSM.curState == "Q2ERRORS" then
      tUserPredicted.pEoGErrs = tUserPredicted.pEoGErrs +.5
    end
    
  elseif tSM.idxLoop == 3 then
    if tSM.curState == "SCORE-USER" then
      tScoreBoard.iListColour = tScoreBoard.iListColour +1
      if tScoreBoard.iListColour >= #tColours then
        tScoreBoard.iListColour = 1
      end
      tUserPredicted.pCturn = tColours[ tScoreBoard.iListColour ][1]
      speakColour( tUserPredicted.pCturn )
    end
  
  elseif tSM.idxLoop == 4 then
    if tSM.curState == "BR-FLASH-CARD" and tUserPredicted.bGoBR then
      tScoreBoard.iListColour = tScoreBoard.iListColour +1
      if tScoreBoard.iListColour >= #tColours then
        tScoreBoard.iListColour = 1
      end
      tUserPredicted.pCturn = tColours[ tScoreBoard.iListColour ][1]
      speakColour( tUserPredicted.pCturn )
    end
  
  elseif tSM.idxLoop == 6 then
    if tSM.curState == "SCOREBOARD" then   --INTERUPT SB AND BEGINS GAME
      tSM:bLresetGame( true )
    elseif tSM.curState == "EoG-pCOMP" then    --INTERUPT NARRATOR TALKING ABOUT COMPUTERS GUESSED CARD
      iSpeak = 1
      tSM:walk( true )
  -- *** 1-LIST COLOURS / 2-SONGS or BEATS / 3-NAMES / 4-iLETTER PART OF NAME  *** --EDITING MODE
    elseif tSM.curState == "EDIT-SB" then      -- and tStateMach.curState == "EDIT-SB" then    -- MINUS +NAME INDEX RIGHT - SCORE BOARD USER NAME INPUT
      tScoreBoard.waitCount = 0                   --JUST LIKE OLD SB, IT WOULD TIMEOUT AFTER BEING LEFT ALONE AND SCORE NAME SET
      if tScoreBoard.iTwinGears == 4 and tScoreBoard.iLetterRow < 20 then --WHAT WAS THE NAME LENGTH CAP?
        tScoreBoard.iLetterRow = tScoreBoard.iLetterRow +1
      elseif tScoreBoard.iTwinGears >= 1 and tScoreBoard.iTwinGears < 4 then
        tScoreBoard.iTwinGears = tScoreBoard.iTwinGears +1
      end
      -- *** 1-LIST COLOURS / 2-SONGS or BEATS / 3-NAMES / 4-iLETTER PART OF NAME  *** --EDITING MODE
    end
  end
end