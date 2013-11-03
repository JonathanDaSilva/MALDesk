describe "App module:", ->
  it "should exists", ->
    ng = angular.module("App")
    expect(ng).toBeDefined()
