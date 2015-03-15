@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	# class Entities.Order extends App.Entities.Model
	# 	urlRoot: -> Routes.orders_path()

	class Entities.Order extends App.Entities.Model
		urlRoot: "/orders"


	class Entities.OrdersCollection extends App.Entities.Collection
		model: Entities.Order
		url: 	Routes.orders_path()

		comparator: (model) ->
			#sorting latest updated_at goes first
			date = new Date (model.get('updated_at'))
			-date.getTime()

	API = 

		getActiveOrders: ->
			defer = $.Deferred()
			orders = new Entities.OrdersCollection
			orders.fetch
				reset: true
				success: ->
					defer.resolve(orders)
			defer.promise()

		getOrder: (id) ->
			order = new Entities.Order
				id: id

			order.fetch()
			order

		newOrderEntity: ->
			order = new Entities.Order

		getOrdersCollection: (orders) ->
			new Entities.OrdersCollection orders

		getBidsCollection: (bids) ->
			new Entities.OrdersCollection bids

		getOffersCollection: (offers) ->
			new Entities.OrdersCollection offers

	App.entitiesBus.reply "get:active:orders", ->
		API.getActiveOrders()

	App.entitiesBus.reply "get:order", (id) ->
		API.getOrder id


	App.entitiesBus.reply "new:order:entity", ->
		API.newOrderEntity
			user_id: App.current_user

	App.entitiesBus.reply "get:orders:collection", (orders) ->
		API.getOrdersCollection orders

	App.entitiesBus.reply "get:bids:collection", (bids) ->
		API.getBidsCollection bids		

	App.entitiesBus.reply "get:offers:collection", (offers) ->
		API.getOffersCollection offers



