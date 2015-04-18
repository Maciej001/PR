@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Stats extends App.Entities.Model 
		defaults: 
			total_contracts_traded	: 0
			number_of_trades				: 0
			open										: 0
			high										: 0
			low											: 0 
			last										: 0
			


