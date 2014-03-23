require 'should'

global.Crystal = require('crystal_constants').Crystal

global.TEST = TEST = Crystal.create()

HOST = if process.env['JFD_TEST_ENV'] is 'production'
  'massive.fwp-dyn.com'
else if process.env['JFD_TEST_ENV'] is 'staging'
  'massive-b.fwp-dyn.com'
else
  'localhost'

TEST.define('host', HOST)

TEST.freeze()
