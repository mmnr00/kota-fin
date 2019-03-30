class ExpensesController < ApplicationController
	before_action :set_expense, only: [:destroy,:update,:edit]
	#protect_from_forgery except: [:search]

	

	#def index
		#@expenses = Expense.all
		
	#end

	
def new
	@expense = Expense.new
end



def my_expenses
	@taska = Taska.find(params[:id])
	@admin = current_admin
	@data = Hash.new
	@expense = Expense.new
	@expense.fotos.build
	mth = params[:expense][:month].to_i
	year = params[:expense][:year].to_i
	if params[:expense][:month].present?
		dt = Time.find_zone("Singapore").local(year,mth)
		psldt = dt - 1.months
		@taska_payslips = @taska.payslips.where(mth: psldt.month, year: psldt.year)
		@taska_chart = @taska.expenses.where(month: params[:expense][:month]).where(year: params[:expense][:year]) 
		@taska_expense = @taska.expenses.where(month: params[:expense][:month]).where(year: params[:expense][:year]).order('UPDATED_AT DESC')
		#TASKA BILLS START
			payment = @taska.payments.where.not(name: "TASKA PLAN")
			curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
			curr_pmt_paid = curr_pmt.where(paid: true)
			#CDTN_1 = current period pay early
			cdtn_1 = curr_pmt_paid.where("updated_at < ?", dt)
			#CDTN_2 = current period pay this month
			cdtn_2 = curr_pmt_paid.where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
			#CDTN_3 = previous period pay this month
			dt_lp = dt
			stp_lp = Time.find_zone("Singapore").local(2016,1)
			cdtn_3 = nil
			while dt_lp >= stp_lp
				if cdtn_3.blank?		
					cdtn_3 = payment.where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
				else
					tmp = payment.where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
					cdtn_3 = cdtn_3.or(tmp)
				end
				dt_lp = dt_lp - 1.months
			end
			@taska_payments = cdtn_1.or(cdtn_2.or(cdtn_3))
			#@taska_payments = @taska.payments.where.not(name: "TASKA PLAN").where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
			@payments_due = curr_pmt
			@payments_pie = curr_pmt.where(paid: false).or(@taska_payments.where(paid: true))
		#TASKA BILLS END
		@taska_plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(month from updated_at) = ?', mth).where('extract(year from updated_at) = ?', year)
	else #yearly report
		@taska_payslips = @taska.payslips.where(year: params[:expense][:year])
		@taska_chart = @taska.expenses.where(year: params[:expense][:year])
		@taska_expense = @taska.expenses.where(year: params[:expense][:year]).order('month ASC')
		#TASKA BILLS START
			#HASH FOR BILLS
			@bill_hash = Hash.new
			@taska_payments = nil
			(1..12).each do |mth|
				dt = Time.find_zone("Singapore").local(year,mth)
				payment = @taska.payments.where.not(name: "TASKA PLAN")
				curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
				curr_pmt_paid = curr_pmt.where(paid: true)
				#CDTN_1 = current period pay early
				cdtn_1 = curr_pmt_paid.where("updated_at < ?", dt)
				#CDTN_2 = current period pay this month
				cdtn_2 = curr_pmt_paid.where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
				#CDTN_3 = previous period pay this month
				dt_lp = dt
				stp_lp = Time.find_zone("Singapore").local(2016,1)
				cdtn_3 = nil
				while dt_lp >= stp_lp
					if cdtn_3.blank?		
						cdtn_3 = payment.where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
					else
						tmp = payment.where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
						cdtn_3 = cdtn_3.or(tmp)
					end
					dt_lp = dt_lp - 1.months
				end
				all_payments = cdtn_1.or(cdtn_2.or(cdtn_3))
				@bill_hash[mth]= all_payments.where(paid: true).sum(:amount)
				if @taska_payments.blank?
					@taska_payments = all_payments
				else
					@taska_payments = @taska_payments.or(all_payments)
				end
			end
			#@taska_payments = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: year)
			@payments_due = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: params[:expense][:year])
			@payments_pie = @payments_due.where(paid: false).or(@taska_payments.where(paid: true))
		#TASKA BILLS END
		@taska_plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(year from updated_at) = ?', params[:expense][:year])
	end
	render action: "my_expenses", layout: "dsb-admin-account" 
end

def create
	@expense = Expense.new(expense_params)
	#@expense.taska = session[:taska_id]
	if @expense.save			
		flash[:notice] = "Entry was successfully created for #{$month_name[@expense.month.to_i].upcase}-#{@expense.year}"					
											
	else
		flash[:danger] = "Entry creation failed. Please try again."	
	end
	redirect_to my_expenses_path(id: @expense.taska_id, expense:{month: @expense.month, year: @expense.year});
end


	

def month_expense
	@taska = Taska.find(params[:id])
	@month = params[:month]
	@month_name = $month_name[params[:month].to_i]
	@data = Hash.new
	@data["Profit"] = -@taska.expenses.where(month: params[:month]).where(year: params[:year]).sum("cost")+@taska.payments.where(paid: true).where(bill_month: params[:month]).where(bill_year: params[:year]).sum("amount")
	@data["Expense"] = -@taska.expenses.where(month: params[:month]).where(year: params[:year]).sum("cost")
	@data["Paid"] = @taska.payments.where(paid: true).where(bill_month: params[:month]).where(bill_year: params[:year]).sum("amount")
	@data["Due"] = @taska.payments.where(paid: false).where(bill_month: params[:month]).where(bill_year: params[:year]).sum("amount")

end

	def my_expenses_old

		if expense_year_min <= payment_year_min
			@raw_expense.each do |e|
				paid_similar = @taska.payments.where(paid: true).where(bill_month: e.month).where(bill_year: e.year)
				if paid_similar.present?
					paid_similar.each do |paid|
						if @data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]].present?
							@data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]] = @data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]]+paid.amount
						else
							@data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]] = paid.amount-e.cost
						end
					end
				else
				end
			end
		else
			@raw_paid.each do |paid|
				if @data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]].present?
					#@data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]] = @data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]]+paid.amount
				else
					#@data[["Profit","#{paid.bill_month}-#{paid.bill_year}"]] = paid.amount
				end
			end
		end

		@taska = Taska.find(params[:id])

		expense_year_max = @taska.expenses.maximum("year")
		payment_year_max = @taska.payments.maximum("bill_year")
		expense_year_min = @taska.expenses.minimum("year")
		payment_year_min = @taska.payments.minimum("bill_year")

		if expense_year_max >= payment_year_max
			@year_max = expense_year_max
		else
			@year_max = payment_year_max
		end

		if expense_year_min <= payment_year_min
			@year_min = expense_year_min
		else
			@year_min = payment_year_min
		end

		taska_expenses_raw = @taska.expenses
		@taska_expenses_order = taska_expenses_raw.order("year ASC").order("month ASC")

		taska_bills_paid_raw = @taska.payments.where(paid: true)
		@taska_bills_paid_order = taska_bills_paid_raw.order("bill_year ASC").order("bill_month ASC")

		taska_bills_due_raw = @taska.payments.where(paid: false)
		@taska_bills_due_order = taska_bills_due_raw.order("bill_year ASC").order("bill_month ASC")

	end

	def my_expenses_v1
	@taska = Taska.find(params[:id])
	@admin = current_admin
	@data = Hash.new
	@expense = Expense.new
	@expense.fotos.build
	mth = params[:expense][:month].to_i
	year = params[:expense][:year].to_i
	if params[:expense][:month].present?
		dt = Time.find_zone("Singapore").local(year,mth)
		psldt = dt - 1.months
		@taska_payslips = @taska.payslips.where(mth: psldt.month, year: psldt.year)
		@taska_chart = @taska.expenses.where(month: params[:expense][:month]).where(year: params[:expense][:year]) 
		@taska_expense = @taska.expenses.where(month: params[:expense][:month]).where(year: params[:expense][:year]).order('UPDATED_AT DESC')

		payment = @taska.payments.where.not(name: "TASKA PLAN")
		curr_pmt = payment.where(bill_month: mth).where(bill_year: year)

		@taska_payments = @taska.payments.where.not(name: "TASKA PLAN").where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
		@payments_due = curr_pmt
		@payments_pie = @payments_due.where(paid: false).or(@taska_payments.where(paid: true))

		@taska_plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(month from updated_at) = ?', mth).where('extract(year from updated_at) = ?', year)
	else
		@taska_payslips = @taska.payslips.where(year: params[:expense][:year])
		@taska_chart = @taska.expenses.where(year: params[:expense][:year])
		@taska_expense = @taska.expenses.where(year: params[:expense][:year]).order('month ASC')
		@taska_payments = @taska.payments.where.not(name: "TASKA PLAN").where('extract(year  from updated_at) = ?', year)
		@payments_due = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: params[:expense][:year])
		@payments_pie = @payments_due.where(paid: false).or(@taska_payments.where(paid: true))
		@taska_plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(year from updated_at) = ?', params[:expense][:year])
	end
	render action: "my_expenses", layout: "dsb-admin-account" 
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

	

	

	def edit
		@expense = Expense.find(params[:id])
		@taska = @expense.taska
		@admin = current_admin
		render action: "edit", layout: "dsb-admin-account" 
	end

	def show
	end 

	def update
		if @expense.update(expense_params)
			flash[:notice] = "Entry was successfully updated"
			redirect_to my_expenses_path(id: @expense.taska_id, expense:{month: @expense.month, year: @expense.year});
		else
			render 'edit'
		end
	end

	def destroy
		@expense.destroy
		flash[:notice] = "Expenses was successfully deleted"
		redirect_to my_expenses_path(id: @expense.taska_id, expense:{month: @expense.month, year: @expense.year});
	end

	def my_expenses_old

		@taska = Taska.find(params[:id])
		@admin = current_admin
		@data = Hash.new
		@expense = Expense.new


		expense_year_min = @taska.expenses.minimum("year")
		payment_year_min = @taska.payments.minimum("bill_year")
		paid_year_min = @taska.payments.where(paid: true).minimum("bill_year")
		expense_month_min = @taska.expenses.minimum("month")
		payment_month_min = @taska.payments.minimum("bill_month")
		paid_month_min = @taska.payments.where(paid: true).minimum("bill_month")

		if expense_year_min <= payment_year_min
			year = expense_year_min
			month = expense_month_min
		else
			year = payment_year_min
			month = payment_month_min
		end

		@data = {["Expense", "#{$month_name[month]}-#{year}"]=>0}

		@raw_expense = @taska.expenses.order("year ASC").order("month ASC")
		@raw_due = @taska.payments.where(paid: false).order("bill_year ASC").order("bill_month ASC")
		@raw_paid = @taska.payments.where(paid: true).order("bill_year ASC").order("bill_month ASC")
		@raw_paid.each do |paid|
			if @data[["Paid","#{$month_name[paid.bill_month]}-#{paid.bill_year}"]].present?
				@data[["Paid","#{$month_name[paid.bill_month]}-#{paid.bill_year}"]] = @data[["Paid","#{$month_name[paid.bill_month]}-#{paid.bill_year}"]]+paid.amount
			else
				@data[["Paid","#{$month_name[paid.bill_month]}-#{paid.bill_year}"]] = paid.amount
			end
		end

		@raw_due.each do |due|
			if @data[["Due","#{$month_name[due.bill_month]}-#{due.bill_year}"]].present?
				@data[["Due","#{$month_name[due.bill_month]}-#{due.bill_year}"]] = @data[["Due","#{$month_name[due.bill_month]}-#{due.bill_year}"]]+due.amount
			else
				@data[["Due","#{$month_name[due.bill_month]}-#{due.bill_year}"]] = due.amount
			end
		end

		@raw_expense.each do |e|
			if @data[["Expense","#{$month_name[e.month]}-#{e.year}"]].present?
				@data[["Expense","#{$month_name[e.month]}-#{e.year}"]] = @data[["Expense","#{$month_name[e.month]}-#{e.year}"]]-e.cost
			else
				@data[["Expense","#{$month_name[e.month]}-#{e.year}"]] = -e.cost
			end
		end

		expense_year_max = @taska.expenses.maximum("year")
		paid_year_max = @taska.payments.where(paid: true).maximum("bill_year")

		if expense_year_max >= paid_year_max
			year_max = expense_year_max
			year_min = paid_year_max
		else
			year_max = paid_year_max
			year_min = expense_year_max
		end

		@year_max_view = [@taska.expenses.maximum("year"),@taska.payments.where(paid: true).maximum("bill_year"),@taska.payments.where(paid: false).maximum("bill_year")].max
		@year_min_view = [@taska.expenses.minimum("year"),@taska.payments.where(paid: true).minimum("bill_year"),@taska.payments.where(paid: false).minimum("bill_year")].min

		(@year_min_view..@year_max_view).each do |yr|
			(1..12).each do |mon|
				if @data[["Expense","#{$month_name[mon]}-#{yr}"]].present? && @data[["Paid","#{$month_name[mon]}-#{yr}"]].present?
					@data[["Profit","#{$month_name[mon]}-#{yr}"]] = @data[["Paid","#{$month_name[mon]}-#{yr}"]] + @data[["Expense","#{$month_name[mon]}-#{yr}"]]
				elsif !@data[["Expense","#{$month_name[mon]}-#{yr}"]].present? && @data[["Paid","#{$month_name[mon]}-#{yr}"]].present?
					@data[["Profit","#{$month_name[mon]}-#{yr}"]] = @data[["Paid","#{$month_name[mon]}-#{yr}"]]
				elsif @data[["Expense","#{$month_name[mon]}-#{yr}"]].present? && !@data[["Paid","#{$month_name[mon]}-#{yr}"]].present?
					@data[["Profit","#{$month_name[mon]}-#{yr}"]] = @data[["Expense","#{$month_name[mon]}-#{yr}"]]
				end	
			end
		end

		
		render action: "my_expenses", layout: "dsb-admin-account" 

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
																			fotos_attributes: [:foto, :picture, :foto_name])
	end
	def redirect_ori
		redirect_to my_expenses_path("utf8"=>"✓", month:@expense.month, year:@expense.year, id:@expense.taska_id, "button"=>""), :method => :get
	end



end











