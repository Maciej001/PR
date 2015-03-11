@Payrollsio.module "Components.Form", (Form, App, Backbone, Marionette, $, _) ->

	class Form.Controller extends App.Controllers.Application

		initialize: (options = {}) ->
			@contentView = options.view
			@formLayout = @getFormLayout options.config

			@listenTo @formLayout, "show", @formContentRegion
			@listenTo @formLayout, "form:submit", @formSubmit
			@listenTo @formLayout, "form:cancel", @formCancel

		formCancel: ->
			@contentView.triggerMethod "form:cancel"

		formSubmit: ->
			data = Backbone.Syphon.serialize @formLayout 

			model = @contentView.model
			console.log "mode in formSubmit", model
			collection = @contentView.collection

			@processFormSubmit data, model, collection

		processFormSubmit: (data, model, collection) ->

			console.log "DEBUG: processing submit"
			console.log "model", model
			console.log "data", data

			model.save data,  
				collection: collection 

		formContentRegion: ->
			@region = @formLayout.formContentRegion
			@show @contentView 

		getFormLayout: (options = {}) ->
			# _.result(object, property)
			# _.result lets you get a named value from an object
			# without knowing weather that value is stored as 
			# property or a method
			# in below case @contentView.form - can be either 
			# property or a method and we still get an object
			# form { footer: false }
			config = @getDefaultConfig _.result(@contentView, "form")

			# takes config objects, and adds/overwrites its properties 
			# with options object properties.
			_.extend config, options

			buttons = @getButtons config.buttons

			new Form.FormWrapper
				config: config

				# forms require models in all cases no matter what!
				model: @contentView.model 
				buttons: buttons 

		getDefaultConfig: (config = {}) ->
			# _.defaults(object, *defaults) - fills in undefined properties
			# in object with the first value in the following list 
			# of defaults objects
			# If form footer is undefined than it's set to 'true'
			_.defaults config,
				footer: true
				focusFirstInput: true
				errors: true    # on/off switch for errors parsing in form_view
				syncing: true 	# if syncStart and syncStop should be serviced
												# form_view.js.coffee

		getButtons: (buttons = {}) ->
			App.entitiesBus.request("get:form:button:entities", buttons, @contentView.model) unless buttons is false
	
	App.mainBus.reply "form:wrapper", (contentView, options = {}) ->
		throw new Error "No model found inside of form's contentView" unless contentView.model 

		formController = new Form.Controller
			view: contentView
			config: options

		formController.formLayout 




