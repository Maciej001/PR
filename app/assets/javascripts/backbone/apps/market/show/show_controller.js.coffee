@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application 
		@all_orders = {}
		@best_bid = 0 
		@best_offer = 1000

		initialize: =>
			@orders_fetching = App.entitiesBus.request "get:active:orders"
			
			@layoutView = @getLayoutView()
			
			@listenTo @layoutView, "show", ->
				@orders_fetching.done (orders) =>
					@all_orders = orders
					console.log "and now all_orders", @all_orders

					@bids = @getBids orders
					@bids.comparator = (bid) ->
						-bid.get('price')

					@bids.sort()
					@bidsRegion @bids

					@offers = @getOffers orders
					@offers.comparator = (offer) ->
						+offer.get('price')
						
					@offers.sort()
					@offersRegion @offers
					
					@my_orders  = @getMyOrders orders
					@listOrdersRegion @my_orders
					
					@chartRegion() 
					@sessionRegion()

			@show @layoutView

		getMyOrders: (orders) ->
			my_orders_array = orders.where user_id: App.currentUser.id
			App.entitiesBus.request "get:orders:collection", my_orders_array

		getBids: (orders) ->
			bids = orders.where side: 'bid'
			App.entitiesBus.request "get:bids:collection", bids

		getOffers: (orders) ->
			offers = orders.where side: 'offer'
			App.entitiesBus.request "get:offers:collection", offers

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




