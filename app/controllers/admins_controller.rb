class AdminsController < ApplicationController
	before_action :authenticate_admin!

	def index
		@admin = current_admin
		@spv = @admin.spv
		if Rails.env.production?
			@admin_taska = current_admin.taskas.where.not(id: [5, 9, 1, 44, 45, 4, 48, 75])
		else
			@admin_taska = current_admin.taskas
		end
		
		#START FOR OVERALL DASHBOARD
		if params[:ovrl].present?

		#ALL Calculated Variables
		@actv = 0
		@kcr_inc = 0.00
		@kid_new = 0
		@kid_tot = 0
		@unpaid_no = 0
		@unpaid_amt = 0.00
		@pnl = 0.00
		@applvs = 0

		#Global Var
		time = Time.now.in_time_zone('Singapore')
	  @mth = time.month
	  @yr = time.year 
	  dt = Time.find_zone("Singapore").local(@yr,@mth)

		@admin_taska.each do |tsk|
			#@taska_id = tsk.id
			#@taska_name = tsk.name

			if ((tsk.expire.to_date - Date.today).to_i > -15)
				@actv += 1 

				#no of kids
				@kid_new += tsk.kids.where(classroom_id: nil).count
				@kid_tot += tsk.kids.where.not(classroom_id: nil).count

				#count income kidcare
				if current_admin == Admin.first
					if tsk.plan == "PAY PER USE"
	          @kcr_inc += tsk.kids.where.not(classroom_id: nil).count * $package_price[tsk.plan] * tsk.discount
	        else
	          @kcr_inc += $package_price[tsk.plan] * tsk.discount
	        end
				end

				#leaves
				@applvs += tsk.applvs.where.not(stat: "APPROVED").where.not(stat: "REJECTED").count

				#bills
				unpaid_bill = tsk.payments.where.not(name: "TASKA PLAN").where(paid: false)
				@unpaid_no += unpaid_bill.count
				unpaid_bill.each do |pmt|
					@unpaid_amt += pmt.amount
					@unpaid_amt -= pmt.parpayms.sum(:amt)
				end

				#account
				plan = tsk.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(year  from updated_at) = ?', @yr).where('extract(month  from updated_at) = ?', @mth).sum(:amount)
				#~bills
					payment = tsk.payments.where.not(name: "TASKA PLAN")
			    curr_pmt = payment.where(bill_month: @mth).where(bill_year: @yr)
			    curr_pmt_paid = curr_pmt.where(paid: true)
			    curr_pmt_unpaid = curr_pmt.where(paid: false)
			    #CDTN_1 = current period pay early
			    cdtn_1 = curr_pmt_paid.where("updated_at < ?", dt)

			    #CDTN_2 = current period pay this month
			    cdtn_2 = curr_pmt_paid.where('extract(year  from updated_at) = ?', @yr).where('extract(month  from updated_at) = ?', @mth)
			    #CDTN_3 = previous period pay this month
			    dt_lp = dt
			    stp_lp = Time.find_zone("Singapore").local(2016,1)
			    cdtn_3 = nil
			    while dt_lp >= stp_lp
			      if cdtn_3.blank?    
			        cdtn_3 = payment.where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', @yr).where('extract(month  from updated_at) = ?', @mth)
			      else
			        tmp = payment.where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', @yr).where('extract(month  from updated_at) = ?', @mth)
			        cdtn_3 = cdtn_3.or(tmp)
			      end
			      dt_lp = dt_lp - 1.months
			    end
			    taska_payments = cdtn_1.or(cdtn_2.or(cdtn_3))

			    bills_paid = taska_payments.where(paid: true).sum(:amount)
			    #start for partial
			    #CDTN_1 All partials paid this month or previous month for current month bill
			    cdtn_1par = 0.00
			    curr_pmt_unpaid.each do |pmt|
			      if pmt.parpayms.present?
			        cdtn_1par += pmt.parpayms.where("upd < ?", dt).sum(:amt) 
			        cdtn_1par += pmt.parpayms.where('extract(year  from upd) = ?', @yr).where('extract(month  from upd) = ?', @mth).sum(:amt) 
			      end
			    end
			    #CDTN_2 previous months bills paid partially this month
			    cdtn_2par = 0.00
			    dt_lp=dt-1.months
			    while dt_lp >= stp_lp
			      payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
			        cdtn_2par += pmt.parpayms.where('extract(year  from upd) = ?', @yr).where('extract(month  from upd) = ?', @mth).sum(:amt)
			      end
			    dt_lp -= 1.months
			    end
			    bills_partial = cdtn_1par + cdtn_2par
			    #END PARTIAL


				#~payslips
				psldt = time - tsk.pslm.months
				payslips = tsk.payslips.where(mth: psldt.month, year: psldt.year)
				#~expense
				tsk_expense = tsk.expenses.where(month: @mth).where(year: @yr).order('CREATED_AT DESC')

				@pnl +=  -plan + tsk_expense.where(kind: "INCOME").sum(:cost) - tsk_expense.where(kind: "EXPENSE").sum(:cost) + bills_paid+bills_partial-payslips.sum(:amtepfa)

			  


			end

		end

		#END FOR OVERALL DASHBOARD
		end
		#if @admin_taska.count == 1 ; redirect_to taska_path(@taska_id) end

	end

	def index_old
		@admin = current_admin
		@admin_taska = current_admin.taskas
		@admin_taska.each do |taska|
			@taska_id = taska.id
			@taska_name = taska.name
		end
		#if @admin_taska.count == 1 ; redirect_to taska_path(@taska_id) end
		#render action: "index", layout: "dsb-admin-overview"

	end

	def webarch
	end

	def webarchv2
	end

	
end