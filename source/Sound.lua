--[[
Brian T.Wilcox
twingears@gmail.com
]]
--"stream" music, short sound effects use "static".
function narSection( _section ) --WE ARE GOING TO HAVE TO CLEAN UP MAIN SINCE BONUS IS NOW BEING SEPERATED
  dtCounter = 0                                      --AS waitTime GETS NEW VALUE, IT'S ONLY USEFUL AS A COMPARE AGAINST dtCounter
  if _section == "INTRO" then
    --GET NARRATOR ONTO IT'S OWN FUNCTION TO PROCESS ON ONE CALL OF MANY sub (dt timings) counts, QUESTION THE RETURN CAPTURE SHAPE OF state
    local tTalk = { 
      {"intro",1},{"intro",2},                          --Welcome to SWoE, an interactive training aid, 
      {"intro",7},{"intro",3},{"intro",8},              --up, arrow, to reset display card
      {"intro",5},{"intro",3},{"shapes",9},             --left, arrow, shape,
      {"intro",6},{"intro",3},{"colours",9},            --right, arrow, colour, SELFINDEX
      {"intro",4},{"intro",3},{"main",8},               --down, arrow, enter - missing "select" as a word!
			{"main",4},{"main",34}
		}
    if iSpeak <= #tTalk then                            --IS NARRATOR DONE TALKING?
      iSpeak = narratorTalk( iSpeak, tTalk )            --IF INTURUPTED, KEYBOARD/JOYSTICK WILL CHANGE STATE EARLY
--      return false
    else
      iSpeak = 1
      waitTime = .3
      return true                                       --AS IN DONE TALKING NOW!
    end
    
  elseif _section == "Q1TURNS" then
    local tTalk = { {"main",7},{"main",5} }             --change, the last turn # in the game
    if iSpeak <= #tTalk then
      iSpeak = narratorTalk( iSpeak, tTalk )
    else
      iSpeak = 1                                        --RESET NARRATOR SOUND INDEX FOR NEXT SECTION TO TURN ON
      --waitTime = 10                                     --SOUND WILL REPEAT AS LOOP AFTER 10 SECONDS OF SILENCE
      return true
    end
    
  elseif _section == "Q2ERRORS" then
    local tTalk = { {"main",7},{"main",6} }             --change, ENTER THE # OF ERRORS
    if iSpeak <= #tTalk then
      iSpeak = narratorTalk( iSpeak, tTalk )
    else
      iSpeak = 1                                        --RESET NARRATOR SOUND INDEX FOR NEXT SECTION TO TURN ON
      --waitTime = 10
      return true
    end
    
  elseif _section == "MASK-ON" then
    iSpeak = narratorTalk( 1, { {"main",4} } )          --WITH YOUR MASK ON
    --waitTime = 2  --HAS NO EFFECT ON DELAYING NEXT SOUNDS
    iSpeak = 1
    --waitTime = 2.5  DOESN'T FLY
    return true
    
  elseif _section == "EoG-pUSER" then
    local tTalk = { {"cLookup",tCurrentCard.c1},{"sLookup",tCurrentCard.shape} }
    if tCurrentCard.navTalk then
      if iSpeak <= #tTalk then                            --IS NARRATOR DONE TALKING?
        iSpeak = narratorTalk( iSpeak, tTalk )
        if iSpeak == #tTalk +1 then
          tCurrentCard.navTalk = false
          iSpeak = 1
          waitTime = .5
        end
      end
    end
    
  elseif _section == "EoG-COMP-FB" then
    local tTalk = { { "main", 33 }, --"RNDstimulation", 	--WHY AM I HEARING A FAINTER WORD "COMPUTER"
			{"main",1},{ "cLookup",tCompPredicted.pColour },   --Computer has guessed, COLOUR,
      { "sLookup",tCompPredicted.pShape },{"main",2}, --SHAPE, as the last card in game
      {"main",3} }                                      --Now it's your turn, {"main",4} with your mask on
    if iSpeak <= #tTalk then
      iSpeak = narratorTalk( iSpeak, tTalk )
    else
      iSpeak = 1                                        --RESET NARRATOR SOUND INDEX FOR NEXT SECTION TO TURN ON
      waitTime = .5
      return true
    end
    
  elseif _section == "TUTOR" then   --was {"main",12},
    local tTalk = { {"cLookup", tCurrentCard.c1},{"sLookup",tCurrentCard.shape} } --NARRATOR ONLY SAYS THE COLOUR
    if iSpeak <= #tTalk then 
      iSpeak = narratorTalk( iSpeak, tTalk )
    else
      waitTime = 1
      iSpeak = 1
      return true
    end
 
  elseif _section == "IS-THE-COLOUR" then
    local level = tUserScore.level
    if level == 2 then
      tTalk = { {"main",9},{"cLookup",tColour5[1] },{"cLookup",tColour5[2] } }  --is the colour
    elseif level == 3 then
      tTalk = { {"main",9},{"cLookup",tColour5[1] },{"cLookup",tColour5[2] },{"cLookup",tColour5[3] } }      --is the colour
    elseif level == 4 then
      tTalk = { {"main",9},{"cLookup",tColour5[1] },{"cLookup",tColour5[2] },{"cLookup",tColour5[3] },       --is the colour
              { "cLookup", tColour5[4] } }
    elseif level == 5 then
      tTalk = { {"main",9},{"cLookup",tColour5[1] },{"cLookup",tColour5[2] },{"cLookup",tColour5[3] },        --is the colour
              { "cLookup",tColour5[4] },{ "cLookup",tColour5[5] } }
    elseif level == 9 then
      tTalk = { {"main",24} }     --L9 SOUND - 24;SINK DRIP ON RESETING OF CARD - 25;ZenToilet
    end
    if iSpeak <= #tTalk then
      iSpeak = narratorTalk( iSpeak, tTalk )
    else
      iSpeak = 1
      waitTime = 14
      return true
    end
    
  elseif _section == "NARRATOR" then    --PLAY WHAT THE SB HAS SENT OVER
    if iSpeak <= #tSM.tNarrTalk then
      iSpeak = narratorTalk( iSpeak, tSM.tNarrTalk )
    else
      return true
    end
  end
end

function speakFragment( _sound )
  love.audio.play( _sound )
end

function speakColour( _colour )
  for i =1, #tColours -1 do
    if tColours[ i ][1] == _colour then   --1 is the text
      speakFragment( tColours[ i ][3] )   --3 is where the sound was stored
      break
    end
  end
end

function speakShape( _shape )
  for i =1, #tShapes -1 do
    if tShapes[ i ][1] == _shape then   --1 is the text
      speakFragment( tShapes[ i ][3] )   --3 is where the sound was stored
      break
    end
  end
end

function narratorTalk( _iSpeak, tNarrator )  --INTRODUCTION HAS NO NEED FOR COLOUR VALUES
  if _iSpeak <= #tNarrator then
    local _text = tNarrator[ _iSpeak ][1]
    local _selection = tNarrator[ _iSpeak ][2]
    --SPEAKER TRANSLATOR
    if _text == "intro" then                        --tSndIntro
      waitTime = tSndIntro[ _selection ][ 2 ]
      speakFragment( tSndIntro[ _selection ][ 3 ] )
    elseif _text == "main" then                     --tSndMain
      waitTime = tSndMain[ _selection ][ 2 ]
      speakFragment( tSndMain[ _selection ][ 3 ] )
    elseif _text == "colours" then                  --tColours
      waitTime = tColours[ _selection ][ 2 ]
      speakFragment( tColours[ _selection ][ 3 ] )
    elseif _text == "shapes" then                   --tShapes
      waitTime = tShapes[ _selection ][ 2 ]
      speakFragment( tShapes[ _selection ][ 3 ] )
    elseif _text == "cLookup"then                   --tColours lookup colour and speak it
      waitTime = .5
      speakFragment( colourText2Sound( _selection ) )
    elseif _text == "sLookup"then                   --tShapes lookup shape and speak it
      waitTime = .5
      speakFragment( shapeText2Sound( _selection ) )
    end
  return _iSpeak + 1
  end
end

function symText2Sound( _text )   --not checked over yet
  for i=1, #tSymBonus do
    if tSymBonus[ i ][1] == _text then
      return tSymBonus[ i ][3] --COLOUR TABLE ON 4
    end
  end
end

function shapeText2Sound( _text )
  for i=1, #tShapes -1 do
    if tShapes[ i ][1] == _text then
      return tShapes[ i ][3] --COLOUR TABLE ON 4
    end
  end
end

-- *** COLOURS *** BUILD NESTED into TABLE tColours { {TEXT, COLOUR TABLE, SOUND of COLOUR } }
function loadSoundColours()
  local _timing = 1
  local _file = "source/sounds/Colours/"
  local _sndTblFiles = love.filesystem.getDirectoryItems("source/sounds/Colours/") --lists the files and table.txt last if loop -1 sound names
  for k, v in ipairs(_sndTblFiles) do   --put debugger mark here David and mouse over _sndTblFiles, without the leading zeros colour isn't last - The GREEN MOTH that was created right here by the filesystem itself. Was pretty funny for a bit where the word colour always came out green...
    if _sndTblFiles[k]:match("01") then
      table.insert( tColours, { "White", _timing, love.audio.newSource( _file .. v, "static" ), {1,1,1,1} } )
    elseif _sndTblFiles[k]:match("02") then
      table.insert( tColours, { "Yellow", _timing, love.audio.newSource( _file .. v, "static" ), {1,1,0,1} } )
    elseif _sndTblFiles[k]:match("03") then
      table.insert( tColours, { "Orange", _timing, love.audio.newSource( _file .. v, "static" ), {1,.5,0,1} } ) --Orange looking red again @.3
    elseif _sndTblFiles[k]:match("04") then
      table.insert( tColours, { "Red", _timing, love.audio.newSource( _file .. v, "static" ), {.75,0,0,1} } )
    elseif _sndTblFiles[k]:match("05") then
      table.insert( tColours, { "Pink", _timing, love.audio.newSource( _file .. v, "static" ), {1,0,.5,1} } )
    elseif _sndTblFiles[k]:match("06") then
      table.insert( tColours, { "Purple", _timing,  love.audio.newSource( _file .. v, "static" ), {78/255,5/255,80/255,1} } ) --{67/255,5/255,65/255,1}
    elseif _sndTblFiles[k]:match("07") then
      table.insert( tColours, { "Blue", _timing, love.audio.newSource( _file .. v, "static" ), {0,0,1,1} } )
    elseif _sndTblFiles[k]:match("08") then
      table.insert( tColours, { "Green", _timing, love.audio.newSource( _file .. v, "static" ), {0,1,0,1} } )
    elseif _sndTblFiles[k]:match("09") then   --When it was match("10") this became the speaking "Green" bug!
      table.insert( tColours, { "Colour", _timing, love.audio.newSource( _file .. v, "static" ), nil } )
    end
  end
end

  -- *** SHAPES *** BUILD NESTED into TABLE tShapes { {TEXT, SOUND of SHAPE } }
function loadSoundShapes()
  local _timing = 1.5
  local _file = "source/sounds/Shapes/"
  local _sndTblFiles = love.filesystem.getDirectoryItems("source/sounds/Shapes/")
  for k, v in ipairs(_sndTblFiles) do
    if _sndTblFiles[k]:match("01") then
      table.insert( tShapes, { "Circle", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("02") then
      table.insert( tShapes, { "Diamond", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("03") then
      table.insert( tShapes, { "Triangle", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("04") then
      table.insert( tShapes, { "Square", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("05") then
      table.insert( tShapes, { "Pentagon", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("06") then
      table.insert( tShapes, { "Hexagon", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("07") then
      table.insert( tShapes, { "Flower", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("08") then
      table.insert( tShapes, { "Heart", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("09") then
      table.insert( tShapes, { "Shape", _timing, love.audio.newSource( _file .. v, "static" ) } )
    end
  end
end

  --music:setVolume(.5)
  --src1:setPitch(.5)
  --love.audio.setEffect
-- *** NARRATOR - Main Loop ***
function loadSoundMain()
  local _timing = .5
  local _sndTblFiles = love.filesystem.getDirectoryItems("source/sounds/Main/") --5 More Directories
  local _file = "source/sounds/Main/"
  for k, v in ipairs( _sndTblFiles ) do
    if _sndTblFiles[k]:match("01") then       --"computer has guessed" SHAPE
      table.insert( tSndMain, { "CompHasGuessed", 2, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("02") then   --"As the last card in game"
      table.insert( tSndMain, { "AsLastCardEoG", 3, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("03") then   --"Now it's your turn"
      table.insert( tSndMain, { "NowYourTurn", 1.5, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("04") then   --"With your mask on"
      table.insert( tSndMain, { "WithMaskOn", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("05") then   --"the last turn number in game"
      table.insert( tSndMain, { "TheLastTurn#", 3, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("06") then   --"the # of error in game"
      table.insert( tSndMain, { "The#ofERR", 3, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("07") then   --"Change"
      table.insert( tSndMain, { "Change", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("08") then   --"Enter"
      table.insert( tSndMain, { "Enter", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("09") then   --"Is the colour ?"
      table.insert( tSndMain, { "IsTheColour", 2, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("10") then   --"Correct"
      table.insert( tSndMain, { "Correct", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("11") then   --"Both"
      table.insert( tSndMain, { "Both", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("12") then   --"Was"
      table.insert( tSndMain, { "Was", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("13") then   --"and" COLOUR
      table.insert( tSndMain, { "and", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("14") then   --"End of"
      table.insert( tSndMain, { "EndOf", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("15") then   --"Game"
      table.insert( tSndMain, { "Game", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("16") then   --"Over"
      table.insert( tSndMain, { "Over", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("17") then   --"Bonus Round"
      table.insert( tSndMain, { "BonusRound", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("18") then   --"Enter your name"
      table.insert( tSndMain, { "EnterYourName", 2, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("19") then   --"Your Name"
      table.insert( tSndMain, { "YourName", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("20") then   --"High Score"
      table.insert( tSndMain, { "HighScore", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("21") then   --"or"
      table.insert( tSndMain, { "Or", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("22") then   --"Not"
      table.insert( tSndMain, { "Not", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("23") then   --"Symbol"
      table.insert( tSndMain, { "Symbol", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("24") then   --"Sink Drip - from: gaming the game story"
      table.insert( tSndMain, { "SinkDrip", .5, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("25") then   --"Zen Toilet"
      table.insert( tSndMain, { "ZenToilet", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("26") then   --"Guitar"
      table.insert( tSndMain, { "Guitar", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("27") then   --"Guitar"
      table.insert( tSndMain, { "BDHouse", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("28") then   --"Guitar"
      table.insert( tSndMain, { "NothingButERRs", 1, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("29") then   --"Guitar"
      table.insert( tSndMain, { "BassSlide3", 0, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("30") then   --"Guitar"
      table.insert( tSndMain, { "BS7beat", 0, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("31") then   --"Guitar"
      table.insert( tSndMain, { "BS6beat", 0, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("32") then   --"Computer"
      table.insert( tSndMain, { "Computer", 1, love.audio.newSource( _file .. v, "static" ) } )
		elseif _sndTblFiles[k]:match("33") then   --"Random <UP> colour shape stimulation..."
      table.insert( tSndMain, { "RNDstimulation", 5, love.audio.newSource( _file .. v, "static" ) } )
		elseif _sndTblFiles[k]:match("34") then   --"in total darkness, let your eyes walk about and allow contrast of light"
      table.insert( tSndMain, { "InTotalDarkness", 6, love.audio.newSource( _file .. v, "static" ) } )
    end
  end
end

-- *** NARRATOR - INTRODUCTION ***
function loadSoundIntro()
  local _timing = .5
  local _sndTblFiles = love.filesystem.getDirectoryItems("source/sounds/Intro/") --5 More Directories
  local _file = "source/sounds/Intro/"
  for k, v in ipairs( _sndTblFiles ) do
    if _sndTblFiles[k]:match("01") then       --WELCOME TO SWoE...
      table.insert( tSndIntro, { "WelcomeTo", 2.5, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("02") then   --TRAINING AID...
      table.insert( tSndIntro, { "TrainingAid", 3, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("03") then   --ARROW
      table.insert( tSndIntro, { "Arrow", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("04") then   --DOWN
      table.insert( tSndIntro, { "down", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("05") then  --LEFT
      table.insert( tSndIntro, { "left", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("06") then  --RIGHT
      table.insert( tSndIntro, { "right", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("07") then  --UP
      table.insert( tSndIntro, { "up", _timing, love.audio.newSource( _file .. v, "static" ) } )
    elseif _sndTblFiles[k]:match("08") then  --TO RESET DISPLAY CARD
      table.insert( tSndIntro, { "ResetCard", 2.5, love.audio.newSource( _file .. v, "static" ) } )
    end
  end
end