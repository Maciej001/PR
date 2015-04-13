New order form submit:

Check when submitting the form: 

1. trading_with_myself? -> yes -> error message, form doesnt get submitted
										 -> no  -> proceed 

2. Either regular order or execute trade - at this point order gets saved to DB

	a) regular order 
	 		- add to @all_orders
	 		- add to @my_orders
	 		- add to @offers or @bids

	b) execute trade

Trade execution: 

updates: 
	at the end change trade state to 'executed'
	all_orders, my_orders - dont add

while new_trade.size_left > 0 
		
		if next offer exists take the offer

			if new_trade_size > offer 
					generate 2 trades with size = offer.size_left
					new_trade.size_left = new_trade.size_left - offer.size_left
					offer.size_left = 0

			else if new_trade_size = offer
					generate 2 trades with size = offer.size_left for buyer and seller
					offer.size_left = 0
				 	new_trade.size_left = 0

			else new_trade_size < offer 
					generate 2 trades with size = new_trade.size_left
					offer.size_left = offer.size_left - new_trade.size_left
					new_trade.size_left = 0

			if offer.size_left = 0 
					offer.state = 'executed'
					remove offer from offers collection

			if new_trade ramining_size = 0
					new_trade.state = 'executed'
					remove new_trade from my_orders

		else

				place new_trade remaining_size as new order

