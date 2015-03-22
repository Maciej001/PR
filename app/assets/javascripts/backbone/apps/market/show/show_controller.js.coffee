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

			App.mainBus.reply "check:if:trading:with:myself", (new_order) =>
				@trading_with_myself new_order

			App.mainBus.reply "trading:with:myself", (new_order) =>


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
			bids_collection = App.entitiesBus.request "get:orders:collection", 
				orders.where 
					side: 	'bid'
					state: 	'active'
			
			bids_collection.comparator = (bid) ->	
				-bid.get('price')

			bids_collection.sort()
			bids_collection

		getSortedOffers: (orders) ->
			offers_collection = App.entitiesBus.request "get:orders:collection", 
				orders.where 
					side: 	'offer'
					state: 	'active'
			
			offers_collection.comparator = (offer) ->
				+offer.get('price')

			offers_collection.sort()
			offers_collection

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
				if @lifting_my_offer new_order
					return true 
			else 
				return true if @hitting_my_bid new_order

			false

		hitting_my_bid: (new_order) =>
			remaining_size = new_order.get('size_left')
			new_order_price = parseInt new_order.get('price')
			answer = false
			
			@bids.models.every (bid) ->
					bid_price = parseInt bid.get('price')

					return if answer or (remaining_size <= 0) or (bid_price < new_order_price)

					if bid.get('user_id') is new_order.get('user_id')
						answer = true
						return

					remaining_size -= parseInt bid.get('size_left')
						
			answer

		lifting_my_offer: (new_order) ->
			remaining_size = new_order.get('size_left')
			new_order_price = parseInt new_order.get('price')
			answer = false
			
			@offers.models.every (offer) ->

					offer_price = parseInt offer.get('price')

					return if answer or (remaining_size <= 0) or (offer_price > new_order_price)

					if offer.get('user_id') is new_order.get('user_id')
						answer = true
						return

					remaining_size -= parseInt offer.get('size_left')
						
			answer

		valid_order: (new_order) ->
			if @is_offer new_order
				if (parseInt new_order.get('price')) > (parseInt @highest_bid()) 
					return true

			if @is_bid new_order
				if (parseInt new_order.get('price')) < (parseInt @lowest_offer()) 
					return true

			false

		executeTrade: (new_order) ->
			remainig_size = new_order.get('size')

			if @is_bid new_order
				@offers.models.every (offer) ->

					if parseInt( new_order.get('price') ) >= parseInt( offer.get('prize') )
						if parseInt( new_order.get('size') ) < parseInt( offer.get('size_left') )
							@saveTrade
								price: 	parseInt( offer.get('prize') )
								size: 	parseInt( new_order.get('size') )

			else


		# Function decides what to do with newly submitted order 
		addNewOrder: (new_order) ->
			if @valid_order new_order
				@all_orders.add new_order
				@refreshMarket()
			else if not (@trading_with_myself new_order)
				@executeTrade new_order








