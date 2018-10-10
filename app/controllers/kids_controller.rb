class KidsController < ApplicationController

	def create
	    @kid = Kid.new(kid_params)
	    @kid.save  
  	end


	private
	def kid_params
      params.require(:kid).permit(:name, :classroom_id, :parent_id)
    end

end