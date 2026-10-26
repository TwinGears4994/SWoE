--[[
Brian T.Wilcox
twingears@gmail.com
]]
--DISPLAY THE PER-TURN SYMBOL - LEVEL 9 & 10
function symbolBonusDraw()                    --PER-TURN PLAY  tBonusFlags = { bUSER =false, bCOMP =false, draw ="USER" }
  local _ran1 = math.random(1, 2)             --USER OR COMP SYMBOL
  local _ran2 = math.random(1, 6)             --1/6 CHANCES TO HAVE SYMBOL DISPLAYED
--  _ran1 = 1 --DEBUG ONLY TO FORCE SYMBOL EVERY TURN FOR TESTING
--  _ran2 = 3 --DEBUG ONLY
  if _ran2 == 3 then
    if _ran1 == 1 then
      tUserPredicted.bptDisplayedSYMB = true  --"USER"
    elseif _ran1 == 2 then
      tCompPredicted.bptDisplayedSYMB = true  --"COMP"
    else
      tUserPredicted.bptDisplayedSYMB = false
      tCompPredicted.bptDisplayedSYMB = false
    end
  end
end

function drawSymbolSB( _player )
  local x = tPortHole.xbdr
  local y = tPortHole.ybdr + tPortHole.frameH
  if _player == "COMP-BASE-LINE" then
    love.graphics.setColor( {.85,.85,.85,1} )             --DIALED BACK WHITE
    love.graphics.draw( compImage, x, y, 0, tPortHole.scaleFrame, tPortHole.scaleFrame )
  elseif _player == "USER" then --MUST BE IN IT'S ORGINAL HOLOGRAPHICS COLOUR AS IT WAS IN THE EARLY 90'S, WELL FOR MY PERSONAL TRAINING PROGRAM!
    love.graphics.setColor( { 0,1,0,1 } ) 
    love.graphics.draw( userImage, x, y, 0, tPortHole.scaleFrame, tPortHole.scaleFrame )
  end
end

function drawSymbol() -- _player )
  local x = tPortHole.xbdr
  local y = tPortHole.ybdr + tPortHole.frameH
  if tCompPredicted.bptDisplayedSYMB then
    love.graphics.setColor( {.85,.85,.85,1} )             --DIALED BACK WHITE
    love.graphics.draw( compImage, x, y, 0, tPortHole.scaleFrame, tPortHole.scaleFrame )
  elseif tUserPredicted.bptDisplayedSYMB then
    love.graphics.setColor( { 0,1,0,1 } ) --MUST BE IN IT'S ORGINAL HOLOGRAPHICS COLOUR AS IT WAS IN THE EARLY 90'S, WELL FOR MY PERSONAL TRAINING PROGRAM!
    love.graphics.draw( userImage, x, y, 0, tPortHole.scaleFrame, tPortHole.scaleFrame )
  end
end

function drawBlackOut()
  --  1.7MB for a few loops until Narrator is intrupted
  --local introImage = love.graphics.newImage("source/Art/Art Hack-RainbowBody Carbon then Smallest Electrogravitics Craft.png")
  local introImage = love.graphics.newImage("source/Art/Art Hack-RainbowBody Carbon then Smallest Electrogravitics Craft.png")
  local sx = tPortHole.W /3071  --Both images use the same size of WxH pixels
  local sy = tPortHole.H /2008
  love.graphics.draw( introImage, 0,0,0,sx,sy )
  -- *** BELOW IS THE VISUAL DISPLAY OF HOW WE CUT UP THE SCREEN INTO PARTS, NO BLINDFOLD ***
    --  love.graphics.setBackgroundColor( {0,0,0,1} )  --BLACK SCREEN OTHER 2 TESTS ARE REMARKED OUT
    --  love.graphics.setColor(0, 0, 0, 1)
    --  love.graphics.rectangle( "fill",0,0, tPortHole.W, tPortHole.H )
    --  --GREEN BOARDER - LETS MAKE SURE THE BOARDER IS WHERE WE THINK IT SHOULD BE
    --  love.graphics.setColor(0, 1, 0, 1)
    --  love.graphics.rectangle( "fill", tPortHole.xbdr, tPortHole.ybdr, tPortHole.bdrW, tPortHole.bdrH )
    --  --BLUE FRAME - NOW FOR THE FRAME WHERE ALL THE COLOURED SHAPED CARDS LIVE
    --  love.graphics.setColor(0, 0, 1, 1)
    --  love.graphics.rectangle( "fill", tPortHole.xFrame, tPortHole.boarder *2,
    --    tPortHole.y2Frame - tPortHole.boarder *2, tPortHole.y2Frame - tPortHole.boarder *2 )
end

function drawCard()   --  bALPHA, alphaEoGCard, alphaSB
--  local _xOffSet = tPortHole.quarterW  --tScreenCard.xStart
  love.graphics.setColor( unpack( tScreenCard.tColour ) ) --SET COLOUR OF EoG CARD
  if tScreenCard.shape == "Circle" then
    love.graphics.circle( tScreenCard.mode, tScreenCard.xStart, tScreenCard.yStart, tScreenCard.radius )
  elseif tScreenCard.shape == "Diamond" then
    love.graphics.polygon( tScreenCard.mode, tScreenCard.xStart, tScreenCard.yStart, tScreenCard.x2, tScreenCard.y2,
      tScreenCard.x3, tScreenCard.y3, tScreenCard.x4, tScreenCard.y4 )
  elseif tScreenCard.shape == "Triangle" then       --x               y             x1             y1              x2            y2
    love.graphics.polygon( tScreenCard.mode, tScreenCard.xStart, tScreenCard.yStart, 
      tScreenCard.x2, tScreenCard.y2, tScreenCard.x3, tScreenCard.y3 )
  elseif tScreenCard.shape == "Square" then --shape         x         y               w           h
    love.graphics.rectangle( tScreenCard.mode,tScreenCard.xStart, tScreenCard.yStart, tScreenCard.sWidth, tScreenCard.sHeight )
  elseif tScreenCard.shape == "Pentagon" then
    love.graphics.draw(pentagon, tScreenCard.xStart, tScreenCard.yStart, 0, tScreenCard.scaleFrameX, tScreenCard.scaleFrameY ) --0 is rotation
  elseif tScreenCard.shape == "Hexagon" then
    love.graphics.draw(hexagon, tScreenCard.xStart, tScreenCard.yStart, 0, tScreenCard.scaleFrameX, tScreenCard.scaleFrameY ) --0 is rotation
  elseif tScreenCard.shape == "Flower" then
    love.graphics.draw(flower, tScreenCard.xStart, tScreenCard.yStart, 0, tScreenCard.scaleFrameX, tScreenCard.scaleFrameY ) --0 is rotation
  elseif tScreenCard.shape == "Heart" then
    love.graphics.draw(heart, tScreenCard.xStart, tScreenCard.yStart, 0, tScreenCard.scaleFrameX, tScreenCard.scaleFrameY ) --0 is rotation
  end
end

function drawQ1()
  love.graphics.setFont( gameFontLarge )  --gameFontLarge
  love.graphics.setColor( 0,1,0,1 ) --GREEN{ 0,.75,0,1}
  love.graphics.printf( "Change DEFAULT # of TURNS for EoG", tPortHole.xbdr, tPortHole.ybdr, tPortHole.bdrW, "left")
  love.graphics.printf( tostring( tUserPredicted.EoGturns ), tPortHole.xbdr, tPortHole.ybdr, tPortHole.quarterW *3, "right")
end

function drawQ2()
  local _pad = tPortHole.ybdr *1.3
  love.graphics.setFont( gameFontLarge )  --gameFontLarge
  love.graphics.setColor( 0,1,0,1 )    --GREEN or RED{.65,0,0,1}
  love.graphics.printf( "Change DEFAULT # of ERRORS at EoG", tPortHole.xbdr, tPortHole.ybdr, tPortHole.bdrW, "left")
  love.graphics.printf( tostring( tUserPredicted.pEoGErrs ), tPortHole.xbdr, tPortHole.ybdr, tPortHole.quarterW *3, "right")
  love.graphics.setColor( 1,.5,0,1 )    --ORANGE{1,.5,0,1}
  _pad = _pad + tPortHole.fontPixLarge
  love.graphics.printf( "TOP PLAYER ERROR SUGGESTION", tPortHole.xbdr, _pad, tPortHole.bdrW, "left")
  love.graphics.printf( tostring( math.floor(tScoreBoard.avgSB.first *tUserPredicted.EoGturns *10)/10 ), tPortHole.xbdr, _pad, tPortHole.quarterW *3, "right")
  _pad = _pad + tPortHole.fontPixLarge
  love.graphics.printf( "TOP 10 PLAYERS ERROR SUGGESTION", tPortHole.xbdr, _pad, tPortHole.bdrW, "left")
  love.graphics.printf( tostring( math.floor(tScoreBoard.avgSB.ten *tUserPredicted.EoGturns *10)/10 ), tPortHole.xbdr, _pad, tPortHole.quarterW *3, "right")
  _pad = _pad + tPortHole.fontPixLarge
  love.graphics.printf( "TOP OVER-ALL PLAYER AVERAGE ERRORS", tPortHole.xbdr, _pad, tPortHole.bdrW, "left")
  love.graphics.printf( tostring( math.floor(tScoreBoard.avgSB.allUser *tUserPredicted.EoGturns *10)/10 ), tPortHole.xbdr, _pad, tPortHole.quarterW *3, "right")
  _pad = _pad + tPortHole.fontPixLarge
  love.graphics.printf( "TOP OVER-ALL COMPUTER ERRORS", tPortHole.xbdr, _pad, tPortHole.bdrW, "left")
  love.graphics.printf( tostring( math.floor(tScoreBoard.avgSB.allComp *tUserPredicted.EoGturns *10)/10 ), tPortHole.xbdr, _pad, tPortHole.quarterW *3, "right")
end

function padPlus( _value )
  return _value + tPortHole.fontPixLarge + tPortHole.yPad
end

function drawPerTurnSB() --USER ON TOP OF SCOREBOARD LIKE BEFORE. COMP BELOW
  love.graphics.setFont( gameFontLarge )  --gameFontLarge
  local _EoG = false
  if tUserPredicted.bEoG1 or tCompPredicted.bEoG1 then
    _EoG = true
  end
  local _colour = tScreenCard.tColour
  _colour[4] = .7
  love.graphics.setColor( _colour ) --unpack( tScreenCard.tColour ) ) --SET COLOUR OF EoG CARD
  local yPad = tPortHole.boarder
  local x = tPortHole.xbdr
  local y = tPortHole.ybdr
  local pxW = tPortHole.quarterW *2
  --USER SCORE FIRST
  love.graphics.printf( "LEVEL: " .. tostring( tUserScore.level ), x, y, pxW, "left")
  yPad = padPlus( yPad )    --yPad + tPortHole.fontPixLarge + tPortHole.yPad
  if _EoG then
    love.graphics.printf( "TURNS: " .. tostring( tUserScore.curGameTurn) .. "/" .. tostring( tUserScore.earnedBRTurns ),  x, yPad, pxW, "left")
  else
    love.graphics.printf( "TURNS: " .. tostring( tUserScore.curGameTurn) .. "/" .. tostring( tUserPredicted.EoGturns ),  x, yPad, pxW, "left")
  end
  yPad = padPlus( yPad ) + tPortHole.yPad *3
  love.graphics.printf( "USER SCORE: " .. tostring( tUserScore.tlScore ),  x, yPad, pxW, "left") -- y=+40
  yPad = padPlus( yPad )
  love.graphics.printf( "COLOURS: " .. tostring( tUserScore.tlCol ),  x, yPad, pxW, "left")
  yPad = padPlus( yPad )
  love.graphics.printf( "SHAPES: " .. tostring( tUserScore.tlShape ),  x, yPad, pxW, "left")
  yPad = padPlus( yPad )
  love.graphics.printf( "CARDS (C&S): " .. tostring( tUserScore.tlCards ),  x, yPad, pxW, "left")
  yPad = padPlus( yPad )
  love.graphics.printf( "SYMBOLS: " .. tostring( tUserScore.tlSymb ),  x, yPad, pxW, "left")
  yPad = padPlus( yPad )
  yPad = padPlus( yPad ) + tPortHole.yPad *3
  --COMPUTERS SCORE AFTER THAT
  love.graphics.printf( "COMPUTER SCORE: " .. tostring( tCompScore.tlScore ),  x, yPad, pxW *2, "left") -- y=+40
  yPad = padPlus( yPad )
  love.graphics.printf( "COLOURS: " .. tostring( tCompScore.tlCol ),  x, yPad, pxW, "left")
  yPad = padPlus( yPad )
  love.graphics.printf( "SHAPES: " .. tostring( tCompScore.tlShape ),  x, yPad, pxW, "left")
  yPad = padPlus( yPad )
  love.graphics.printf( "CARDS: " .. tostring( tCompScore.tlCards ),  x, yPad, pxW, "left")
  yPad = padPlus( yPad )
  love.graphics.printf( "SYMBOLS: " .. tostring( tCompScore.tlSymb ),  x, yPad, pxW, "left")
end

function drawEoGSB()  --DRAW THE END OF GAME SCOREBOARD
  love.graphics.setFont( gameFontSmall )  --gameFontLarge
  local x  = tPortHole.boarder          --x COLOUMS
  local x2 = x + tPortHole.quarterW
  local x3 = x2 + tPortHole.oneSixthW
  local x4 = x3 + tPortHole.slice3W
  local x5 = x4 + tPortHole.slice3W
  local x6 = x5 + tPortHole.slice3W
  local yPad = tPortHole.boarder
  local xOut, yOut = 0, 0
  local _tColour = {}
  --DRAW HIGHLIGHTED CHANGING / SONG PLAYING LINE AND DIM REST OF SCOREBOARD
  love.graphics.setColor( 1,.5,0,1 )  --ORANGE IS OLD COLOUR FOR TOP INTUITIVES, EARLY 90's MEDITATION PROOF
  love.graphics.printf( "PLAYER", x, tPortHole.boarder, tPortHole.quarterW, "left")
  love.graphics.printf( "SCORE", x2, tPortHole.boarder, tPortHole.oneSixthW, "right" )
  love.graphics.printf( "TURNS", x3, tPortHole.boarder, tPortHole.slice3W, "right")
  love.graphics.printf( "CARDS", x4, tPortHole.boarder, tPortHole.slice3W, "right")  --SAME LENGTH REALLY HELPED
  love.graphics.printf( "SYMBS", x5, tPortHole.boarder, tPortHole.slice3W, "right")
  love.graphics.printf( "BRTURN", x6, tPortHole.boarder, tPortHole.slice3W, "right")
  yPad = yPad + tPortHole.fontPixLarge + tPortHole.yPad
  
  for i = 1, #tScoreBoard do                  --ROTATE THROUGH THE ENTIRE SCOREBOARD TABLE
    _tColour = tScoreBoard[ tScoreBoard.iUserEditSB ].tColourName
    if tScoreBoard.iUserEditSB == i then    --ACTIVE LINE WITHIN SCOREBOARD BY USER, NORMAL ALPHA CHANNEL
      _tColour[4] = 1
      love.graphics.setColor( _tColour )
      xOut, yOut = x, yPad
    else                                    
      _tColour[4] = .7  --EVERY OTHER SCORE LINE DIMMED ALPHA CHANNEL & .7 LOOKS GOOD
      love.graphics.setColor( _tColour )
    end
    love.graphics.printf( tostring( tScoreBoard[i].name ),  x,  yPad, tPortHole.quarterW, "left")   --NON EDITING DRAW
    love.graphics.printf( tostring( tScoreBoard[i].numScore ), x2, yPad, tPortHole.oneSixthW, "right" )
    love.graphics.printf( tostring( tScoreBoard[i].numTurns ), x3, yPad, tPortHole.slice3W, "right")
    love.graphics.printf( tostring( tScoreBoard[i].numCards + tScoreBoard[i].numBRCards ), x4, yPad, tPortHole.slice3W, "right")
    love.graphics.printf( tostring( tScoreBoard[i].numSymbs + tScoreBoard[i].numBRSymbs ), x5, yPad, tPortHole.slice3W, "right")
    love.graphics.printf( tostring( tScoreBoard[i].numBRTurns ), x6, yPad, tPortHole.slice3W, "right")
    yPad = yPad + tPortHole.yPad + tPortHole.fontPixLarge
  end
  return xOut, yOut
end

function drawHighLightSB( _iNest, _x, _y, _colour )
  love.graphics.setFont( gameFontSmall )  --gameFontLarge
  --CHANGE PLAYER NAME COLOUR AS WE KNOW THE CARD COLOUR SO SWITCH COLOURS AS CONTRAST
  local _, _tColour = colourShift( _colour ) -- +1 index of colour return table, restart "Yellow"
  love.graphics.setColor( _tColour )
  if tScoreBoard.iTwinGears == 4 then
    love.graphics.printf( string.sub( tScoreBoard[ _iNest ].name, 1, tScoreBoard.iLetterRow ),_x +1 ,_y +1, 512, "left" )
  end
end