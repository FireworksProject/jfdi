describe "lazycrazyacres.com", ->

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

    it "has a page header", ->
      @response.body.indexOf('Welcome to Lazy Crazy Acres</h4>').should.be.greaterThan(0)
      return


make_request = HELPER.make_request({
  protocol: 'http'
  host: 'www.lazycrazyacres.com'
  port: 9011
})
