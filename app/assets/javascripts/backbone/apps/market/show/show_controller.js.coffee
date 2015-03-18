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

					@refreshMarket()	
					
					@my_orders  = @getMyOrders @all_orders
					@listOrdersRegion @my_orders
					
					@chartRegion() 
					@sessionRegion()

			App.mainBus.on "new:order:added", (new_order) =>
				@addNewOrder new_order

			@show @layoutView

		refreshMarket: ->
			@bids = @getSortedBids @all_orders 
			@bidsRegion @bids

			@offers = @getSortedOffers @all_orders 
			@offersRegion @offers

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

		highest_bid: ->
			@bids.at(0).get('price')

		lowest_offer: ->
			@offers.at(0).get('price')


		is_bid: (order) ->
			return true if order.get('side') is 'bid'
			false

		is_offer: (order) ->
			return true if order.get('side') is 'offer'
			false

		trading_with_myself: (new_order) ->
			if @is_bid new_order
				return true if @lifting_my_offer new_order
			else 
				return true if @hitting_my_bid new_order

			false

		hitting_my_bid: (new_order) ->
			my_bid_prices = @my_orders.map (order) =>
				order.get('price') if @is_bid(order)
			
			my_highest_bid = _.max( _.compact my_bid_prices	)
			
			if my_highest_bid >= new_order.get 'price'
				return true

			false

		lifting_my_offer: (new_order) ->
			my_offer_prices = @my_orders.map (order) =>
				order.get('price') if @is_offer(order)
			
			my_lowest_offer = _.min( _.compact my_offer_prices	)
			
			if new_order.get('price') >= my_lowest_offer
				return true

			false

		valid_trade: (new_order) ->
			if @is_offer new_order
				if new_order.get('price') > @highest_bid() or @hitting_my_bid new_order
					return false

			if @is_bid new_order
				if new_order.get('price') < @lowest_offer() or @lifting_my_offer new_order
					return false

			return true


		# Function decides what to do with newly submitted order 
		addNewOrder: (new_order) ->
			if @valid_trade new_order
				# Execute trade
				console.log "ready to execute"
			else if @trading_with_myself new_order
				console.log "trading with yourself?!"
			else
				# save to database
				console.log "regular order, so save it"
				@all_orders.add new_order
				@refreshMarket()






