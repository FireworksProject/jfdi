require 'should'

global.Crystal = require('crystal_constants').Crystal

_   = require 'underscore'
REQ = require 'request'

global.TEST = TEST = Crystal.create()

HOST = if process.env['JFD_TEST_ENV'] is 'production'
  'massive.fwp-dyn.com'
else if process.env['JFD_TEST_ENV'] is 'staging'
  'massive-b.fwp-dyn.com'
else
  'localhost'

TEST.define('host', HOST)

TEST.freeze()

global.HELPER = HELPER = Object.create(null)


HELPER.make_request = (defaults) ->

  make_request = (opts, done) ->
    {method, port, path, test} = _.defaults(opts, defaults)

    req =
      method: method
      uri: "http://#{TEST.host}:#{port}#{path}"

    # console.log 'making request to', req.uri
    REQ req, (err, res, body) ->
      if err
        done(err)
        return
      res.body = body
      test.response = res
      return done()
    return

  return make_request
