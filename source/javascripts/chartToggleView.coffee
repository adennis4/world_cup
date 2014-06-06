class WC.ChartToggleView
  constructor: (data) ->
    @data = data
    @defineEvents()
    @heightsChart = new WC.HeightsView(@data)
    @weightsChart = new WC.WeightsView(@data)
    @currentState = @heightsChart

  render: () ->
    @heightsChart.render()

  defineEvents: () ->
    $(".toggler").on("click", =>
      $('#heightGraphContainer svg').empty()
      @currentState =
        if @currentState == @heightsChart then @weightsChart else @heightsChart
      @currentState.render()
    )
