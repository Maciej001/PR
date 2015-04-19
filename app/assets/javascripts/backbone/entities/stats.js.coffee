@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Stats extends App.Entities.Model 
		urlRoot: Routes.stats_path()
		defaults: 
			total_contracts_traded	: 0
			number_of_trades				: 0
			open										: 0
			high										: 0
			low											: 0 
			last										: 0

	API = 

		getSessionStats: ->
			defer = $.Deferred()
			stats = new Entities.Stats
				'id': 1

			stats.fetch
				reset: true
				success: (stats) ->
					defer.resolve(stats)
			defer.promise()

	App.entitiesBus.reply "get:session:stats", ->
		API.getSessionStats()
			


