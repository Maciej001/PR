@Payrollsio.module "MarketApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.LayoutView extends App.Views.LayoutView
		template: "market/show/show_layout"

		regions: 
			rtmarketRegion: 	"#rtmarket-region"
			chartRegion: 			"#chart-region"
			sessionRegion: 		"#session-region"

	class Show.RTMarket extends App.Views.ItemView
		template: "market/show/_rtmarket" 

	class Show.Chart extends App.Views.ItemView
		template: "market/show/_chart"

	class Show.Session extends App.Views.ItemView
		template: 	"market/show/_session"




