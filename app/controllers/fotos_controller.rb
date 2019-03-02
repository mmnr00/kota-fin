class FotosController < ApplicationController
	before_action :set_foto
	before_action :set_all

	def edit
	end

	def update
		@tchdetail = @foto.tchdetail
		if @foto.update(foto_params)
			if @teacher 
        redirect_to edit_tchdetail_path(@tchdetail, teacher_id: @teacher.id)
      elsif @parent
      	@kid = @foto.kid
      	redirect_to edit_kid_path(@kid)
      elsif @tchdetail.present? && @tchdetail.anis == "true"
        redirect_to edit_tchdetail_path(@tchdetail)
      elsif @admin
        if @foto.taska.present?
        	@taska = @foto.taska
        	redirect_to edit_taska_path(@taska)
        elsif @foto.expense.present?
          @expense = @foto.expense
          redirect_to edit_expense_path(@expense)
        elsif @foto.kid.present?
          @kid = @foto.kid
          redirect_to edit_kid_path(@kid)
        elsif @foto.ptns_mmb.present?
          @ptns_mmb = @foto.ptns_mmb
          redirect_to edit_ptns_mmb_path(@ptns_mmb)
        end
      end
    else
      render :edit
    end
	end

	def destroy
			@tchdetail = @foto.tchdetail
	    @foto.destroy
	    redirect_to edit_tchdetail_path(@tchdetail)
  end

  private

  def set_foto
			@foto = Foto.find(params[:id])
  end

  def set_all
		@teacher = current_teacher
		@parent = current_parent
		@admin = current_admin	
		@owner = current_owner
  end

  def foto_params
      params.require(:foto).permit(:foto_name, :picture)
  end

end