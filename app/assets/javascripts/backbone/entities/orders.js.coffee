@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Order extends App.Entities.Model
		urlRoot: '/orders'


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

		newOrderEntityFromData: (data) ->
			check_data = data
			check_data.user_id = App.currentUser.id

			if check_data.side is "0"
				check_data.side = 'bid'
			else 
				check_data.side = 'offer'

			new Entities.Order check_data

		getOrdersCollection: (orders) ->
			new Entities.OrdersCollection orders


	App.entitiesBus.reply "get:active:orders", ->
		API.getActiveOrders()

	App.entitiesBus.reply "get:order", (id) ->
		API.getOrder id

	App.entitiesBus.reply "new:order:entity", ->
		API.newOrderEntity
			user_id: App.currentUser

	App.entitiesBus.reply "new:order:entity:from:data", (data) ->
		API.newOrderEntityFromData data

	App.entitiesBus.reply "get:orders:collection", (orders) ->
		API.getOrdersCollection orders



