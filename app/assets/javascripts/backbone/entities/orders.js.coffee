@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Order extends App.Entities.Model
		urlRoot: -> Routes.new_order_path()

	class Entities.OrdersCollection extends App.Entities.Collection
		model: Entities.Order
		url: 	Routes.orders_path()

	API = 

		getActiveOrders: ->
			orders = new Entities.OrdersCollection
			orders.fetch
				reset: true

			orders

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
		API.newOrderEntity()