class PortfoliosController < ActionController::Base
	respond_to :json

	def new
		respond_with Portfolio.new
	end

	def index
		respond_with Portfolio.all
	end

	def show
		respond_with Portfolio.find params[:id]
	end

	def update
		@portfolio = Portfolio.find params[:id]
		if @portfolio.update portfolio_params
			respond_with @portfolio
		end
	end

	def create
		respond_with( Portfolio.create portfolio_params )
	end

	def destroy
		respond_with( Portfolio.destroy params[:id] )
	end

	private

		def portfolio_params
			params.require(:portfolio).permit(:user_id, :cash, :open_position)
		end

end

