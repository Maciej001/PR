@Payrollsio = do (Backbone, Marionette) ->

	App = new Marionette.Application

	App.entitiesBus = Backbone.Radio.channel('entities')
	App.mainBus = Backbone.Radio.channel('main')

	# App.rootRoute = Routes.crew_index_path()

	App.rootRoute = "application#index"

	App.addRegions
		marketRegion:	"#market-region"

	App.addInitializer ->
		$('footer').remove() 
		App.module("MarketApp").start()

	App.on "start", (options) ->
		@startHistory()
		@navigate(@rootRoute, trigger: true) unless @getCurrentRoute()

	App.mainBus.reply "default:region", App.marketRegion 

	App