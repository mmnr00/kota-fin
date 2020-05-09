class ExpensesController < ApplicationController
	before_action :set_expense, only: [:destroy,:update,:edit]

	
def new
	@taska = Taska.find(params[:community_id])
	@admin = current_admin
	@expense = Expense.new
	render action: "new", layout: "admin_db/admin_db-financial" 
end

def create
	@expense = Expense.new(expense_params)
	@taska = @expense.taska
	@expense.month = @expense.dt.month
	@expense.year = @expense.dt.year
	if @expense.save			
		flash[:notice] = "New Entry Successfully Created"					
		redirect_to tsk_financial_path(id: @taska.id, sch_mth: @expense.month, sch_yr: @expense.year)							
	else
		flash[:danger] = "New Entry creation failed. Please try again."	
	end
	
end

def edit
	@expense = Expense.find(params[:id])
	@taska = @expense.taska
	@admin = current_admin
	render action: "edit", layout: "admin_db/admin_db-financial" 
end

def update
	if @expense.update(expense_params)
		@taska = @expense.taska
		@expense.month = @expense.dt.month
		@expense.year = @expense.dt.year
		@expense.save
		flash[:notice] = "Entry successfully updated"
		redirect_to tsk_financial_path(@taska, sch_mth: @expense.month, sch_yr: @expense.year);
	else
		render 'edit'
	end
end

def destroy
		@expense.destroy
		flash[:notice] = "Expenses was successfully deleted"
		redirect_to my_expenses_path(id: @expense.taska_id, expense:{month: @expense.month, year: @expense.year});
end


	

	

	private

	def set_expense
			@expense = Expense.find(params[:id])
	end
	def expense_params
			params.require(:expense).permit(:name, 
																			:cost, 
																			:month, 
																			:year, 
																			:taska_id, 
																			:kind,
																			:dt,
																			:coname,
																			:catg,
																			fotos_attributes: [:foto, :picture, :foto_name])
	end
	def redirect_ori
		redirect_to my_expenses_path("utf8"=>"✓", month:@expense.month, year:@expense.year, id:@expense.taska_id, "button"=>""), :method => :get
	end



end











