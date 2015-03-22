@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Trade extends App.Entities.Model
		urlRoot: "/trades"

	class Entities.TradesCollection extends App.Entities.Collection
		model: Entities.Trade
		url: 	Routes.trades_path()

		comparator: (model) ->
			#sorting latest updated_at goes first
			date = new Date (model.get('updated_at'))
			-date.getTime()

	API = 

		newTradeEntity: ->
			trade = new Entities.Trade

		getTradesCollection: ->
			new Entities.TradesCollection

		getExecutedTradesCollection: ->
			defer = $.Deferred()
			trades = new Entities.TradesCollection
			trades.fetch
				reset: 		true
				user_id: 	App.currentUser
				success:	->
					defer.resolve(trades)
			defer.promise()

	App.entitiesBus.reply "new:trade:entity", ->
		API.newTradeEntity
			user_id: App.currentUser

	App.entitiesBus.reply "get:executed:trades:collection", ->
		API.getExecutedTradesCollection()
