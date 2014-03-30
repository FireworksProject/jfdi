describe "htmlandcsstutorial.com", ->

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
      @response.body.indexOf('<h2>Kittens Are Dying</h2>').should.be.greaterThan(0)
      return


make_request = HELPER.make_request({
  protocol: 'https'
  host: 'www.htmlandcsstutorial.com'
  port: 9007
})
