class FotosController < ApplicationController
	def destroy
			@foto = Foto.find(params[:id])
	    @foto.destroy
	    redirect_to root_path
  end

end