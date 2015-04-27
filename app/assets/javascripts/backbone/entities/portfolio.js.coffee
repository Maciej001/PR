@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Portfolio extends App.Entities.Model 
		urlRoot: Routes.portfolios_path()

	API = 

		getPortfolio: (user) ->
			defer = $.Deferred()
			portfolio = new Entities.Portfolio({id: 2})

			portfolio.fetch
				reset: true
				success: (portfolio) ->
					defer.resolve(portfolio)
			defer.promise()

	App.entitiesBus.reply "get:current:user:portfolio", (user) ->
		API.getPortfolio user
