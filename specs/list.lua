require 'luacov'
local list = require('linkedList')

context('lists', function()
	local aList
	before(function()
		aList = list()
	end)
	context('of values', function()
		context('push', function()
			test('adds values to a list',function()
				assert_false(aList:contains("a"))
				assert_false(aList:contains("b"))
				assert_true(aList:push("a"))
				assert_equal(aList.length, 1)
				assert_true(aList:push("b"))
				assert_equal(aList.length, 2)
				assert_true(aList:contains("a"))
				assert_true(aList:contains("b"))
			end)
			test('but not duplicate values',function()
				assert_true(aList:push("a"))
				assert_equal(aList.length, 1)
				assert_false(aList:push("a"))
				assert_equal(aList.length, 1)
				assert_true(aList:contains("a"))
			end)
		end)
		context('pop', function()
			before(function()
				aList:push("a")
				aList:push("b")
			end)
			test('removes and returns the values from last to first',function()
				assert_equal(aList.length, 2)
				assert_equal("b", aList:pop())
				assert_equal(aList.length, 1)
				assert_equal("a", aList:pop())
				assert_equal(aList.length, 0)
				assert_equal(nil, aList:pop())
				assert_equal(aList.length, 0)
			end)
		end)
		context('remove', function()
			before(function()
				aList:push("a")
				aList:push("b")
				aList:push("c")
			end)
			test('removes and returns a value from the list',function()
				assert_equal(aList.length, 3)
				assert_equal("b", aList:remove("b"))
				assert_equal(aList.length, 2)
				assert_equal("c", aList:pop())
				assert_equal("a", aList:pop())
			end)
		end)
		context('iterate', function()
			before(function()
				aList:push("a")
				aList:push("b")
				aList:push("c")
			end)
			test('iterates over the list',function()
				local check = {"a","b","c"}
				local count = 0
				for value in aList:iterate() do
					count = count + 1
					assert_equal(value, check[count])
				end
			end)
		end)
		context('get', function()
			before(function()
				aList:push("a")
			end)
			test('returns an existent value',function()
				assert_equal(aList:get("a"), "a")
			end)
			test('or nil for an unexistent one',function()
				assert_nil(aList:get("b"))
			end)
		end)
	end)
	context('of pairs', function()
		context('push', function()
			test('adds pairs to a list',function()
				assert_false(aList:contains("a"))
				assert_false(aList:contains("b"))
				assert_true(aList:push("a", "aa"))
				assert_equal(aList.length, 1)
				assert_true(aList:push("b", "bb"))
				assert_equal(aList.length, 2)
				assert_true(aList:contains("a"))
				assert_true(aList:contains("b"))
				assert_equal(aList:get("a"), "aa")
				assert_equal(aList:get("b"), "bb")
			end)
			test('but not duplicate keys',function()
				assert_true(aList:push("a", "aa"))
				assert_equal(aList.length, 1)
				assert_false(aList:push("a", "xx"))
				assert_equal(aList.length, 1)
				assert_true(aList:contains("a"))
				assert_equal(aList:get("a"), "aa")
			end)
		end)
		context('pop', function()
			before(function()
				aList:push("a", "aa")
				aList:push("b", "bb")
			end)
			test('removes and returns the pairs from last to first',function()
				local key, value
				assert_equal(aList.length, 2)
				key, value = aList:pop()
				assert_equal(key, "b")
				assert_equal(value, "bb")
				assert_equal(aList.length, 1)
				key, value = aList:pop()
				assert_equal(key, "a")
				assert_equal(value, "aa")
				assert_equal(aList.length, 0)
				key, value = aList:pop()
				assert_nil(key)
				assert_nil(value)
				assert_equal(aList.length, 0)
			end)
		end)
		context('remove', function()
			before(function()
				aList:push("a", "aa")
				aList:push("b", "bb")
				aList:push("c", "cc")
			end)
			test('removes and returns a value from the list',function()
				local key, value
				assert_equal(aList.length, 3)
				key, value = aList:remove("b")
				assert_equal(key, "b")
				assert_equal(value, "bb")
				assert_equal(aList.length, 2)
				key, value = aList:pop()
				assert_equal(key, "c")
				assert_equal(value, "cc")
				key, value = aList:pop()
				assert_equal(key, "a")
				assert_equal(value, "aa")
			end)
		end)
		context('iterate', function()
			before(function()
				aList:push("a", "aa")
				aList:push("b", "bb")
				aList:push("c", "cc")
			end)
			test('iterates over the list',function()
				local keys   = {"a","b","c"}
				local values = {"aa","bb","cc"}
				local count = 0
				for key, value in aList:iterate() do
					count = count + 1
					assert_equal(key,   keys  [count])
					assert_equal(value, values[count])
				end
			end)
		end)
		context('get', function()
			before(function()
				aList:push("a", "aa")
			end)
			test('returns an existent value',function()
				assert_equal(aList:get("a"), "aa")
			end)
			test('nil for an unexistent key',function()
				assert_nil(aList:get("b"))
			end)
			test('or inserts a default one',function()
				assert_equal(aList:get("c", "cc"), "cc")
				assert_equal(aList.length, 2)
				assert_true(aList:contains("c"))
				assert_equal(aList:get("c"), "cc")
				local key, value
				key, value = aList:pop()
				assert_equal(key, "c")
				assert_equal(value, "cc")
				key, value = aList:pop()
				assert_equal(key, "a")
				assert_equal(value, "aa")
			end)
		end)
	end)
	context('join', function()

		local bList, cList, dList

		before(function()
			bList = list("d", "e", "f")
			cList = list("g", "h", "i")
			dList = list("j", "k", "l")
			aList:push("a")
			aList:push("b")
			aList:push("c")
		end)
		test('adds all values from the other list',function()
			aList:join(bList)
			assert_equal(aList.length, 6)
			assert_equal(bList.length, 0)
			assert_true(aList:contains("d"))
			assert_true(aList:contains("e"))
			assert_true(aList:contains("f"))
			assert_equal(aList:get("f"), "f")
			aList:join(cList)
			assert_equal(aList.length, 9)
			assert_equal(cList.length, 0)
			assert_true(aList:contains("g"))
			assert_true(aList:contains("h"))
			assert_true(aList:contains("i"))
			assert_equal(aList:get("i"), "i")
		end)
		context('commutatively', function()
			before(function()
				bList:join(cList)
				aList:join(bList)
				aList:join(dList)
			end)
			test("all values are added",function()
				assert_true(aList:contains("d"))
				assert_true(aList:contains("e"))
				assert_true(aList:contains("f"))
				assert_true(aList:contains("g"))
				assert_true(aList:contains("h"))
				assert_true(aList:contains("i"))
				assert_true(aList:contains("j"))
				assert_true(aList:contains("k"))
				assert_true(aList:contains("l"))
				assert_equal(aList:get("l"), "l")
			end)
			test("iterate works",function()
				local check = {"a","b","c","d","e","f","g","h","i","j","k","l"}
				local count = 0
				for value in aList:iterate() do
					count = count + 1
					assert_equal(value, check[count])
				end
			end)
			context('remove', function()
				before(function()
					aList:remove("e")
					aList:remove("b")
					aList:remove("h")
					aList:remove("k")
				end)
				test("works",function()
					assert_false(aList:contains("b"))
					assert_nil(aList:get("b"))
					assert_false(aList:contains("e"))
					assert_nil(aList:get("e"))
					assert_false(aList:contains("h"))
					assert_nil(aList:get("h"))
					assert_false(aList:contains("k"))
					assert_nil(aList:get("k"))
				end)
				test("and affects iterate correctly",function()
					local check = {"a","c","d","f","g","i","j","l"}
					local count = 0
					for value in aList:iterate() do
						count = count + 1
						assert_equal(value, check[count])
					end
				end)
			end)
		end)
	end)
end)
