ptor = require('protractor')

describe "Toolbar:", ->

  describe "Display options:", ->
    links = null

    beforeEach ->
      browser.findElements(ptor.By.css('#settings a')).then (datas)-> links = datas

    it "should add class active on click", ->
      for link in links
        link.click()
        expect(link.getAttribute('class')).toContain('active')

    it "should remove the add class on the others links:", ->
      for link, i in links
        link.click()
        for link, j in links
          if i!=j
            expect(link.getAttribute('class')).toNotContain('active')

