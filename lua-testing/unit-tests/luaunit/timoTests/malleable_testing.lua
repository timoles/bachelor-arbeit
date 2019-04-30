#!/usr/bin/env lua

local lu = require('luaunit')

local proxy = require('openresty_malleable')
local meterpreter = require('scripts.meterpreter_malleable')

-- class TestTiti

TestTiti = {} --class
    function TestTiti:setUp()
        -- set up tests
        self.input_normal = "test String"
        self.input_empty = ""
        self.input_nil = nil
        
        self.input_invalid = "invalid decode string"

        self.output_string = ''
        -- print( 'TestTiti:setUp' )
    end

    function TestTiti:tearDown()
        -- some tearDown() code if necessary
        -- print( 'TestTiti:tearDown' )
    end

-- Test1
-- encode with proxy
-- decode with meterpreter
    function TestTiti:test1()
        encoded = proxy.encode(self.input_normal)
        self.output_string = meterpreter.decode(encoded)
        lu.assertEquals(  self.output_string, self.input_normal  )
    end

-- Test2
-- encode with meterpreter
-- decode with proxy
    function TestTiti:test2()
        encoded = meterpreter.encode(self.input_normal)
        self.output_string = proxy.decode(encoded)
        lu.assertEquals(  self.output_string, self.input_normal  )
    end

-- Test3
-- decode invalid with meterpreter
    function TestTiti:test3()
        self.output_string = meterpreter.decode(self.input_invalid)
        lu.assertEquals(  self.output_string, self.input_invalid  )
    end

-- Test4
-- decode invalid with proxy
    function TestTiti:test4()
        self.output_string = proxy.decode(self.input_invalid)
        lu.assertEquals(  self.output_string, self.input_invalid  )
    end

-- Test5
-- decode empty with meterpreter
    function TestTiti:test5()
        self.output_string = meterpreter.decode(self.input_empty)
        lu.assertEquals(  self.output_string, self.input_empty  ) 
    end

-- Test6
-- decode empty with proxy
    function TestTiti:test6()
        self.output_string = proxy.decode(self.input_empty)
        lu.assertEquals(  self.output_string, self.input_empty  )
    end

-- Test7
-- Encode nil with meterpreter
    function TestTiti:test7()
        self.output_string = meterpreter.decode(self.input_nil)
        lu.assertEquals(  self.output_string, self.input1  )
    end

-- Test8
-- Encode nil with proxy
    function TestTiti:test8()
        self.output_string = proxy.encode(self.input_nil)
        lu.assertEquals(  self.output_string, self.input1  )
    end

-- Test9
-- Decode nil with malleable
    function TestTiti:test9()
        self.output_string = proxy.decode(self.input_nil)
        lu.assertEquals(  self.output_string, self.input1  )
    end

-- Test10
-- Decode nil with Meterpreter
    function TestTiti:test10()
        self.output_string = meterpreter.decode(self.input_nil)
        lu.assertEquals(  self.output_string, self.input1  )
    end
-- class TestTiti


local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
