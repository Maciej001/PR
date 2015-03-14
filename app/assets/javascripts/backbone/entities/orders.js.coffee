@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	# class Entities.Order extends App.Entities.Model
	# 	urlRoot: -> Routes.orders_path()

	class Entities.Order extends App.Entities.Model
		urlRoot: "/orders"


	class Entities.OrdersCollection extends App.Entities.Collection
		model: Entities.Order
		url: 	Routes.orders_path()
		comparator: 'price'

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

	App.entitiesBus.reply "get:active:orders", ->
		API.getActiveOrders()

	App.entitiesBus.reply "get:order", (id) ->
		API.getOrder id


	App.entitiesBus.reply "new:order:entity", ->
		API.newOrderEntity
			user_id: App.current_user