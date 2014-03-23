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


make_request = HELPER.make_request({
  protocol: 'https'
  host: 'www.htmlandcsstutorial.com'
  port: 9007
})
