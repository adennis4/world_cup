class WC.AveragesView
  constructor: (data) ->
    @data = data
    @$averages = $(".averages")

  render: ->
    @find("dd.height").text(@height())
    @find("dd.weight").text(@weight())
    @find("dd.age").text(@age())

  find: (selector) ->
    @$averages.find(selector)

  height: ->
    Math.round(@data.averagePlayerAttr('height'))

  weight: ->
    Math.round(@data.averagePlayerAttr('weight'))

  age: ->
    Math.round(@data.averagePlayerAge())

  forCountry: (team)->
    @data.forCountry(team)
    @render()
