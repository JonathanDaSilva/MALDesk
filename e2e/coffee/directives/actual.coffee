ptor = require('protractor')

describe "Actual directive:", ->
  results = null

  beforeEach ->
    browser.get('/')
    browser.findElements(ptor.By.css('[actual]')).then (datas)-> results = datas

  it "should exist", ->
    expect(results.length).toNotBe(0)

  it "should be apply only on link", ->
    for result in results
      expect(result.getTagName()).toBe('a')

  it "should add active class on click", ->
    for result, i in results
      result.click()
      result.findElement(ptor.By.xpath("..")).then (parent) ->
        expect(parent.getAttribute('class')).toContain('active')

  it "should remove class", ->
    for result, i in results
      result.click()
      for result, j in results
        if i != j
          result.findElement(ptor.By.xpath("..")).then (parent)->
            expect(parent.getAttribute('class')).toNotContain('active')
