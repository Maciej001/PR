@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application   
		
		initialize: ->
			@orders_fetching = App.entitiesBus.request "get:active:orders"
			console.log "fetching orders from server..."
			
			@layoutView = @getLayoutView()
			
			@listenTo @layoutView, "show", =>
				@ordersRegion()
				@chartRegion() 
				@sessionRegion()

				@orders_fetching.done (orders) =>
					

					@listOrdersRegion orders

			@show @layoutView

			

		delay: (ms, func) -> 
			setTimeout func, ms

		listOrdersRegion: (orders) ->
			@delay 200, =>
				console.log "orders: ", orders
				ordersListView = @getListOrdersView orders
				console.log ordersListView
				@show ordersListView, region: @layoutView.listOrdersRegion

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

		getListOrdersView: (orders) ->
			new Show.ListOrdersView 
				collection: orders

		getOrdersView: ->
			new Show.Orders 

		getChartView: ->
			new Show.Chart

		getSessionView: ->
			new Show.Session

		getLayoutView: ->
			new Show.LayoutView



