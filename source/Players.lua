--[[
Brian T.Wilcox
twingears@gmail.com
]]
function resetPlayers()
  tCompScore:reset()              --RESET POPULATES OUR TABLES
  tCompPredicted:reset()
  tUserPredicted:reset()
  tUserScore:reset()
  tCurrentCard:reset()            --RESET CurrentCard TABLE
end

function screenReset()
  tColour5 = {}                                             --RESET GLOBAL TABLE FOR SWAPING ABOUT CARDS FOR QUESTION
  tCurrentCard.shape, tCurrentCard.sIndex = rndShape()      --QUESTION SHAPE
  tCurrentCard.c1, tCurrentCard.c2, tCurrentCard.c3, tCurrentCard.c4, tCurrentCard.c5 = rndCards5()  --5 COLOUR QUESTION DATA
  tCurrentCard.rndQc1c5 = math.random(1, tUserScore.level)  --rndQc1c5 BECOMES NEW INDEX FOR COLOUR SHUFFLE
  local iFloat = tCurrentCard.rndQc1c5                      --POINT TO 1 OF 5 COLOURS, STARTING PLACE FOR COLOUR QUESTION
  tCurrentCard.doneCHOICE = true                            --doneCHOICE SO THIS CODE BLOCK IS RUN ONCE ONLY
  local tColourChoices = { tCurrentCard.c1, tCurrentCard.c2, tCurrentCard.c3, tCurrentCard.c4, tCurrentCard.c5 }  --NEW TO KEEP INDEX SWAP POSSIBLE
  buildCard( tCurrentCard.c1, tCurrentCard.shape, 1)        --LOAD UP VISUAL ANSWER, THEN ASK SPEAK THE QUESTION
  tutorColour = {}                                          --TUTOR TABLE
  table.insert( tutorColour, tCurrentCard.c1 )
  if tUserScore.level < 9 then
    for i = 1, tUserScore.level do                           --WILL DO 2 TO 5 CARD SHUFFLE
      table.insert( tColour5, tColourChoices[ iFloat ] ) --tColour5 RE-ORDERED/SHUFFLED AS QUESTION
      if iFloat == tUserScore.level then
        iFloat = 1
      else
        iFloat = iFloat +1
      end
    end
    tUserPredicted.bptDisplayedSYMB = false   --ON SCREEN BONUS RESET
    tCompPredicted.bptDisplayedSYMB = false
  else
    tUserPredicted.bptDisplayedSYMB = false
    tCompPredicted.bptDisplayedSYMB = false
    symbolBonusDraw()   --IF L9 THEN DECIDE IF THIS TURN GET TO SEE A BONUS SYMBOL ON-SCREEN
  end
  dtCounter = 0
  --tUserScore.isSELECTED = false   --STOP USER FROM GETTING FALSE POSITIVE MULTI BONUSES FROM JUST 1 BONUS
end

function boolFLIP( _bool )  --BOOL BIT FLIP
  return not _bool
end

function bool2bin( _flag )
  if _flag then
    return 1
  else 
    return 0
  end
end

function compPredictEoG( _tScoreBoard )
  --COMPUTER PREDICTION NEEDS TO BE ALINED WITH SAME WINDOW AS USER AS CURRENT LEVEL OF QUESTION, 
  tCurrentCard.shape, tCurrentCard.sIndex = rndShape() --SHAPE, index
  tCurrentCard.c1, tCurrentCard.c2, tCurrentCard.c3, tCurrentCard.c4, tCurrentCard.c5 = rndCards5()  --5 COLOUR QUESTION DATA
  tCompPredicted.pColour, _tScoreBoard.iListColour = rndColour()   --SET INDEX
  tCompPredicted.pShape, _tScoreBoard.iListShape = rndShape()      --SET INDEX
  buildCard( tCompPredicted.pColour, tCompPredicted.pShape ,1 )   --SPOON FEED DATA INTO 1st CARD USER SEES COMPUTER PREDICTION
  --NEED TO TAKE THOSE tSB.iListC&S AND UPDATE THE tSB-TEXT VALUES
  return _tScoreBoard
end

function compGuessL2L9()    --IMPROVED COMPUTER BASE LINE GUESS THE SAME AS USER QUESTION DIFFICULTLY
  local _guess = math.random(1, tonumber(tUserScore.level))
  local tColours = { tCurrentCard.c1, tCurrentCard.c2, tCurrentCard.c3, tCurrentCard.c4, tCurrentCard.c5 }
  
  if tUserScore.level < 9 then
    return tColours[ _guess ]      --returning to tCompPredicted.pCturn
  elseif tUserScore.level >= 9 then --NEED IT WORKING FOR L10 NOW
    return rndColour()
  end
end

function locateIndex(_table, _letter) --HUNT THE INDEX
  for i=1, #_table do
    if _table[i] == _letter then
      return i
    end
  end
  return 1
end

function buildCard( _colText, _shape, _alpha )   -- *** POPULATE TABLE tScreenCard.VARS FOR drawCard() TO WORK ***
  local _tcolour = colourEcco( "tbl", _colText, 0 )      --TRANSLATE TEXT TO COLOUR TABLE
  if _alpha <1 then
    _tcolour[4] = _alpha
  end
  local _mode = rndShapeB()                         --DEFAULT SHAPES TO "fill" or "line"
--  _shape = "Pentagon"   --DEBUG DEFAULT
  tScreenCard.shape   = _shape
  tScreenCard.tColour = _tcolour
  tScreenCard.colour  = _colText
  tScreenCard.mode    = _mode
  --CENTER VALUES 1st AS TO SAVE RETYPING CODE AGAIN AND AGAIN
  tScreenCard.xStart = math.floor( tPortHole.W /2 )
  tScreenCard.yStart = math.floor( tPortHole.H /2 )
  if _shape == "Circle" then          --CIRCLE NEEDS TO WORK FROM CENTER POINT OF FRAME
    tScreenCard.radius = math.floor( tPortHole.frameW /2 )
  elseif _shape == "Diamond" then             --love.graphics.polygon( )
    tScreenCard.yStart = tPortHole.yFrame
    tScreenCard.x2 = tPortHole.x2Frame
    tScreenCard.y2 = tPortHole.H /2
    tScreenCard.x3 = tScreenCard.xStart
    tScreenCard.y3 = tPortHole.y2Frame
    tScreenCard.x4 = tPortHole.xFrame
    tScreenCard.y4 = tScreenCard.y2
  elseif _shape == "Triangle" then
    tScreenCard.yStart = tPortHole.yFrame
    tScreenCard.x2 = tPortHole.x2Frame
    tScreenCard.y2 = tPortHole.y2Frame
    tScreenCard.x3 = tPortHole.xFrame
    tScreenCard.y3 = tPortHole.y2Frame
  elseif _shape == "Square" then				 --x   ,y	  w	  ,h
    tScreenCard.xStart = tPortHole.xFrame
    tScreenCard.yStart = tPortHole.yFrame
    tScreenCard.sWidth = tPortHole.frameW
    tScreenCard.sHeight = tPortHole.frameH
  --FLOWER AND HEXAGON ARE NOT SQUARE AND THUS NEED DIFFERENT HEIGHT ADJUSTMENTS
  elseif _shape == "Pentagon" or _shape == "Hexagon" or _shape == "Flower" or _shape == "Heart" then
    tScreenCard.xStart = tPortHole.xFrame
    tScreenCard.yStart = tPortHole.yFrame
    tScreenCard.scaleFrameX = tPortHole.scaleFrame
    tScreenCard.scaleFrameY = tPortHole.scaleFrame
    if _shape == "Pentagon" then                --Pentagon image size is 1000 x951
      tScreenCard.yStart = tPortHole.yFrame + (1000-951)/2 *tPortHole.scaleFrame
    elseif _shape == "Hexagon" then             --Hexagon image size is 1000 x866
      tScreenCard.yStart = tPortHole.yFrame + (1000-866)/2 *tPortHole.scaleFrame
    elseif _shape == "Flower" then              --Flower image size is 1000 x964
      tScreenCard.yStart = tPortHole.yFrame + (1000-964)/2 *tPortHole.scaleFrame
    end
  end
end