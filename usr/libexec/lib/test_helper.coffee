require 'should'

global.Crystal = require('crystal_constants').Crystal

_   = require 'underscore'
REQ = require 'request'

global.TEST = TEST = Crystal.create()

ENV = process.env['JFD_TEST_ENV']

HOST = if ENV is 'production'
  'massive.fwp-dyn.com'
else if ENV is 'staging'
  'massive-b.fwp-dyn.com'
else
  'localhost'

TEST.define('env', ENV)
TEST.define('host', HOST)

TEST.freeze()

global.HELPER = HELPER = Object.create(null)


HELPER.make_request = (defaults) ->

  make_request = (opts, done) ->
    {method, protocol, host, port, path, test} = _.defaults(opts, defaults)
    uri = 'http://'
    headers = Object.create(null)

    uri += TEST.host

    if TEST.env is 'development'
      uri += ":#{port}"
    else
      if protocol is 'https' then uri = uri.replace(/^http\:/, 'https:')
      headers['Host'] = host

    uri += path

    req =
      method: method
      uri: uri
      headers: headers
      followRedirect: no

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
