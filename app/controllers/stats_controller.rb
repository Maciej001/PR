class StatsController < ActionController::Base
	respond_to :json

	def new
		respond_with Stat.new
	end

	def show
		respond_with Stat.find params[:id]
	end

	def index
		respond_with Stat.all
	end

	def update
		@stat = Stat.find params[:id]
		if @stat.update stat_params
			respond_with @stat
		end
	end

	def create
		respond_with( Stat.create stat_params )
	end

	private

		def stat_params
			params.require(:stat).permit(:total_contracts_traded, :number_of_trades, :open, :high, :low, :last)
		end

end
