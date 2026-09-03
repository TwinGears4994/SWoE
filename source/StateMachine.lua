--[[
Brian T.Wilcox
twingears@gmail.com
]]
tSM = {
  idxLoop = 1,
  curState = "CRANK-START",   --INDEX WITHIN THE ONE OF THE abcde Loops
  idxState = 1,
  curDState = "",
  idxDState = 1,
  tDrawState = { "BLACKOUT","GUESS-EoG","Q1TURNS","Q2ERRORS","PER-TURN","EDIT-SB","SCOREBOARD","LIST-STORIES", "LCS-TA" },
  aLoop = { "FILE-CHK","FILE-LOAD","FILE-SAVE" },
  bLoop = { "INTRO","EoG-pCOMP","EoG-COMP-FB","EoG-pUSER","Q1TURNS","Q2ERRORS","MASK-ON" },
  cLoop = { "TUTOR","RESET-CARD","QUESTION","GUESS-COMP","SCORE-USER","SCORE-COMP","EoG1","NARR1" },
  dLoop = { "BR-FLASH-CARD","SCORE-USER","EoG2","NARR2" }, --"BR-USER",
  eLoop = { "BR-FLASH-CARD","BR-COMP","SCORE-COMP","NARR2" },
  fLoop = { "EDIT-SB","SCOREBOARD" }, --,"NARR3" }
  tNarrTalk = { },
  --LCS-TA COULD BEGIN HERE
  gLoop = { "LIST-STORIES", "RV-ALPHA#","AUTHOR","STORY","RNUM" }
}

function tSM:walk( _bFORWARD )
  local _bPLUS = false
  if _bFORWARD == false then  --A FANCY +1 OR =1 BOOL(ing for endings) STATIC VALUE FOR _bREWIND TRUE
    self.idxState = 1
  else
    if self.idxLoop == 1 and self.idxState < #self.aLoop then
      _bPLUS = true
    elseif self.idxLoop == 2 and self.idxState < #self.bLoop then
      _bPLUS = true
    elseif self.idxLoop == 3 and self.idxState < #self.cLoop then
      _bPLUS = true
    elseif self.idxLoop == 4 and self.idxState < #self.dLoop then
      _bPLUS = true
    elseif self.idxLoop == 5 and self.idxState < #self.eLoop then
      _bPLUS = true
    elseif self.idxLoop == 6 and self.idxState < #self.fLoop then
      _bPLUS = true
    end
  end
  if _bPLUS then
    self.idxState = self.idxState +1
  end
  self:updateText()
end

function tSM:switch( _BOOL )        --BOOL SWITCH THE TABLE LOOP AS STATIC VARIABLE
  --  if _bool then
  if self.idxLoop == 1 then      --aLoop
    self.idxLoop = 2            --bLoop
    self.idxState = 1           --"INTRO"   --2           --"EoG-pCOMP"
    self.idxDState = 1         --"BLACKOUT" --5         --"PER-TURN"
  elseif self.idxLoop == 2 then  --bLoop
    self.idxLoop = 3            --cLoop
    self.idxState = 2           --"RESET-CARD"
    self.idxDState = 5         --"PER-TURN" 
    --BONUS ROUND NOW 2 LOOPS
  elseif self.idxLoop == 3 then  --JUMP TO dLoop USER BONUS ROUND
    self.idxLoop = 4            --dLoop
    self.idxState = 1
    self.idxDState = 5
  elseif self.idxLoop == 4 then  --JUMP TO eLoop COMP BONUS ROUND
    self.idxLoop = 5            --eLoop
    self.idxState = 1
    self.idxDState = 5
  elseif self.idxLoop == 5 then   --JUMP TO fLoop SB
    self.idxLoop = 6
    if _BOOL then
      self.idxState = 1
      self.idxDState = 6
    else
      self.idxState = 2
      self.idxDState = 7
    end
  elseif self.idxLoop == 6 and not tScoreBoard.bQUARTER then  --eLoop JUMP TO fLoop
    self.idxLoop = 2
    self.idxState = 2
    self.idxDState = 5
  elseif self.idxLoop == 6 then   --JUMP TO fLoop SB
    self.idxLoop = 7
    self.idxState = 1   --LIST-STORIES
    self.idxDState = 8  --"LIST-STORIES"
  end
  self:updateText()
end

function tSM:dState( _bReStart, _bEdit, _bSB  )
  if _bReStart then
    self.idxDState = 2    --( _bReStart = self.idxDState = 2, _bEdit, _bSB  )
  elseif _bEdit then
    self.idxDState = 6
  elseif _bSB then
    self.idxDState = 7
  elseif self.idxDState < #self.tDrawState then
    self.idxDState = self.idxDState +1
  end
end

function tSM:aLfileCk()
  self.idxLoop = 1      -- aLoop
  self.idxDState = 1    --"BLACKOUT" OR ART DRAWN BY Family
  self.idxState = 1     --"FILE-CHK"
  self:updateText()
end

function tSM:bLresetGame( _bool )
  self.idxLoop = 2      -- bLoop
  if _bool then
    self.idxState = 2   --"EoG-pCOMP"
    self:dState( true, false, false ) --( _bReStart, _bEdit, _bSB  )
  else
    self.idxState = 1   --"INTRO"
    self.idxDState = 1
  end
  self:updateText()
  iSpeak = 1
  resetPlayers()    --ONLY RESET ON START UP AND EXITING SB INTO NEW GAME
end

function tSM:cLresetCard( _reset )
  self.idxLoop = 3    -- cLoop
  if _reset then
    self.idxState = 2   --"RESET-CARD"
  else
    self.idxState = 1   --"TUTOR"
  end
  self:updateText()
end

function tSM:updateText()       --THIS SHOULD HELP FIT THE ALREADY EXISTING CODE BASE
  if self.idxLoop == 1 then
    self.curState = self.aLoop[ self.idxState ]
  elseif self.idxLoop == 2 then
    self.curState = self.bLoop[ self.idxState ]
  elseif self.idxLoop == 3 then
    self.curState = self.cLoop[ self.idxState ]
  elseif self.idxLoop == 4 then
    self.curState = self.dLoop[ self.idxState ]
  elseif self.idxLoop == 5 then
    self.curState = self.eLoop[ self.idxState ]
  elseif self.idxLoop == 6 then
    self.curState = self.fLoop[ self.idxState ]
  elseif self.idxLoop == 7 then
    self.curState = self.gLoop[ self.idxState ]
  end
  self.curDState = self.tDrawState[ self.idxDState ]
end

function tSM:fLenterSB()
  self.idxLoop = 6    -- fLoop
  self.idxState = 2
  self.idxDState = 7
  --self:dState( false, false, true ) --( _bReStart, _bEdit, _bSB  )  --self.idxDState = 7
  self:updateText()
  iSpeak = 1
end