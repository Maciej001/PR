@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Trade extends App.Entities.Model
		urlRoot: "/trades"

	class Entities.TradesCollection extends App.Entities.Collection
		model: Entities.Trade
		url: Routes.trades_path()


		comparator: (model) ->
			#sorting latest updated_at goes first
			date = new Date (model.get('updated_at'))
			-date.getTime()

	API = 

		getNewTradeEntity: ->
			new Entities.Trade

		getMyExecutedTradesCollection: ->
			defer = $.Deferred()
			trades = new Entities.TradesCollection
			
			trades.fetch
				reset: 		true
				success:	->
					defer.resolve(trades)
			defer.promise()

		getAllTrades: ->
			defer = $.Deferred()
			all_trades = new Entities.TradesCollection
			all_trades.fetch
				data: 
					reset: true
					side: 'buy' 
				success: ->
					defer.resolve(all_trades)
			defer.promise()

	App.entitiesBus.reply "get:new:trade:entity", ->
		API.getNewTradeEntity()

	App.entitiesBus.reply "get:my:executed:trades:collection", ->
		API.getMyExecutedTradesCollection()

	App.entitiesBus.reply "get:all:trades", ->
		API.getAllTrades()
