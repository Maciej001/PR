@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application   
		
		initialize: ->
			orders = App.entitiesBus.request "get:active:orders"

			@layoutView = @getLayoutView()

			@listenTo @layoutView, "show", =>
				@ordersRegion()
				@chartRegion() 
				@sessionRegion()
 
			@show @layoutView

		ordersRegion: ->
			ordersView = @getOrdersView()

			@listenTo ordersView, "new:order:clicked", =>
				@newOrderClicked @layoutView.newOrderRegion

			@show ordersView, region: @layoutView.ordersRegion

		newOrderClicked: (region) ->
			App.mainBus.trigger "new:order:form", region

		chartRegion: ->
			chartView = @getChartView()
			@show chartView, region: @layoutView.chartRegion

		sessionRegion: ->
			sessionView = @getSessionView()
			@show sessionView, region: @layoutView.sessionRegion

		getOrdersView: ->
			new Show.Orders 

		getChartView: ->
			new Show.Chart

		getSessionView: ->
			new Show.Session

		getLayoutView: ->
			new Show.LayoutView



