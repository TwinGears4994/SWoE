--[[
Brian T.Wilcox
twingears@gmail.com
]]
function loadScore( _tScoreBoard )
  _table = love.filesystem.getInfo( "ScoreBoard.csv" )
  if _table.size > 0 then
    bOKAY, err = file:open( 'r' )
    local _tRawSBdata = {}
    for line in love.filesystem.lines( "ScoreBoard.csv" ) do --GETS ENTIRE LINE FROM FILE AND NOW LETS BREAK IT UP BY ","s
      if #line == 0 then
        break                             --or return score --IF IT'S NOT GLOBAL
      else
        local iWord = 0
        local tNest = {}                     --**NEW MOVE TO DEBUG
        for i =1, 17 do                    --NOW 8 ITEMS PER LINE OF FILE
          table.insert( tNest, string.match(line, "[^,]+", iWord) ) --line:match("[^,]+", iWord)
          if ( #tNest[ i ] +1 +iWord )  < #line then
            iWord = iWord + #tNest[ i ] +1     --KEEPING TRACK OF WHERE LAST COMMA WAS TO COUNT BEYOND IT
          end
        end
        table.insert( _tRawSBdata, tNest )   --, tonumber(line))
        iWord = 0
      end
    end
    file:close()
    _tScoreBoard = translate4SB( _tRawSBdata, _tScoreBoard )            --TRANSLATE COLOURS TO NUMBERS AND ASSIGNMENTS FOR EASIER USE OF CODING...
    _tScoreBoard = scrubDupliSB( _tScoreBoard )           --SCRUB SCOREBOARD OF DUPLICATES
    _tScoreBoard = orderSB( _tScoreBoard )                --RE-ORDER THE SCOREBOARD LIST TO MAKE SURE INSERT ISN'T BEING MIS-GUIDED
    tScoreBoard.avgSB.first, tScoreBoard.avgSB.ten, tScoreBoard.avgSB.allUser, tScoreBoard.avgSB.allComp = recycleSBData( _tScoreBoard )
    return _tScoreBoard
  end
end

function translate4SB( _table, _tScoreBoard )
  local i = 1
  while i ~= #_table +1 do    --REPACKAGE OUR ASSIGNMENTS TO THE DATA PER NEST/LINE OF THE SCORE FILE
    if tonumber( _table[i][11] ) > 0 then           --FILTER OUT SCORES OF ZERO
      table.insert( _tScoreBoard, 
        { EoGColour = _table[i][1],-- or "White",        --FACE CARD DATA
          EoGShape = _table[i][2],-- or "Circle",        --FACE CARD DATA
          sound = _table[i][3],-- or "MPC-BEAT",
          cName = _table[i][4],-- or "Yellow",           --COLOUR OF NAME IN SB
          name = _table[i][5],-- or "DUDE",              --SB HOLDERS NAME
          numCor = tonumber( _table[i][6] ),-- or 0,
          numErr = tonumber( _table[i][7] ),-- or 0,
          numColours = tonumber( _table[i][8] ),-- or 0,
          numShapes = tonumber( _table[i][9] ),-- or 0,
          numCards = tonumber( _table[i][10] ),-- or 0,
          numScore = tonumber( _table[i][11] ),-- or 0,
          numSymbs = tonumber( _table[i][12] ),-- or 0,
          numTurns = tonumber( _table[i][13] ),-- or 0,
          numBRCards = tonumber( _table[i][14] ),-- or 0,
          numBRSymbs = tonumber( _table[i][15] ),-- or 0,
          numBRTurns = tonumber( _table[i][16] ),-- or 0,
          numEEggs = tonumber( _table[i][17] ),   --SIGN OF SOMEONE GOT THE EASTER EGG @EoG!!!
          tColourName = colourEcco( "tbl", _table[i][1], 0 ),
          tEoGcolour = colourEcco( "tbl", _table[i][4], 0 ) }
        )
      --UPDATING THE POSSIBLE NAMES USER MIGHT WISH TO PICK FROM - TO BE CLEANED OF DUPLICATES
      table.insert(tListNames, _tScoreBoard[i].name)
    end
    i = i +1
  end
  return _tScoreBoard
end

function createFilesys()
--  love.filesystem.setIdentity("SWoE") --, true )  --$USER/.local/share/love/SWoE/    FOR WRITING AND READING, ALREADY SET IN conf.lua
  local fExists = love.filesystem.exists( "ScoreBoard.csv" )  --WORKS BUT .exists HAS BEEN REPLACED WITH .getInfo WHICH ISN'T RELIABLE LOGICALLY
--  local modtime, size, type = love.filesystem.getInfo( "ScoreBoard.csv" ) --ONLY REALLY USEFUL IF FILE EXISTS, OTHER WISE =nil DOESN'T BECOME FALSE LIKE WE WOULD LIKE
  if fExists == false then --love.filesystem.getInfo( "ScoreBoard.csv" ) == false then   --
    local success = love.filesystem.createDirectory( "" )
    file = love.filesystem.newFile( "ScoreBoard.csv", 'w' )    --file:open("r") didn't error! file:write & file:close
  else 
    file = love.filesystem.newFile( "ScoreBoard.csv" )
  end
  _table = love.filesystem.getInfo( "ScoreBoard.csv" )
  if _table.size > 0 then
    return true
  end
end

function saveScore( _tSB )
  while #_tSB > 1000 do   --TESTED FINE
    table.remove(_tSB, #_tSB)
  end
  local bOKAY, err = file:open("w")     --"w"rite mode will create a new empty file to write to
  if bOKAY and #_tSB > 0 then
    for i =1, #_tSB do
      file:write( --tostring( 
        _tSB[i].EoGColour ..","..
        _tSB[i].EoGShape ..","..
        _tSB[i].sound ..","..
        _tSB[i].cName ..","..
        _tSB[i].name ..","..
        _tSB[i].numCor ..","..
        _tSB[i].numErr ..","..
        _tSB[i].numColours ..","..
        _tSB[i].numShapes ..","..
        _tSB[i].numCards ..","..
        _tSB[i].numScore ..","..
        _tSB[i].numSymbs ..","..
        _tSB[i].numTurns ..","..
        _tSB[i].numBRCards ..","..
        _tSB[i].numBRSymbs ..","..
        _tSB[i].numBRTurns ..","..
        _tSB[i].numEEggs .."\n" )
    end
  end
  file:close()
  tScoreBoard.bScoreEDITED = false
end
