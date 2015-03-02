@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application   
		
		initialize: ->
			# prices = App.request "prices:entities"
			@layoutView = @getLayoutView()


			@listenTo @layoutView, "show", =>
				@rtmarketRegion()
				@chartRegion()
				@sessionRegion()
 
			@show @layoutView

		rtmarketRegion: ->
			rtmarketView = @getRTMarketView()
			@show rtmarketView, region: @layoutView.rtmarketRegion

		chartRegion: ->
			chartView = @getChartView()
			@show chartView, region: @layoutView.chartRegion

		sessionRegion: ->
			sessionView = @getSessionView()
			@show sessionView, region: @layoutView.sessionRegion

		getRTMarketView: ->
			new Show.RTMarket

		getChartView: ->
			new Show.Chart

		getSessionView: ->
			new Show.Session

		getLayoutView: ->
			new Show.LayoutView



