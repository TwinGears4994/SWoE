--[[
Brian T.Wilcox
twingears@gmail.com
]]
function funcInject( _table, target )   --target == "Score" or "Predict" or "CurCard" or "PortHole"
  if target == "Score" then
    function _table:reset()
      self.level = 3                --tUserScore.level
      self.corr = 0                 --tUserScore.earnedBRTurns == tUserScore.curGameTurn
      self.err = 0
      self.tlCorr = 0
      self.tlErr = 0
      self.tlCol = 0
      self.tlShape = 0
      self.tlCards = 0              --3 FOR DEBUGGING
      self.tlScore = 0
      self.tlSymb = 0               --3 FOR DEBUGGING
      self.tlBRCard = 0             --TOTAL BONUS ROUND CARDS
      self.tlBRSymb = 0             --TOTAL BONUS ROUNDS SYMBOLS
      self.tlAidTurns = 0           --DUMPS self.tlTurns
      self.curGameTurn = 1          --DEFAULT VALUE
      self.earnedBRTurns = 0        --HOW MANY BONUS ROUND TURNS ONE WILL GET
      --self.isSELECTED = false       --STOP PLAYER FROM GETTING MORE THAN ONE BONUS FROM <DOWN>, AT THE END OF RESET CARD
      self.EEggs = 0            --STORE THE FACT SYMB WAS HIT AT THE END OF THE GAME
    end
  elseif target == "Predict" then   --tCompPredicted.bptHitSYMB
    function _table:reset()         --tUserPredicted.EoGturns    .bGoBR
      self.pColour = "Green"        --DEFAULTS NEEDED
      self.pShape = "Flower"        --DEFAULT
      self.EoGturns = 10            --DEFAULT 10
      self.pEoGErrs = math.floor( self.EoGturns *2 *.8 )
      self.pCturn = "pCturn"        --
      self.pSturn = "pSturn"        --
      self.bptDisplayedSYMB = false --GAME TOGGLES BOOL true IF A BONUS IS ON-SCREEN PER-TURN
      self.bptHitSYMB = false       --PASS TO SCORE CHECKER AS PER-TURN
      self.bptEoGCARD = false       --PASS TO SCORE CHECKER AS PER-TURN
      self.bGoBR = false            --BONUS ROUND TOGGLE x10 POINTS PAYOUT, EASTER EGG ALSO TURNS THIS @ L9 FACECARD & SYMB SAME TIME
      self.bEoG1 = false
      self.bEoG2 = false             --NO RE-SETTING LAST CARD IN GAME - IT IS WHAT IT IS
      self.bEXIT = false   --tUserPredicted.bEXIT = true
    end
  elseif target == "CurCard" then   --tCurrentCard.cardBRtiming
    function _table:reset()         --tCurrentCard.curGameTurn
      self.c1 = ""                  --tCurrentCard.upKeyRND
      self.c2 = ""
      self.c3 = ""
      self.c4 = ""
      self.c5 = ""
      self.cIndex = 0
      self.shape = "SHAPE"
      self.sIndex = 0
      self.doneCHOICE = false
      self.rndQc1c5 = 3             --DEFAULT GO VALUE IS 3
      --self.curGameTurn = 1          --DEFAULT VALUE
--      self.curBRTurn = 0            --tCurrentCard.curBRTurn
      self.cardBRtiming = 1         --CAN'T BEGIN ANYWHERE ELSE THAN 1st POSITION OF A TABLE
      self.navTalk = false         --FOR THE RANDOM C&S UP KEY MASK CALIBRATION
    end
  elseif target == "PortHole" then    --tPortHole
    function _table:reset()           --DISCOVERED FRAME IS A LITTLE SMALL UNTILL WE MOVE THE DRAWN CARD TO THE RIGHT BY SAY .quarterW
      self.W = love.graphics.getWidth()
      self.H = love.graphics.getHeight()
      self.boarder = math.floor( self.W *.05 )                --5% BOARDER AROUND WHAT EVER FULL-SCREEN IS
      self.xbdr = self.boarder                                --START OF BOARDER
      self.ybdr = self.boarder
      self.bdrW = math.floor( self.W -( self.boarder *2 ) )   --BOARDER RECTANGLE WIDTH     --WAS 2
      self.bdrH = math.floor( self.H -( self.boarder *2 ) )   --BOARDER RECTANGLE HEIGHT    --WAS 2
      self.frameH = math.floor( self.H -( self.boarder *4 ) ) --FRAME HEIGHT                --WAS 4
      self.frameW = math.floor( self.H -( self.boarder *4 ) ) --FRAME WIDTH                 --WAS 4
      self.xFrame = math.floor( ( self.W -self.frameW)/2 )    --START OF x FRAME FOR COLOURED SHAPE CARD
      self.yFrame = math.floor( self.boarder *2 )             --SHRINKING THE FRAME         --WAS 2
      self.x2Frame = math.floor( self.xFrame + self.frameW )  --FAR SIDE AS x2 FRAME
      self.y2Frame = math.floor( self.yFrame + self.frameH )  --FAR SIDE AS y2 FRAME
      self.quarterW = math.floor( self.bdrW /4 )            --VERY USEFUL FOR COLUMNS OF FONTS FOR SCORE
      self.oneSixthW = math.floor( self.bdrW /6 )
      self.slice3W = self.bdrW *(5/12) /3
      self.scaleFrame = self.frameW /1000                     --IMAGES USED ARE MOSTLY 1000px almost square & SYMBOLS are 200px   tPortHole.scaleFrame
      self.fontPixLarge = tPortHole.frameH /24
      self.yPad = self.fontPixLarge /4
    end
  elseif target == "SB" then      --tScoreBoard.bScoreEDITED
    function _table:reset()
      self.avgSB = { first = 0, ten = 0, allUser = 0, allComp = 0 }
      self.bQUARTER = false            --SWoE == 1 OR 2 QUARTERS LIKE ARCADE GAME
      self.waitCount = 0          --DEFAULT 10 SECONDS FOR SCOREBOARD TO TIME OUT AND SET VALUES AS IF "<DONE>", LIKE IT DID BEFORE FANCY SCOREBOARD EXPERIMENT
      self.iUserEditSB = 1        --PLACE HOLDER FOR USER NESTED INDEX ABOUT INJECTED SCORE TO THE SCOREBOARD - NOW MUST BE ONSCREEN
      self.bScoreEDITED = false   --SCOREBOARD HAS CHANGED
      self.iListName = 1          --INDEX OF THE PREDEFINED LISTED GLOSSA-NAMES-OR-SIGNS
      self.iListColour = 1        --<RIGHT +1> TALKING COLOUR & RECYCLED FOR SCOREBOARD COLOURED NAME/LINE ASSIGNMENT
      self.iListShape  = 1        --<LEFT +1> TALKING SHAPE
      self.iTwinGears = 1         --iSubNest = 1-4  << /1/ NAME COLOUR /2/ NAME /3/ TABLE NAME[nameiRow] /4/ SOUNDS >> LOOP BACK TO 1st...
    --  iSubNest = 1, --tScoreBoard[ iSBNest ].tColourName] /iSBNest+1/ [ iSBNest ].sound /iSBNest+1/ [ iSBNest ].name /iSBNest+1/ 
      self.iLetterRow = 1         --tScoreBoard[ iSBNest ].tName[ .nameiRow ] /iSBNest+1/ tScoreBoard[ iSBNest ].
      self.iLetter = 1            --INDEX OF LETTER/SYMBOL SELECTION alpha TABLE
    --  bALPHA = false,    --IF DRAWING SCOREBOARD bALPHA NEED BE ON
    --  alphaEoGCard = .7,
    --  alphaSB = .7,
      self.iSound = 1
      self.bSOUND = true          --toggled off for scoreboard only
      self.yPixels = tPortHole.fontPixLarge --23   --WHY I DON'T HAVE SCALE ON THIS ANYMORE?
    end
  end
end