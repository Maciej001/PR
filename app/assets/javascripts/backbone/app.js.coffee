@Payrollsio = do (Backbone, Marionette) ->

	App = new Marionette.Application

	App.entitiesBus = Backbone.Radio.channel('entities')
	App.mainBus = Backbone.Radio.channel('main')

	App.on "before:start", (options) ->
		# App.environment = options.environment
		App.navs = App.entitiesBus.request "nav:entities"

	# App.rootRoute = Routes.crew_index_path()

	App.rootRoute = "application#index"

	App.addRegions
		headerRegion: "#header-region"
		userRegion:		"#user-region"
		marketRegion:	"#market-region"
		footerRegion:	"#footer-region"
		formRegion: 	"#form-region"

	App.addInitializer ->
		App.module("HeaderApp").start(App.navs)
		App.module("FooterApp").start()
		App.module("UserApp").start()
		App.module("MarketApp").start()

	App.on "start", (options) ->
		@startHistory()
		@navigate(@rootRoute, trigger: true) unless @getCurrentRoute()

	App.mainBus.reply "default:region", App.marketRegion 


	App