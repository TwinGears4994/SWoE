--[[
Brian T.Wilcox
twingears@gmail.com
]]
function rndShapeB()
  local index = math.random(1, 2) --default
  index = 1   --testing or we don't like the thin boarder of shape...
  if index == 1 then
    return "fill"
  elseif index == 2 then
    return "line"
  end
end

function rndShape()
  local i = math.random(1, #tShapes -1)
--  iShapeCorrect = index       --Global var need for faster answer check
  return tShapes[ i ][1], i   --RETURN CORRECT SHAPE ANSWER AND INDEX
end

function shapeEcco( _shape, _i )  --"ERR"
--FETCH ON MISSING "TEXT" OR INDEX
  if _shape == "ERR" and _i ~= 0 then  --if _i ~= 0 then
    return tShapes[ _i ][1], _i   --RETURN TEXT, INDEX
  else
    for iS = 1, #tShapes -1 do
      if _shape == tShapes[ iS ][1] then
        return _shape, iS         --RETURN TEXT, INDEX
      end
    end
  end
  return nil,nil
end

function shapePlus(_num)       -- +1 SLIDING SHAPE INDEX
  _num = _num +1
  if _num > #tShapes -1 then
    _num = 1
  end
  return tShapes[ _num ][1], _num
end