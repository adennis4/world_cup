class WC.ChartToggleView
  svgSelector: "#barGraphContainer svg"

  constructor: (data) ->
    @data = data
    @defineEvents()
    @heightsChart = new WC.HeightsView(@data)
    @weightsChart = new WC.WeightsView(@data)
    @currentState = @heightsChart

  render: () ->
    @heightsChart.render(@svgSelector)

  defineEvents: () ->
    $(".toggler").on("click", =>
      $(@svgSelector).empty()
      @currentState =
        if @currentState == @heightsChart then @weightsChart else @heightsChart
      @currentState.render(@svgSelector)
    )
