describe "pinfinity.co", ->

  describe "home page", ->

    before (done) ->
      req =
        method: 'GET'
        path: '/'
        test: @

      make_request(req, done)
      return

    it "should have status = 200", ->
      @response.statusCode.should.eql 200
      return

    return

  describe "Node.js app", ->

    before (done) ->
      req =
        method: 'GET'
        path: '/ping'
        test: @

      make_request(req, done)
      return

    it "should have status = 200", ->
      @response.statusCode.should.eql 200
      return

    return

  return


make_request = HELPER.make_request({
  protocol: 'http'
  host: 'www.pinfinity.co'
  port: 9003
})
