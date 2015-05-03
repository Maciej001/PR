@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Controller extends App.Controllers.Application 
		@all_orders 		= {}
		@bids 					= {}
		@offers 				= {}
		@my_orders 			= {}
		@my_trades 			= {}
		@all_trades			= {}
		@stats 					= {}
		@portfolio 			= {}

		initialize: =>
			@orders_fetching 			=	App.entitiesBus.request "get:active:orders"
			@fetching_my_trades 	= App.entitiesBus.request "get:my:executed:trades:collection"
			@stats_fetching 			=	App.entitiesBus.request "get:session:stats"
			@all_trades_fetching	= App.entitiesBus.request "get:all:trades"
			@portfolio_fetching 	= App.entitiesBus.request "get:current:user:portfolio", App.currentUser
			
			@layoutView = @getLayoutView()
			
			@listenTo @layoutView, "show", ->

				@orders_fetching.done (orders) =>
					@all_orders = orders
					@refreshMarket()	
					
					@my_orders  = @getMyOrders @all_orders
					@listOrdersRegion @my_orders
				
				@all_trades_fetching.done (all_trades) =>
					@all_trades = all_trades
					@chartRegion()

				@stats_fetching.done (stats) =>
					@stats = stats
					@sessionRegion()

				@fetching_my_trades.done (trades) =>
					@my_trades = trades
					@listTradesRegion @my_trades

					# execute after @my_trades fetched
					@portfolio_fetching.done (portfolio) =>
						@portfolio = portfolio
						@recalculatePortfolio()
						@portfolioRegion()

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

			@listenTo bidsView, "childview:bid:price:clicked", (args) ->
				{model} = args
				if model.get('user_id') isnt App.currentUser.id
					model.set('side', "sell")
					@newOrderClicked model


		offersRegion: (offers) ->
			offersView = @getOffersView offers
			@show offersView, region: @layoutView.offersRegion

			@listenTo offersView, "childview:ask:price:clicked", (args) ->
				{model} = args
				if model.get('user_id') isnt App.currentUser.id
					model.set('side', "buy")
					@newOrderClicked model

		newOrderClicked: (order)->
			App.mainBus.trigger "new:order:form", @layoutView.newOrderRegion, order

		chartRegion: ->
			data = {}
			data.labels = []

			chartView = @getChartView()
			@show chartView, region: @layoutView.chartRegion

			#find only buy trades
			chart_trades =  _.where @all_trades.toJSON(), {side: "buy"}

			# extract price array from buy trades
			trades_array = _.pluck chart_trades, 'price'

			data.series = [ trades_array.reverse() ] # series is an array of arrays
			prices = data.series[0]

			prices.forEach (price) ->
				data.labels.push ''

			options = 
				fullWidth: true
				height: 400
				showArea: true
				chartPadding:
					right: 20
					left: 20
				low: (@minArray data.series[0]) - 1
				high: (@maxArray data.series[0]) + 1
				lineSmooth: false
				axisY:
					labelInterpolationFnc: (value) ->
						Math.floor(value) + ' K'

			chart = new Chartist.Line('.ct-chart', data, options)	


		sessionRegion: ->
			sessionView = @getSessionView @stats
			@show sessionView, region: @layoutView.sessionRegion

		portfolioRegion: =>
			portfolioView = @getPortfolioView()
			@show portfolioView, region: @layoutView.portfolioRegion

		getPortfolioView: ->
			new Show.Portfolio
				model: @portfolio

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

		getSessionView: (stats) ->
			new Show.Session 
				model: stats

		getLayoutView: ->
			new Show.LayoutView


		minArray: (tab) ->
			Math.min.apply null, tab

		maxArray: (tab) ->
			Math.max.apply null, tab

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


		# Function decides what to do with newly submitted order - we know now that we don't trade with ourselves
		addNewOrder: (new_order) ->
			if @valid_order new_order

				# update collections & refresh market (bids&offers)
				@addOrder new_order
				@refreshMarket()

			else
				@executeTrade new_order

		addOrder: (order) ->
			@all_orders.add order
			@my_orders.add order


		updateStats: (price, size) ->
			console.log "updating price #{price} and size: #{size}"
			total_contracts_traded = parseInt(@stats.get('total_contracts_traded')) + size
			number_of_trades = parseInt(@stats.get('number_of_trades')) + 1

			first_trade = false
			first_trade = true if parseInt( @stats.get('open') ) is 0

			if first_trade
				open = price if first_trade
				high = low = last = open 


			high = price if parseInt( @stats.get('high') ) < price
			low  = price if parseInt( @stats.get('low') ) > price
			last = price

			@stats.set({
					'total_contracts_traded': total_contracts_traded
					'number_of_trades':				number_of_trades
					'open': 									open
					'high':										high
					'low':										low
					'last': 									last
				})

			@stats.save()

		saveTrade: (data) ->
			trade = App.entitiesBus.request "get:new:trade:entity"
			trade.set data
			trade.set 
				created_at: new Date()
				updated_at: new Date()
			trade.save()

			@all_trades.add trade

			if data.user_id is App.currentUser.id
				@my_trades.add trade


		executeTrade: (new_order) ->
			trades_stats = []
			removed_orders = []
			size_left = parseInt new_order.get('size_left')
			new_order_price = parseInt new_order.get('price')

			if @is_bid new_order  # BUY ORDER

				for order in @offers.models when size_left > 0

					offer_price = parseInt order.get('price')
					order_size_left = parseInt order.get('size_left')

					if (new_order_price < offer_price)
						new_order.save('size_left', size_left) 
						@addOrder new_order
						@bids.add new_order
						size_left = 0 # to stop the loop

					else 

						if (size_left > order_size_left) # want to buy more than offer
							@saveTrade { price: offer_price, size: order_size_left, user_id:	App.currentUser.id, 	side: 'buy' } 	# Buyer
							@saveTrade { price: offer_price, size: order_size_left, user_id:	order.get('user_id'), side: 'sell' } 	# Seller
							
							# add trade to trades statistics array
							trades_stats.push { price: offer_price, size:	order_size_left, side: 'buy' }

							size_left -= order_size_left
							order_size_left = 0
							
						else if (size_left is order_size_left) # buy what's on the offer
							@saveTrade { price: offer_price, size: order_size_left, user_id:	App.currentUser.id, 	side: 'buy' } 	# Buyer
							@saveTrade { price: offer_price, size: order_size_left, user_id:	order.get('user_id'), side: 'sell' } 	# Seller

							# add trade to trades statistics array
							trades_stats.push { price: offer_price, size:	order_size_left, side: 'buy' }
							
							size_left = order_size_left = 0

						else #buy less then offer
							@saveTrade { price: offer_price, size: size_left, user_id:	App.currentUser.id, 	side: 'buy' } 	# Buyer
							@saveTrade { price: offer_price, size: size_left, user_id:	order.get('user_id'), side: 'sell' } 	# Seller

							# add trade to trades statistics array
							trades_stats.push { price: offer_price, size:	size_left, side: 'buy' }

							order_size_left -= size_left 
							size_left = 0
							order.save({size_left: order_size_left})

						if order_size_left is 0 
							order.save({size_left: 0, state: 'executed'})
							
							# executed orders where order_size_left == 0 are pushed to array and removed only after THIS loop finishes.
							# otherwise they would mess up indexes within loop
							removed_orders.push order

						if size_left is 0
							new_order.save({size_left: 0, state: 'executed'})


				# remove fully executed orders
				for order in removed_orders
					@offers.remove order

			else  # SELL ORDER

				for order in @bids.models when size_left > 0

					bid_price = parseInt order.get('price')
					order_size_left = parseInt order.get('size_left')

					if (new_order_price > bid_price)
						new_order.save('size_left', size_left) 
						@addOrder new_order
						@offers.add new_order
						size_left = 0 					# stop the loop

					else 

						if (size_left > order_size_left) # sell more then bid
							@saveTrade { price: bid_price, size: order_size_left, user_id:	App.currentUser.id, 	side: 'sell' } 	# I Sell
							@saveTrade { price: bid_price, size: order_size_left, user_id:	order.get('user_id'), side: 'buy' } 	# Buyer transaction

							# add trade to trades statistics array
							trades_stats.push { price: bid_price, size: order_size_left, side: 'sell' }

							size_left -= order_size_left
							order_size_left = 0
						
						else if (size_left is order_size_left) # sell exactly what's bid
							@saveTrade { price: bid_price, size: order_size_left, user_id:	App.currentUser.id, 	side: 'sell' } 	# I Sell
							@saveTrade { price: bid_price, size: order_size_left, user_id:	order.get('user_id'), side: 'buy' } 	# Buyer transaction

							# add trade to trades statistics array
							trades_stats.push { price: bid_price, size:	order_size_left, side: 'sell' }
							
							size_left = order_size_left = 0

						else # sell less then bid
							@saveTrade { price: bid_price, size: size_left, user_id:	App.currentUser.id, 	side: 'sell' } 	# I Sell
							@saveTrade { price: bid_price, size: size_left, user_id:	order.get('user_id'), side: 'buy' } 	# Buyer transaction

							# add trade to trades statistics array
							trades_stats.push { price: bid_price, size: size_left }

							order_size_left -= size_left 
							size_left = 0
							order.save({size_left: order_size_left})

						##############
						if order_size_left is 0 
							order.save({size_left: 0, state: 'executed'})
							
							# executed orders where order_size_left == 0 are pushed to array and removed only after THIS loop finishes.
							# otherwise they would mess up indexes within loop
							removed_orders.push order

						if size_left is 0
							new_order.save({size_left: 0, state: 'executed'})


				# remove fully executed orders
				for order in removed_orders
					@bids.remove order

				

			@racalculateStatistics trades_stats
			@recalculatePortfolio trades_stats

			# redraw chart
			@chartRegion()

		racalculateStatistics: (trades_stats) ->
			_.each trades_stats, (stat) =>
				@stats.set 'total_contracts_traded', Number(@stats.get('total_contracts_traded')) + stat.size
				@stats.set 'number_of_trades', Number(@stats.get('number_of_trades')) + 1
				@stats.set('open', stat.price) if Number(@stats.get('open')) is 0
				@stats.set 'high', stat.price if Number(@stats.get('high')) < stat.price
				@stats.set 'low', stat.price if Number(@stats.get('low')) > stat.price or Number(@stats.get('low')) is 0
				@stats.set 'last', stat.price

			@stats.save()


		recalculatePortfolio: ->
			contract_multipier = 10 
			contracts_traded = 0
			trades = @my_trades.length
			open_position = 0

			total_buy_price = 0
			total_sell_price = 0
			num_buy_trades = 0
			num_sell_trades = 0

			all_my_trades = @my_trades.toJSON()
			all_my_trades.reverse()

			_.each all_my_trades, (trade) ->
				contracts_traded += Number(trade.size)

				if trade.side == 'buy'
					open_position += Number(trade.size)
					num_buy_trades += Number(trade.size)
					total_buy_price += Number(trade.size) * Number(trade.price)
				else 
					open_position -= Number(trade.size)
					num_sell_trades += Number(trade.size)
					total_sell_price += Number(trade.size) * Number(trade.price)

			avg_buy_price = total_buy_price / num_buy_trades
			avg_sell_price = total_sell_price / num_sell_trades

			if num_buy_trades > num_sell_trades
				open_position_valuation = contract_multipier * (num_buy_trades - num_sell_trades) * ( Number(@highest_bid()) - avg_buy_price)
			else 
				# short position
				open_position_valuation = contract_multipier * (num_sell_trades - num_buy_trades) * ( avg_sell_price - Number(@lowest_offer()) )

			console.log "total sell trades", num_sell_trades
			console.log "total buy trades", num_buy_trades
			console.log "agv buy", avg_buy_price
			console.log "avg sell", avg_sell_price
			console.log "cena sell", avg_sell_price


			@portfolio.set 'contracts_traded', contracts_traded
			@portfolio.set 'number_of_trades', trades
			@portfolio.set 'open_position', open_position
			@portfolio.set 'open_postition_valuation', open_position_valuation
			@portfolio.set 'total_valuation', Number(@portfolio.get('cash')) + open_position_valuation 

			@portfolio.save()

















