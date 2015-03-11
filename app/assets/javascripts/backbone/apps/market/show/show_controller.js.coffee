@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application   
		
		initialize: ->
			orders = App.entitiesBus.request "get:active:orders"
			
			console.log "Oders fetched?", orders

			@layoutView = @getLayoutView()

			@listenTo @layoutView, "show", =>
				@ordersRegion()
				@chartRegion() 
				@sessionRegion()
				@listOrdersRegion()
 
			@show @layoutView


		listOrdersRegion: ->
			ordersListView = @getListOrdersView()

		ordersRegion: ->
			ordersView = @getOrdersView()

			@listenTo ordersView, "new:order:clicked", =>
				@newOrderClicked()

			@show ordersView, region: @layoutView.ordersRegion

		newOrderClicked: ->
			App.mainBus.trigger "new:order:form", @layoutView.newOrderRegion

		chartRegion: ->
			chartView = @getChartView()
			@show chartView, region: @layoutView.chartRegion

		sessionRegion: ->
			sessionView = @getSessionView()
			@show sessionView, region: @layoutView.sessionRegion

		getListOrdersView: ->
			new: 

		getOrdersView: ->
			new Show.Orders 

		getChartView: ->
			new Show.Chart

		getSessionView: ->
			new Show.Session

		getLayoutView: ->
			new Show.LayoutView



