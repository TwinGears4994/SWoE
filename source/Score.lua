--[[
Brian T.Wilcox
twingears@gmail.com
]]
function recycleSBData( _tScoreBoard )
  --WORKS  1- ( (_tScoreBoard[index].numColours + _tScoreBoard[index].numShapes )/2 /( _tScoreBoard[index].numTurns + _tScoreBoard[index].numBRTurns ) )
  --WE WANT TO HAVE 1st PLACE OVER ALL DATA OF USERS
  --2nd LINE WILL BE TOP 10 OF USERS
  --3rd LINE WILL BE TOP 100 OF USERS OR ALL USERS
  --4th LINE WILL BE COMPUTER DATA
  local _tUsers = { overall = 0, first = 0, ten = 0 }--, hundred = 0 }
  local _tComp = { overall = 0 }
  for index = 1, #_tScoreBoard do   --PROCESS COMPUTER DATA
    if _tScoreBoard[index].name == "COMP-BASE-LINE" then
      table.insert( _tComp, 1- ( (_tScoreBoard[index].numColours + _tScoreBoard[index].numShapes )/2 /( _tScoreBoard[index].numTurns + _tScoreBoard[index].numBRTurns ) ) )
    else                        --PROCESS USER DATA INSERT
      table.insert( _tUsers, 1- ( (_tScoreBoard[index].numColours + _tScoreBoard[index].numShapes )/2 /( _tScoreBoard[index].numTurns + _tScoreBoard[index].numBRTurns ) ) )
    end
  end
  for i = 1, #_tComp do
    _tComp.overall =  _tComp.overall + _tComp[i]
  end
  _tComp.overall = _tComp.overall /#_tComp
  for i =1, #_tUsers do
    _tUsers.overall =  _tUsers.overall + _tUsers[i]
    if i == 1 then
      _tUsers.first = _tUsers[i]
    elseif i == 10 then
      _tUsers.ten = _tUsers.overall /10
    elseif i == #_tUsers then --i == 100 or 
      _tUsers.overall = _tUsers.overall /#_tUsers
    end
  end
  return _tUsers.first, _tUsers.ten, _tUsers.overall, _tComp.overall
  --#TURNS IN GAME * THESE VALUES WILL GIVE US BETTER IDEA OF ERRORS MADE
end

function orderSB( _tScoreBoard ) --HUNT BY NAME AND THEN LOOK FOR OTHER EXACT MATCH DATA tScoreBoard.
--  local _bScoreEDITED = false
  local _table = {}
  local iMatch, iWalk = 1, 1
  table.insert( _table, iWalk, _tScoreBoard[ iWalk ] )
  iWalk = iWalk +1
  while iWalk ~= #_tScoreBoard +1 do
    while iMatch ~= #_table +1 do
      if tonumber( _tScoreBoard[ iWalk ].numScore ) == tonumber( _table[ iMatch ].numScore ) then
        if tonumber( _tScoreBoard[ iWalk ].numBRCards ) > tonumber( _table[ iMatch ].numBRCards ) then
          table.insert( _table,  iMatch, _tScoreBoard[  iWalk ] )
          iMatch = 1
          break
        elseif tonumber( _tScoreBoard[ iWalk ].numBRSymbs ) > tonumber( _table[ iMatch ].numBRSymbs ) then
          table.insert( _table,  iMatch, _tScoreBoard[ iWalk ] )
          iMatch = 1
          break
        elseif tonumber( _tScoreBoard[ iWalk ].numBRTurns ) >= tonumber( _table[ iMatch ].numBRTurns ) then
          table.insert( _table,  iMatch, _tScoreBoard[ iWalk ] )
          iMatch = 1
          break
        end
      elseif tonumber( _tScoreBoard[ iWalk ].numScore ) < tonumber( _table[ iMatch ].numScore ) then 
        iMatch = iMatch +1
      elseif tonumber( _tScoreBoard[ iWalk ].numScore ) > tonumber( _table[ iMatch ].numScore ) then
        table.insert( _table,  iMatch, _tScoreBoard[ iWalk ] )       --WORKS FOR LOWEST SCORE & HIGHEST SCORE
        iMatch = 1
        break
      end
      if iMatch >  #_table then
        table.insert( _table, _tScoreBoard[ iWalk ] )          --LOWEST SCORE INJECTION
        iMatch = 1
        break
      end
      --iMatch = iMatch +1
    end
    iWalk = iWalk +1
  end
  for i =1, #_tScoreBoard do
    table.remove(_tScoreBoard, 1)
  end
  for i=1, #_table do
    table.insert( _tScoreBoard, _table[ i ] )
  end
  return _tScoreBoard
end

function scrubDupliSB( _tScoreBoard ) --HUNT BY NAME AND THEN LOOK FOR OTHER EXACT DATA MATCH
  local iMatch, iWalk =1,1
  if #_tScoreBoard > 1 then
    while iWalk ~= #_tScoreBoard +1 do
      iMatch = iWalk +1
      while iMatch ~= #_tScoreBoard +1 do
        if _tScoreBoard[ iWalk ].name == _tScoreBoard[ iMatch ].name and
        _tScoreBoard[ iWalk ].EoGColour == _tScoreBoard[ iMatch ].EoGColour and
        _tScoreBoard[ iWalk ].EoGShape == _tScoreBoard[ iMatch ].EoGShape and
        _tScoreBoard[ iWalk ].numScore == _tScoreBoard[ iMatch ].numScore and
        _tScoreBoard[ iWalk ].numTurns == _tScoreBoard[ iMatch ].numTurns and
        _tScoreBoard[ iWalk ].numColours == _tScoreBoard[ iMatch ].numColours and
        _tScoreBoard[ iWalk ].numShapes == _tScoreBoard[ iMatch ].numShapes and
        _tScoreBoard[ iWalk ].numBRCards == _tScoreBoard[ iMatch ].numBRCards and
        _tScoreBoard[ iWalk ].numBRSymbs == _tScoreBoard[ iMatch ].numBRSymbs and
        _tScoreBoard[ iWalk ].numBRTurns == _tScoreBoard[ iMatch ].numBRTurns then
          table.remove(_tScoreBoard, iMatch)
          _tScoreBoard.bScoreEDITED = true
          iWalk = iWalk -1
          break
        else
          iMatch = iMatch +1
        end
      end
      iWalk = iWalk +1
    end
    return _tScoreBoard
  end
end

function reBuildName( _name, _iLetterRow, _letter )     --RETURN THE PLAYER CHANGED NAME AS IS
  --  if _iLetterRow > 1 then --and _iLetterRow <= #_name then      --_iLetterRow IN THE MIDDLE
  return string.sub( _name, 1, _iLetterRow -1) .. _letter .. string.sub( _name, _iLetterRow +1, #_name )
  --  end
end

function removeDuplicateSBNames( _table )
--  _table = { "DREAMING-AWAKE","WAVEY-DAVEY","DREAMING-AWAKE","DREAMING-AWAKE","WAVEY-DAVEY","RONNEY-RAY-GUY","SILVER-FISH","NAME-SMOKER-ACTION","NAME-SMOKED-FOOD", "YOUVE-NEVER-BEEN-NOW", "MY-GOODNESS-GREENS","MY-GOODNESS-GREENS" } --WORKED PERFECTLY
  local iMatch, iWalk =1,1
  if #_table > 1 then
    while iWalk ~= #_table +1 do
      iMatch = iWalk +1
      while iMatch ~= #_table +1 do
        if _table[iWalk] == _table[iMatch] then
          table.remove(_table, iMatch)
          iWalk = iWalk -1
          break
        else
          iMatch = iMatch +1
        end
      end
      iWalk = iWalk +1
    end
    return _table
  end
end

function scoreInsert( _user ,_tScore, _tPredicted, _tSB ) --return _tScore, _tSB
  -- *** tSM.curState == "EDIT-SB"  --FLAG CHANGES SHOULD BE MADE WHEN USERS SCORE(s) INJECTED INTO SCOREBOARD ***
  local bINJECT = true
  if _user == "COMP" then
    _user = "COMP-BASE-LINE"
    bINJECT = false
  end
  local _table = {}
  --_tColour = colourShift( _colour ) -- +1 index of colour return table, restart "Yellow"
  _table.EoGColour = _tPredicted.pColour
  _table.EoGShape = _tPredicted.pShape
  _table.sound = "MPC-BEAT"                 --"MPC-BEAT"
  _table.cName, _table.tColourName = colourShift( _tPredicted.pColour )--do we need ,_ ?
  _table.name = _user
  _table.numCor = _tScore.tlCorr
  _table.numErr = _tScore.tlErr /2
  _table.numColours = _tScore.tlCol
  _table.numShapes = _tScore.tlShape
  _table.numCards = _tScore.tlCards
  _table.numScore = _tScore.tlScore
  _table.numSymbs = _tScore.tlSymb
  _table.numTurns = _tScore.tlAidTurns
  _table.numBRCards = _tScore.tlBRCard
  _table.numBRSymbs = _tScore.tlBRSymb
  _table.numBRTurns = _tScore.curGameTurn   --CORRECT
  _table.numEEggs = _tScore.EEggs
  --_table.tColourName = colourEcco( "tbl", "Orange", 0 )
  _table.tEoGcolour = colourEcco( "tbl", _tPredicted.pColour, 0 )
    --tName = { _name:match( (_name:gsub(".", "(.)")) ) }
  local i = 1  --SCOREBOARD INDEX
  --LOCATE WHERE TO SLOT IN THE NEW TABLE WITHIN THE SCOREBOARD
  while i ~= #_tSB +1 do
    if tonumber( _tSB[i].numScore ) < tonumber( _table.numScore ) then         
      table.insert( _tSB, i, _table )       --WORKS FOR LOWEST SCORE & HIGHEST SCORE
      if bINJECT then                       --INSERT RECORDED FOR SCOREBOARD EDITING
        _tSB.iUserEditSB = i
      end
      break
    elseif i >=  #_tSB then
      table.insert( _tSB, _table )          --LOWEST SCORE INJECTION
      if bINJECT then
        _tSB.iUserEditSB = #_tSB            --INSERT RECORDED FOR SCOREBOARD EDITING
      end
      break
    else
      i = i +1
    end
  end
  return _tScore, _tSB
end

function abCorrect(a,b)
  if a == b then
    return true
  else
    return false
  end
end

function scoreUp( _var ,_points, _bX10 )
  if _bX10 then    --BONUS ROUND MODE
    return _var + _points *10
  else
    return _var + _points
  end
end

function scoreCardOrBRcard( _tScore, _points, _bx10 ) --DEFAULT false
  if _tScore.level == 10 then
    _tScore.tlBRCard = scoreUp( _tScore.tlBRCard, _points, _bx10 )
  elseif _tScore.level == 9 then
    _tScore.tlCards = scoreUp( _tScore.tlCards, _points, _bx10 )
  elseif _tScore.level < 9 then
    _tScore.tlCards = scoreUp( _tScore.tlCards, _points, _bx10 )
  end
  return _tScore
end

function chkAllEoGERR( _tScore ) 
  if _tScore.level == 9 then
    if _tScore.tlCorr == 0 and _tScore.tlCol == 0 and _tScore.tlShape == 0 and
    _tScore.tlCards == 0 and _tScore.tlSymb == 0 then
      return true
    end
  end
end

-- *** SYMBOL BONUS PER-TURN MATCHING FOR COMPUTER & USER AT LEVEL 9 ***
function gotSymbols( _tPredicted, _tScore )
  --tScreenCard.shape, tScreenCard.colour
  --ONSCREEN MATCH OF EoG FACE CARD PER-TURN
  if tScreenCard.colour == _tPredicted.pColour and tScreenCard.shape == _tPredicted.pShape and
  tScreenCard.colour == _tPredicted.pCturn and tScreenCard.shape == _tPredicted.pSturn then
    _tPredicted.bptEoGCARD = true
  else
    _tPredicted.bptEoGCARD = false
  end
  --ONSCREEN SYMBOL MATCH PER-TURN PLAY
  if _tPredicted.bptDisplayedSYMB and _tPredicted.pColour == _tPredicted.pCturn and
  _tPredicted.pShape == _tPredicted.pSturn then
    _tPredicted.bptHitSYMB = true
  else
    _tPredicted.bptHitSYMB = false
  end
  --  if _tPredicted.bptHitSYMB and _tPredicted.bptEoGCARD then
  --    _tScore.bEEgg = true
  --  else
  --    _tScore.bEEgg = false
  --  end
  return _tPredicted, _tScore
end

function scoreERR(  _tScore, _bCOLOUR, _bSHAPE, _bCARD, _bEoGCARD, _bSYMBOL )
  if _bCOLOUR then
    _tScore.corr = scoreUp( _tScore.corr, .5, false )      --SINGLE CORRECT [2]   --CAN BE RESET
    _tScore.tlCorr = scoreUp( _tScore.tlCorr, .5, false )  --UP TOTAL CORRECT
    _tScore.tlCol = scoreUp( _tScore.tlCol, .5, false )
  end
  if _bSHAPE then
    _tScore.corr = scoreUp( _tScore.corr, .5, false )
    _tScore.tlCorr = scoreUp( _tScore.tlCorr, .5, false )  --UP TOTAL CORRECT
    _tScore.tlShape = scoreUp( _tScore.tlShape, .5, false )--UP SHAPE TOTAL
  end
  if _bCARD or _bEoGCARD then
    _tScore.tlCol = scoreUp( _tScore.tlCol, .5, false )
    _tScore.tlShape = scoreUp( _tScore.tlShape, .5, false )
    _tScore = scoreCardOrBRcard( _tScore, 1, false )
  end
  if not _bCOLOUR then
    _tScore.tlErr = scoreUp( _tScore.tlErr, .5, false )
    _tScore.err = scoreUp( _tScore.err, .5, false )
  end
  if not _bSHAPE then
    _tScore.tlErr = scoreUp( _tScore.tlErr, .5, false )
    _tScore.err = scoreUp( _tScore.err, .5, false )
  end
  if _bSYMBOL then
    if _tScore.level == 9 then
      _tScore.tlSymb = scoreUp( _tScore.tlSymb, 1, false )          --BR SYMB +1
    elseif _tScore.level == 10 then
      _tScore.tlBRSymb = scoreUp( _tScore.tlBRSymb, 1, false )          --BR SYMB +1
    end
    if _tScore.err >= 2 then
      _tScore.err = scoreUp( _tScore.err, -2, false )
    end
  end
  return _tScore
end
--DAY 141 AND IT'S TIME TO UPGRADE OUR LEVELING ABOUT IN THE TRAINING AID GAME
function levelAdjust( _tScore )
  --6C = L9,          3C +1L,   
  --3E = L5 from L9,  2E -1L,   
  if _tScore.corr >= 6 then
    _tScore.level = 9
    _tScore.corr = 0
    _tScore.err = 0
  elseif _tScore.corr >= 3 and _tScore.level < 5 then
    _tScore.level = _tScore.level +1
    if _tScore.err > 1 then
      _tScore.err = _tScore.err -1
    end
  end
  if _tScore.err >= 3 and _tScore.level == 9 then
    _tScore.level = 5
    _tScore.corr = 0
    _tScore.err = 0
  elseif _tScore.err >= 2 and _tScore.level >= 3 and _tScore.level < 9 then
    _tScore.level = _tScore.level -1
    _tScore.corr = _tScore.corr -1
  end
  return _tScore
end

--BEFORE SCORE ADJUSTMENTS HAPPEN - GIVE BACK PLAYERS THEIR 1 FREE TURN LIKE IT USED TO BE
function setBRturns( _tScore, _tPredicted )  --COMP & USER EARN THEIR WAY INTO BONUS ROUND, A FUN FOR ALL REFLEX GAME
  if _tScore.tlCards + _tScore.tlSymb > 0 then
    _tScore.earnedBRTurns = _tScore.earnedBRTurns + _tScore.tlCards + _tScore.tlSymb
    _tPredicted.bGoBR = true
  else
    _tScore.earnedBRTurns = 1   --IF NO BR TURN EARNED, PLAYER WILL NOW GET 1 FREE TURN
    _tPredicted.bGoBR = true    --WHY WAS PLAYER GIFTED 1 TURN FOR BR? YOU DID POORLY IN TRAINING
    _tPredicted.bEoG2 = false    --SOMEONE DIED [ BUT-LIVED-2025-WORLD-TOUR ]
  end
  _tScore.tlAidTurns = _tScore.curGameTurn
  _tScore.curGameTurn = 1
  return _tScore, _tPredicted
end

function scoreChanges( _tPredicted, _tScore, _player )    -- *** STILL MISSING THE BONUS FOR <L9, WHERE USER EoG CARD HAS SHOWN UP AND YOUR GOT IT CORRECT - WAITING ***
  if _tScore.level >= 9 then     --STRONG HINT THAT ONE NEEDS TO ACHIEVE LEVEL 9 IF YOU WANT REALLY BEAT THE COMUTER BASELINE
    _tPredicted, _tScore = gotSymbols( _tPredicted, _tScore )
  end   --tUserPredicted, tUserScore & tCompPredicted, tCompScore
  _tPredicted, _tScore, _tNarrTalk = adjustScore( tCurrentCard.c1, tCurrentCard.shape, _tPredicted, _tScore, _player )
  return _tPredicted, _tScore, _tNarrTalk
end

function adjustScore( _blindColour, _blindShape, _tPredicted, _tScore, _player )  --, _tFeedbk )
  -- *** END OF GAME SCORE ADJUSTMENTS - PROGRAM COULD USE DATA TO MAKE GOOD GUESS ABOUT TIMING IF WE KEEP THAT DATA, THEN IT COULD AVERAGE ***      _tPredicted.EoGturns as Bonus
  local _tNarrTalk = {}
  local _pCturn, _pSturn = _tPredicted.pCturn, _tPredicted.pSturn
  --POINTS SYSTEM - feedback ScoreGrade
  local sg1 = 10                                    -- <L9
  local sg2css = 100                                --COLOUR, SHAPE, SYMBOL
  local sg3Card = 200                               --CARD
  --LOW HANGING COMP FRUIT
  local sg4pEoGErr    = sg3Card *2                  --200x10 PREDICTED TOTAL GAME ERRORS
  local sg4pEoGAllErr = sg2css /2                   --5100 ALL ERROR x10 xTURNS
  --NOT LOW HANGING FRUIT, TOP BRANCH FRUIT PICK
  local sg5pTriFaceCard = sg3Card + sg2css          --3000 EoG FACE CARD +SYMBOL
  local _bCOLOUR = abCorrect( _blindColour, _pCturn )    --per turn correct not EoG prediction
  local _bSHAPE = abCorrect( _blindShape, _pSturn )      --per turn correct not EoG prediction
  local _bCARD = _bCOLOUR and _bSHAPE
  local _bSYMBOL = _tPredicted.bptHitSYMB
  local _bEoGCARD = _tPredicted.bptEoGCARD
  -- *** EASTER EGG *** THE 1 TURN WOW BONUS
  local _bEasterEGG = _bSYMBOL and _bEoGCARD        --later 0 or 1 or 2
  local _bEoGERR = false
  local _bEoGAllERR = false
  --local _bHouseOfCARDS = false  --is all errors above
  local _bx10 = false
  -- *** SEPERATE BLOCK HERE FOR DEALING WITH ERRORS & CORRECTS ***
  _tScore = scoreERR( _tScore, _bCOLOUR, _bSHAPE, _bCARD, _bEoGCARD, _bSYMBOL )
  --UPDATE TURNS +1 & SET EoG STATUS & SET BONUS ROUND STAGE
  if _tScore.curGameTurn == _tScore.earnedBRTurns then --and _tPredicted.bGoBR then
    _tPredicted.bEoG2 = true   --FLIPS BOOL NARR2
    _bx10 = true                --INCREASES PAYOUT
  elseif _tScore.curGameTurn == _tPredicted.EoGturns and not _tPredicted.bEoG1 then
    _tPredicted.bEoG1 = true   --FLIPS BOOL NARR1
    _tScore, _tPredicted = setBRturns( _tScore, _tPredicted )   --set L10
    _bx10 = true                --INCREASES PAYOUT
  elseif not _tPredicted.bEoG1 or not _tPredicted.bEoG2 then
    _tScore.curGameTurn = _tScore.curGameTurn +1
    _bx10 = false
  end
  
  --TIME TO PAYOUT OUT THE SCORES
  if _bCOLOUR then
    if _tScore.level < 9 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg1, _bx10 )
    elseif _tScore.level == 9 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg2css, _bx10 )
    elseif _tScore.level == 10 then   --MEANING BONUS ROUND
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg2css, _bx10 )
    end
  end
  if _bSHAPE then
    if _tScore.level <= 9 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg2css, _bx10 )
    elseif _tScore.level == 10 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg2css, _bx10 )
    end
  end
   --[[ --LOTTO WINNING TIMING WISE @ EoG1
   EoG1 SYMB   1/3 GAME TURNS IN BR    else EoG2
   EoG1 CARD   2/3 GAME TURNS IN BR    else EoG2
   EoG1 EEgg   *.5 GAME TURNS IN BR    else EoG2 sg5pTriFaceCard
   ]]
  if _bEasterEGG then
    if _tPredicted.bEoG2 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg5pTriFaceCard *10, _bx10 )  --4000ish
      _tScore = scoreCardOrBRcard( _tScore, 1, false ) --SEPERATE BRCARDS FROM CARDS
    elseif _tPredicted.bEoG1 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg5pTriFaceCard *10, _bx10 )  --4000ish
      _tScore.earnedBRTurns = math.floor(( _tScore.earnedBRTurns + _tPredicted.EoGturns ) *.5 )
      _tScore = scoreCardOrBRcard( _tScore, 1, false )
    else
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg5pTriFaceCard, _bx10 )
      _tScore = scoreCardOrBRcard( _tScore, 1, false )
      _tScore = scoreCardOrBRcard( _tScore, 1, false )
    end
    _tScore.EEggs = scoreUp( _tScore.EEggs, 1, false )  --1 Egg far easier than 2
    _tScore.err = 0
  else
    if _bCARD or _bEoGCARD then
      if _tPredicted.bEoG2 then
        _tScore.tlScore = scoreUp( _tScore.tlScore, sg3Card *10, _bx10 )
      elseif _tPredicted.bEoG1 then
        _tScore.tlScore = scoreUp( _tScore.tlScore, sg3Card *10, _bx10 )
      else    --NOT THE END OF GAME
        _tScore.tlScore = scoreUp( _tScore.tlScore, sg3Card, _bx10 )
      end
    end
    if _bSYMBOL then
      if _tPredicted.bEoG2 then
        _tScore.tlScore = scoreUp( _tScore.tlScore, sg2css *10, _bx10 )
      elseif _tPredicted.bEoG1 then
        _tScore.tlScore = scoreUp( _tScore.tlScore, sg2css *10, _bx10 )
      else                    --NOT THE END OF GAME
        _tScore.tlScore = scoreUp( _tScore.tlScore, sg2css, _bx10 )
      end
    end
  end
  
  if _tPredicted.pEoGErrs == _tScore.tlErr /2 and ( _tPredicted.bEoG1 or _tPredicted.bEoG2 ) then
    _bEoGERR = true
  end
  if _bEoGERR then          --GUESS THE CORRECT NUMBER OF ERRORS IN THE GAME
    if _tPredicted.bEoG2 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg4pEoGErr, _bx10 )
    elseif _tPredicted.bEoG1 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg4pEoGErr, _bx10 )
    end
  end
  
  _bEoGAllERR = chkAllEoGERR( _tScore )
  if _bEoGAllERR then       --NOTHING BUT ERRORS ALL THE WAY THROUGH
    if _tPredicted.bEoG1 or _tPredicted.bEoG2 then
      _tScore.tlScore = scoreUp( _tScore.tlScore, sg4pEoGAllErr *_tPredicted.EoGturns, _bx10 )
    end
  end
  --and _player == "USER" then
  if _bCOLOUR and _bSHAPE and _player == "USER" then
    table.insert( _tNarrTalk, {"main",30} )     --CORA'S BASS BY ME WITH AN ELICTRIC WESTERN FEEL
    table.insert( _tNarrTalk, {"main",11} )     --"BOTH"     --{"main",24} )
    table.insert( _tNarrTalk, {"main",10} )     --"CORRECT"
  elseif _bCOLOUR and _player == "USER" then
    table.insert( _tNarrTalk, {"colours",9} )   --"COLOUR"
    if not _bSYMBOL then
      table.insert( _tNarrTalk, {"main",10} )     --"CORRECT"
    end
    if _tScore.level < 9 and not _bSYMBOL then
      table.insert(_tNarrTalk, {"main",12} )    --"WAS"
      table.insert(_tNarrTalk, {"sLookup",_blindShape} ) --"Shape"
    end
  elseif _bSHAPE and _player == "USER" then
    table.insert( _tNarrTalk, {"shapes",9} )    --"SHAPE"
    if not _bSYMBOL then
      table.insert( _tNarrTalk, {"main",10} )     --"CORRECT"
    end
    if _tScore.level < 9 and not _bSYMBOL then
      table.insert(_tNarrTalk, {"main",12} )    --"WAS"
      table.insert(_tNarrTalk, {"cLookup",_blindColour} ) --"Colour"
    end
  elseif not _bCOLOUR and not _bSHAPE and _player == "USER" then
    if _tScore.level < 9 and not _bSYMBOL then
      table.insert(_tNarrTalk, {"main",12} )    --"WAS"
      table.insert(_tNarrTalk, {"cLookup",_blindColour} ) --"Colour"
      table.insert(_tNarrTalk, {"sLookup",_blindShape} ) --"Shape"
    end
  end
  if _bEasterEGG and _player == "USER" then                           -- *** THE LOTTO WIN EQUILIVANT ***
    table.insert( _tNarrTalk, {"main",30} )     --CORA'S BASS BY ME WITH AN ELICTRIC WESTERN FEEL
    table.insert( _tNarrTalk, {"main",29} )     --ME ON CORA'S BASS SLIDING
    table.insert( _tNarrTalk, {"main",31} )     --Wavey Bending
  else
    if _bSYMBOL and _player == "USER" then              -- *** SYMBOL ***
      table.insert( _tNarrTalk, {"main",29} )   --ME ON CORA'S BASS SLIDING
      table.insert( _tNarrTalk, {"main",23} )   --SYMBOL
      table.insert( _tNarrTalk, {"main",10} )   --CORRECT
    end
    if _tPredicted.bptEoGCARD and _player == "USER" then
      table.insert( _tNarrTalk, {"main",29} )   --ME ON CORA'S BASS SLIDING
    elseif _bHouseOfCARDS and _player == "USER" then        
      table.insert( _tNarrTalk, {"main",27} )   --27-BURNED DOWN THE HOUSE OF CARDS
      table.insert( _tNarrTalk, {"main",28} )   --NOTHING BUT ERRORS
    end
  end
  if _tPredicted.bEoG2 and _player == "USER" then
    table.insert( _tNarrTalk, {"main",26} )     --Guitar Wow like
    table.insert( _tNarrTalk, {"main",14} )     --End of
    table.insert( _tNarrTalk, {"main",15} )     --Game
    tScoreBoard.bQUARTER = true   --NO LCS-TA WITHOUT MANUAL INSERT OF A QUARTER == SWoE
  elseif _tPredicted.bEoG1 and _tPredicted.bGoBR and 
  tUserScore.curGameTurn == 1 and _player == "USER" then
    table.insert( _tNarrTalk, {"main",26} )     --Guitar Wow like
    table.insert( _tNarrTalk, {"main",17} )     --Bonus Round
    _tScore.level = 10
    tScoreBoard.bQUARTER = true   --NO LCS-TA WITHOUT MANUAL INSERT OF A QUARTER == SWoE
  end
  if #_tNarrTalk == 0 and _player == "USER" then
    table.insert(_tNarrTalk, {"main",24} )      --"DRIP" SO WE KNOW THE CARD CHANGED
  end
  _tPredicted.bptHitSYMB = false
  _tPredicted.bptEoGCARD = false
  iSpeak = 1
  if _tScore.level < 10 then           --NOT BONUS ROUND
    _tScore = levelAdjust( _tScore )  -- LEVEL, CORRECT, ERRORS
  end
  return _tPredicted, _tScore, _tNarrTalk
end