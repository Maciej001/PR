@Payrollsio = do (Backbone, Marionette) ->

	App = new Marionette.Application

	App.entitiesBus = Backbone.Radio.channel('entities')
	App.mainBus = Backbone.Radio.channel('main')

	# App.rootRoute = "application#index"

	App.addRegions
		marketRegion:	"#main-region"

	App.addInitializer ->
		App.module("MarketApp").start()

	# App.on "start", (options) ->
	# 	@startHistory()
	# 	@navigate(@rootRoute, trigger: true) unless @getCurrentRoute()

	App.mainBus.reply "default:region", App.marketRegion 

	App