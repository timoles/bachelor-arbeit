#!/usr/bin/env lua


local lu = require('luaunit')



-- class TestTiti

TestTiti = {} --class
    function TestTiti:setUp()
        -- set up tests
        self.timo1 = "hop"
        self.timo2 = 'hop' 
        -- print( 'TestTiti:setUp' )
    end

    function TestTiti:tearDown()
        -- some tearDown() code if necessary
        -- print( 'TestTiti:tearDown' )
    end

    function TestTiti:test3()
        -- print( "some stuff test 3" )
        lu.assertEquals( self.timo1 , self.timo2 )
        
    end
-- class TestTiti

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
