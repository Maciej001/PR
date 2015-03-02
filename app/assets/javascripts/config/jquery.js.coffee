do ($) ->
	# object passed here is the View (in our case formWrapper)
	$.fn.toggleWrapper = (obj={}, init = true) ->
		_.defaults obj,
			className: ""
			# backgroundColor: if @css("backgroundColor") isnt "transparent" then @css("backgroundColor") else "white"
			backgroundColor: "white"
			zIndex: if @css("zIndex") is "auto" or 0 then 1000 else (Number) @css("zIndex")

		$offset = @offset()
		$width	= @outerWidth(false)	# false - don't include margin, but include padding and border
		$height = @outerHeight(false)

		if init
			$("<div>")
				.appendTo("body")
				.addClass(obj.className)
				.attr("data-wrapper",true)
				.css
					width: 						$width
					height: 					$height
					top: 							$offset.top
					left: 						$offset.left
					position:					"absolute"
					zIndex:						obj.zIndex + 1
					backgroundColor: 	obj.backgroundColor
		else
			$("[data-wrapper]").remove()





			