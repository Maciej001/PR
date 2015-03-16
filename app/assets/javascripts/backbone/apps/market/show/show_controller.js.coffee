@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application 
		@all_orders = {}
		@bids = {}
		@offers = {}
		@transactions = {}

		initialize: =>
			@orders_fetching = App.entitiesBus.request "get:active:orders"
			
			@layoutView = @getLayoutView()
			
			@listenTo @layoutView, "show", ->

				# one off action on first 'show'
				@orders_fetching.done (orders) =>
					@all_orders = orders

					@bids = @getSortedBids orders 
					@bidsRegion @bids

					@offers = @getSortedOffers orders 
					@offersRegion @offers
					
					@my_orders  = @getMyOrders orders
					@listOrdersRegion @my_orders
					
					@chartRegion() 
					@sessionRegion()

			@show @layoutView

		getMyOrders: (orders) ->
			my_orders_array = orders.where user_id: App.currentUser.id
			App.entitiesBus.request "get:orders:collection", my_orders_array

		getSortedBids: (orders) ->
			bids_collection = App.entitiesBus.request "get:orders:collection", orders.where side: 'bid'
			
			bids_collection.comparator = (bid) ->	
				-bid.get('price')

			bids_collection.sort()
			bids_collection

		getSortedOffers: (orders) ->
			offers_collection = App.entitiesBus.request "get:orders:collection", orders.where side: 'offer'
			
			offers_collection.comparator = (offer) ->
				+offer.get('price')

			offers_collection.sort()
			offers_collection

		delay: (ms, func) -> 
			setTimeout func, ms

		listOrdersRegion: (orders) ->
			ordersListView = @getListOrdersView orders
			@show ordersListView, region: @layoutView.listOrdersRegion

			@listenTo ordersListView, "new:order:clicked", ->
				@newOrderClicked()

			@listenTo ordersListView, "childview:delete:order:clicked", (args) ->
				{ model } = args
				# remove model from database
				model.destroy()

				# remove model form collection
				model.collection.remove(model)

			@listenTo ordersListView, "orders:sort:by:price", (args) ->

		ordersRegion: (bids, offers) ->
			ordersView = @getOrdersLayout()
			@show ordersView, region: @layoutView.ordersRegion

		bidsRegion: (bids) ->
			bidsView = @getBidsView bids
			@show bidsView, region: @layoutView.bidsRegion

		offersRegion: (offers) ->
			offersView = @getOffersView offers
			@show offersView, region: @layoutView.offersRegion

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

		getBidsView: (bids) ->
			new Show.Bids
				collection: bids

		getOffersView: (offers) ->
			new Show.Offers 
				collection: offers

		getChartView: ->
			new Show.Chart

		getSessionView: ->
			new Show.Session

		getLayoutView: ->
			new Show.LayoutView




