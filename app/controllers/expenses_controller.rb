class ExpensesController < ApplicationController
	before_action :set_expense, only: [:destroy,:update,:edit]
	protect_from_forgery except: [:search]

	

	#def index
		#@expenses = Expense.all
		
	#end

	
	def new
		@expense = Expense.new
	end

	def my_expenses


	end

	def search

		if params[:month].blank? || params[:year].blank? 
			flash.now[:danger] = "You have entered an empty request"
		else
			session[:month] = params[:month]
			session[:year] = params[:year]
			@expenses_search = Expense.search(params[:month], params[:year], params[:taska_id])
			@expenses_search = @expenses_search.order('updated_at DESC')
			flash.now[:danger] = "You have entered an invalid stock" unless @expenses_search
		end
		respond_to do |format|
			format.js { render partial: 'expenses/result' } 
		end		
		
	end

	

	def create

		@expense = Expense.new(expense_params)
		#@expense.taska = session[:taska_id]
		if @expense.save			
			flash[:notice] = "Expense was successfully created"					
			redirect_ori();									
		else
			render :new
		end
	end

	def edit
	end

	def show
	end 

	def update
		if @expense.update(expense_params)
			flash[:notice] = "Article was successfully updated"
			redirect_ori();
		else
			render 'edit'
		end
	end

	def destroy
		@expense.destroy
		flash[:notice] = "Expenses was successfully deleted"
		redirect_ori();
	end

	

	private

	def set_expense
			@expense = Expense.find(params[:id])
	end
	def expense_params
			params.require(:expense).permit(:name, :cost, :month, :year, :taska_id)
	end
	def redirect_ori
		redirect_to my_expenses_path("utf8"=>"✓", month:@expense.month, year:@expense.year, id:@expense.taska_id, "button"=>""), :method => :get
	end



end











