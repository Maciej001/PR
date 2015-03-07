@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Order extends App.Entities.Model
		urlRoot: -> Routes.orders_path()

	class Entities.OrdersCollection extends App.Entities.Collection
		model: Entities.Order

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

		newOrder: ->
			order = new Entities.Order

	App.entitiesBus.reply "get:active:orders", ->
		console.log "fetching orders"
		API.getActiveOrders()

	App.entitiesBus.reply "get:order", (id) ->
		API.getOrder id


	App.entitiesBus.reply "new:order", ->
		API.newOrder()