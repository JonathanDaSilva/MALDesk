describe "Routes:", ->

  beforeEach -> browser.get('/')

  describe "Home:", ->
    it "default to /anime/all", ->
      expect(browser.getCurrentUrl()).toContain('/anime/all')

    it "should accept only anime/manga link", ->
      browser.get('#/ndol/sunrt')
      expect(browser.getCurrentUrl()).toContain('/anime/all')

  describe "view:", ->
    it "should exist", ->
      browser.get("#/anime/view/6757")
      expect(browser.getCurrentUrl()).toContain('/anime/view/6757')
      browser.get("#/manga/view/6757")
      expect(browser.getCurrentUrl()).toContain('/manga/view/6757')

    it "should accept only numbers", ->
      browser.get("#/anime/view/i")
      expect(browser.getCurrentUrl()).toContain('/anime/all')
      browser.get("#/anime/view/i")
      expect(browser.getCurrentUrl()).toContain('/anime/all')
