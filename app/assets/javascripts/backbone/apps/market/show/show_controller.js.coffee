@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application 
		@all_orders 		= {}
		@bids 					= {}
		@offers 				= {}
		@transactions 	= {}
		@my_orders 			= {}
		@my_trades 			= {}

		initialize: =>
			@orders_fetching = App.entitiesBus.request "get:active:orders"
			@fetching_my_trades = App.entitiesBus.request "get:my:executed:trades:collection"
			
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

				@fetching_my_trades.done (trades) =>
					@my_trades = trades
					@listTradesRegion @my_trades

			App.mainBus.on "new:order:added", (new_order) =>
				@addNewOrder new_order

			App.mainBus.reply "check:if:trading:with:myself", (new_order) =>
				@trading_with_myself new_order

			App.mainBus.reply "trading:with:myself", (new_order) =>

			@show @layoutView

		trading_with_myself: (new_order) ->
			if @is_bid new_order
				if @lifting_my_offer new_order
					console.log 'lifting my offer'
					return true 
			else 
				return true if @hitting_my_bid new_order

			false

		refreshMarket: ->
			@refreshBids()
			@refreshOffers()

		refreshBids: ->
			@bids = @getSortedBids @all_orders 
			@bidsRegion @bids
			
		refreshOffers: ->
			@offers = @getSortedOffers @all_orders 
			@offersRegion @offers

		getMyOrders: (orders) ->
			my_orders_array = orders.where 
				user_id: 	App.currentUser.id
				state: 		'active'
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

			@listenTo orders, 'change', (order) -> 
				order.collection.remove(order) if order.get('state') is 'executed'
					
		listTradesRegion: (trades) ->
			tradesListView = @getTradesListView trades
			@show tradesListView, region: @layoutView.listTradesRegion

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

		getTradesListView: (trades) ->
			new Show.ListTradesView
				collection: trades

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
			if @bids.length > 0 
				@bids.at(0).get('price')
			else
				null

		lowest_offer: ->
			if @offers.length > 0
				@offers.at(0).get('price') 
			else
				null

		is_bid: (order) ->
			return true if order.get('side') is 'bid'
			false

		is_offer: (order) ->
			return true if order.get('side') is 'offer'
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



		executeTrade: (new_order) ->
			remaining_size 	= new_order.get('size_left')
			price 					= parseInt( new_order.get('price') )
			complete 				= false

			if @is_bid new_order 		# BUY order


				# every is jquery function executing callback function until it return false

				# Implement using simple while function

				@offers.models.every (offer) =>
					
					offer_price = parseInt( offer.get('price') )
					offer_size  = parseInt( offer.get('size_left') )

					if price >= offer_price		

						#  CASE 1: Full execution & size left on the offer
						if remaining_size < offer_size and remaining_size > 0

							@saveTrade { price: offer_price, size: remaining_size, user_id:	App.currentUser.id, 	side: 'buy' } 	# Buyer
							@saveTrade { price: offer_price, size: remaining_size, user_id:	offer.get('user_id'), side: 'sell' } 	# Seller

							# Update offer: decrease size_left
							offer.save size_left: (offer_size - remaining_size),
								collection: @offers

							new_order.save
								state: 			'executed'
								size_left: 	0,
								collection: @all_orders

						else if remaining_size >= offer_size and remaining_size > 0

							@saveTrade { price:	offer_price, size: remaining_size, user_id:	App.currentUser.id,		side: 'buy' } 	# Buyer
							@saveTrade { price: offer_price, size: remaining_size, user_id: offer.get('user_id'),	side: 'sell' }	# Seller
							
							# change offer state to 'executed' and remove from @offers
							offer.set 
								size_left: 	0
								state:			'executed'

							offer.save
								collection: @offers

							# decrease size left on new_order
							new_order.set
								size_left: size_left - offer.get('size')

		valid_order: (new_order) ->
			if @is_offer new_order
				if (parseInt new_order.get('price')) <= (parseInt @highest_bid()) 
					return false
				else
					return true

			if @is_bid new_order
				if (parseInt new_order.get('price')) >= (parseInt @lowest_offer()) 
					return false
				else 
					return true

			false

		saveTrade: (data) ->
			trade = App.entitiesBus.request "get:new:trade:entity"
			trade.set data
			trade.set 
				created_at: new Date()
				updated_at: new Date()
			trade.save()

			# for current user add trade to @my_trades
			if data.user_id is App.currentUser.id
				@my_trades.add trade

		# Function decides what to do with newly submitted order - we know now that we don't trade with ourselves
		addNewOrder: (new_order) ->
			if @valid_order new_order

				# update collections & refresh market (bids&offers)
				@all_orders.add new_order
				@my_orders.add new_order
				@refreshMarket()

			else
				@executeTrade new_order









