@Payrollsio.module "Components.Form", (Form, App, Backbone, Marionette, $, _) ->
	
	class Form.FormWrapper extends App.Views.LayoutView
		template: 	"form/form"
		tagName: 		"form"

		# we either want to 'edit' existing data or create 'new' form
		# so instead of setting "data-type": "edit"
		# let's use function
		attributes: ->
			"data-type":	@getFormDataType()

		regions:
			formContentRegion: "#form-content-region"  

		ui: 
			buttonContainer: "ul.inline-list"

		triggers: 
			"submit"	: 	"form:submit" 
			"click [data-form-button='cancel']":  "form:cancel "

		modelEvents:
			# _errors is set on model, in entities/_base/models
			# gets triggered by both @set _errors and @unset "_errors"
			# sync:start 
			# sync:stop - called from extended Backbone.sync 
			# 					- backbone/config/backbone/sync.js.coffee
			"change:_errors"	:	"changeErrors"
			"sync:start"			: "syncStart"
			"sync:stop"				: "syncStop"

		initialize: ->
			# originaly to access options we had to write @options.config
			# @options.buttons
			# setInstance... will create @config and @buttons, so these 
			# are available in FormWrapper instance
			# method will be available for all views so implementation is in 
			# views/_base/view.js.coffee
			@setInstancePropertiesFor "config", "buttons"

		# Item views serialize a model or collection by default calling toJSON
		# Here we additionally serialize footer, so @footer is available
		# in template
		# Layout recieves options that were passed when calling
		# new Form.FormWrapper
		#   config: config <- options
		serializeData: ->
			footer: 	@config.footer

			# .toJSON makes our collection model available to template
			# buttons are passed around but if buttons: false then they 
			# will not get serialized 
			# don't call toJSON if buttons? is undefined
			# If value is undefined then use false

			buttons: 	@buttons?.toJSON() ? false

		# to focus on first element of the form
		onShow: ->
			# defers invoking the function until the current call stack 
			# has cleared
			_.defer =>
				@focusFirstInput() if @config.focusFirstInput
				@buttonPlacement() if @buttons

		buttonPlacement: ->
			@ui.buttonContainer.addClass @buttons.placement    

		focusFirstInput: ->
			@$(":input:visible:enabled:first").focus()

		getFormDataType: ->
			# isNew() - if model has not been yet saved to the server 
			# if model doesn't have id it's considered to be 'new'
			@model.isNew() ? "new" : "edit"

		changeErrors: (model, errors, options) ->
		# whenever we bind to change event the callback receives 
		# model, changed value that triggered change, so in our case 
		# 'errors', and any options passed to the set method.
		# @config.errors can be on/off in form_controller 
			if @config.errors
				if _.isEmpty(errors) then @removeErrors() else @addErrors errors

		removeErrors: ->
			# remove class error from all elements that have .error class
			# and small elements that contain error message
			@$(".error").removeClass("error").find("small").remove()

		addErrors: (errors = {}) ->
			for name, array of errors
				@addError name, array[0]  # add just first message

		addError: (name, error) ->
			el = @$("[name='#{name}']")
			sm = $("<small>").text(error)
			el.after(sm).closest(".row").addClass("error")

		syncStart: ->
			# form looks like inactive to prevent double-submission
			# @addOpacityWrapper() in @config.syncing
			
		syncStop: ->
			# @addOpacityWrapper(false) if @config.syncing


