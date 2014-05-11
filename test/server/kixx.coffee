describe "kixx.name", ->

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
      @response.body.indexOf('<h1 class="header">My name is <strong>Kris Walker</strong></h1>').should.be.greaterThan(0)
      return


make_request = HELPER.make_request({
  protocol: 'http'
  host: 'www.kixx.name'
  port: 9012
})
