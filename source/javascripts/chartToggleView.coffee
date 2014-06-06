class WC.ChartToggleView
  svgSelector: "#barGraphContainer svg"

  constructor: (data) ->
    @data = data
    @defineEvents()
    @heightsChart = new WC.HeightsView(@data)
    @weightsChart = new WC.WeightsView(@data)
    @currentState = "height"

  render: () ->
    @heightsChart.render(@svgSelector)

  defineEvents: () ->
    $(".toggler").on("click", =>
      @toggleState()
      $(@svgSelector).empty()
      @["#{@currentState}sChart"].render(@svgSelector)
      $(".toggler p").toggleClass("selected")
    )

  toggleState: () ->
    @currentState =
      if @currentState == "height" then "weight" else "height"
