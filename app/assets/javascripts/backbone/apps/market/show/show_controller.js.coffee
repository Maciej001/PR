@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application 
		
		initialize: ->
			@orders_fetching = App.entitiesBus.request "get:active:orders"
			
			@layoutView = @getLayoutView()
			
			@listenTo @layoutView, "show", =>
				@ordersRegion()
				@chartRegion() 
				@sessionRegion()

				@orders_fetching.done (orders) =>
					@all_orders = orders
					
					@my_orders  = @getMyOrders orders
					@listOrdersRegion @my_orders

			@show @layoutView

		getMyOrders: (orders) ->
			my_orders_array = orders.where user_id: App.currentUser.id
			App.entitiesBus.request "get:orders:collection", my_orders_array

		delay: (ms, func) -> 
			setTimeout func, ms

		listOrdersRegion: (orders) ->
			ordersListView = @getListOrdersView orders
			@show ordersListView, region: @layoutView.listOrdersRegion

			@listenTo ordersListView, "childview:delete:order:clicked", (args) ->
				{ model } = args
				# remove model from database
				model.destroy()

				# remove model form collection
				model.collection.remove(model)

			@listenTo ordersListView, "orders:sort:by:price", (args) ->


		ordersRegion: ->
			ordersView = @getOrdersView()

			@listenTo ordersView, "new:order:clicked", =>
				@newOrderClicked()

			@show ordersView, region: @layoutView.ordersRegion

		newOrderClicked: ->
			App.mainBus.trigger "new:order:form", @layoutView.newOrderRegion, @my_orders

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




