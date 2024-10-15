require('src/CPK')

-- CPK_VERBOSE = true

-- local AssertIsString = CPK.Assert.IsString
-- local AssertIsNumber = CPK.Assert.IsNumber

-- local DateToISO = CPK.Date.ToISO

-- local Each = CPK.Table.Each
-- local Map = CPK.Table.Map

-- AssertIsString('Hello')
-- -- AssertIsString(1)

-- AssertIsNumber(1)

-- local PrintEach = Each(print)

-- local MapDouble = Map(function(val) return val * 2 end)
-- local tbl1 = { a = 1, b = 2, c = 3 }
-- local res1 = MapDouble(tbl1)
-- -- res1: { a = 2, b = 4, c = 6 }

-- -- Example 2: Changing both values and keys
-- local res2 = Map(function(val, key) return val * 2, key .. "_new" end, tbl1)
-- -- res2: { a_new = 2, b_new = 4, c_new = 6 }

-- -- Example 3: Removing values or keys
-- local res3 = Map(function(val)
-- 	if val > 1 then
-- 		return nil
-- 	else
-- 		return val
-- 	end
-- end, tbl1)
-- -- res3: { a = 1 }


-- PrintEach(res1)
-- print()
-- PrintEach(res2)
-- print()
-- PrintEach(res3)


-- local DropUntil = CPK.Table.DropUntil
-- local DropWhile = CPK.Table.DropWhile

-- local tbl1 = { 1, 2, 3, 4, 5, 1, 2, 3 }
-- local DropUntilGreaterThan3 = DropUntil(function(val) return val > 3 end)
-- local droppedA = DropUntilGreaterThan3(tbl1)
-- print(table.concat(droppedA, ", "))  -- Output: 4, 5

--  local tbl2 = { "a", "b", "c", "d" }
--  local droppedB = DropUntil(function(val) return val == "c" end, tbl2)
--  print(table.concat(droppedB, ", "))  -- Output: c, d

--  print(table.concat(DropWhile(function(val) return val < 3 end, tbl1), ', '))


--  print()

--  local Take = CPK.Table.Take

--  local tbl1 = { 1, 2, 3, 4, 5 }
-- local Take3 = Take(3)
-- local taken1 = Take3(tbl1)
-- print(table.concat(taken1, ", "))  -- Output: 1, 2, 3

-- local tbl2 = { "a", "b", "c", "d" }
-- local taken2 = Take(2, tbl2)
-- print(table.concat(taken2, ", "))  -- Output: a, b

-- local tbl3 = { 10, 20, 30, 40 }
-- local taken3 = Take(5, tbl3)
-- print(table.concat(taken3, ", "))  -- Output: 10, 20, 30, 40

-- print()

-- local Slice = CPK.Table.Slice
-- local function PrintTable(tbl) print(table.concat(tbl, ", ")) end 
-- local tbl1 = { "apple", "banana", "cherry", "date", "fig", "grape", "pumpkin" }
-- PrintTable(Slice(2, 4, tbl1))  -- Output: banana, cherry, date
-- PrintTable(Slice(3, tbl1)) -- Output: cherry, date, fig, grape, pumpkin
-- PrintTable(Slice(-3, tbl1)) -- Output: fig, grape, pumpkin
-- PrintTable(Slice(2, -3, tbl1)) -- Output: banana, cherry, date, fig

-- print()
-- local ShallowMerge = CPK.Table.ShallowMerge

-- PrintTable(ShallowMerge({}, tbl1, tbl3))

-- print()
-- local TextBuilder = CPK.Text.Builder
-- local builder = TextBuilder.new()
-- builder:Append("apple")
-- builder:Append("banana")
-- builder:Prepend("grape")
-- print(builder:Join(", ")) -- Output: grape, apple, banana
-- print(builder:Join()) -- Output: grapeapplebanana

local Inspect = CPK.Util.Inspect


local data = { a = 1, b = 2, [3] = 4, test = { hello = 'world' } }


local function testA()
	for i = 0, 10 * 100 do
		print(data)
	end
end


local function testB()
	local str = ''

	for i = 0, 10 * 100 do
		Inspect(data)
	end

	return str
end


local function Measure(title, fn)
	local before = collectgarbage('count')
	collectgarbage('stop')
	print( 'Before', 'Garbage:',  before)
  collectgarbage()
  local startTime = os.clock()

  fn()

  local endTime = os.clock()

	local after = collectgarbage('count')
  print( 'After', title, endTime - startTime, 'Garbage:', after, 'Diff: ', after - before)


	collectgarbage()
	collectgarbage()
	collectgarbage("collect")
	collectgarbage('restart')
end
