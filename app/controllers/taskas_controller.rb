class TaskasController < ApplicationController
  
  require 'json'
  before_action :set_taska, except: [:upd_ajk,:upd_bilitm,:new,:create]
  before_action :set_all
  before_action :check_admin, only: [:show]
  before_action :authenticate_admin!, only: [:new]

  def remd_bill
    arr_em = []
    arr_not_em =[]
    arr_ph = []
    arr_not_ph = []

    Classroom.find(params[:cls]).each do |cls|
      if cls.topay == "OWNER"
        ph = cls.own_ph
        em = cls.own_email
        nm = cls.own_name
      else
        ph = cls.tn_ph
        em = cls.tn_email
        nm = cls.tn_name
      end

      #send sms
      if ph.present?
        url = "https://sms.360.my/gw/bulk360/v1.4?"
        usr = "user=admin@kidcare.my&"
        ps = "pass=#{ENV['SMS360']}&"
        to = "to=6#{ph}&"
        txt = "text=Bill Reminder fr #{@taska.name}.\n Click https://www.kota.my/list_bill?cls=#{cls.unq} to pay. TAMAN KITA TANGGUNGJAWAB BERSAMA."

        fixie = URI.parse "http://fixie:2lSaDRfniJz8lOS@velodrome.usefixie.com:80"
        data_sms = HTTParty.get(
        "#{url}#{usr}#{ps}#{to}#{txt}",
        http_proxyaddr: fixie.host,
        http_proxyport: fixie.port,
        http_proxyuser: fixie.user,
        http_proxypass: fixie.password
        )
        arr_ph << ["#{cls.description} #{cls.classroom_name}",ph] unless data_sms.parsed_response[0..2] != "200"
        arr_not_ph << ["#{cls.description} #{cls.classroom_name}",ph,data_sms.parsed_response[0..2]] unless data_sms.parsed_response[0..2] == "200"
      end

      #send email
      if em.present?
        
        #add content
        msg = "<html>
        <body>
        Dear Mr/Mrs <strong>#{nm}</strong><br><br>


        Bill reminder from <strong>#{@taska.name}</strong>. <br><br>

        Please click <a href=https://www.kota.my/list_bill?cls=#{cls.unq}>HERE</a> to view and make payment. <br><br>

        <strong>Taman Kita Tanggungjawab Bersama</strong>.<br><br>

        Powered by <strong>www.kota.my</strong>
        </body>
        </html>"
        #sending email
        mail = SendGrid::Mail.new
        mail.from = SendGrid::Email.new(email: 'billing@kota.my', name: "#{@taska.name}")
        mail.subject = "BILL REMINDER FOR: NO #{cls.description} #{cls.classroom_name}"
        personalization = SendGrid::Personalization.new
        personalization.add_to(SendGrid::Email.new(email: "#{em}"))
        mail.add_personalization(personalization)
        mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
        # @response = sg.client.mail._('send').post(request_body: mail.to_json)
        # arr_em << ["#{cls.description} #{cls.classroom_name}",em] unless @response.status_code != "202"
        # arr_not_em << ["#{cls.description} #{cls.classroom_name}",em,@response.status_code] unless @response.status_code == "202"
      end

    end

    flash[:notice] = "Reminders Successfully Sent To #{params[:cls].count} residents"
    #redirect_to tsk_fee_path(params[:id], sch_mth: params[:sch_mth], sch_yr: params[:sch_yr])
  end

  def upld_res
    xlsx = Roo::Spreadsheet.open(params[:file])
    header = xlsx.row(xlsx.first_row+2)
    tskcls = @taska.classrooms
    ((xlsx.first_row+4)..(xlsx.last_row)).each do |n|
      
      xlsx.row(n)
      row = Hash[[header, xlsx.row(n)].transpose]
      if row["BLOCK/ROAD"].present? && row["HOUSE NO"].present?

        own_name = " "
        own_dob = " "
        own_ph = " "
        own_email = " "
        tn_name = " "
        tn_dob = " "
        tn_ph = " "
        tn_email = " "

        hs_no = row["HOUSE NO"].to_s
        own_name = row["OWNER NAME"] unless row["OWNER NAME"].blank?
        own_ph = row["OWNER MOBILE PHONE"] unless row["OWNER MOBILE PHONE"].blank?
        own_email = row["OWNER EMAIL"] unless row["OWNER EMAIL"].blank?
        tn_name = row["TENANT NAME"] unless row["TENANT NAME"].blank?
        tn_ph = row["TENANT MOBILE PHONE"] unless row["TENANT MOBILE PHONE"].blank?
        tn_email = row["TENANT EMAIL"] unless row["TENANT EMAIL"].blank?


        #check existing
        if (cls=tskcls.where(classroom_name: row["BLOCK/ROAD"].upcase,description: hs_no.upcase)).present?
          clsr = cls.first
          clsr.update(topay: row["SEND BILL TO"],
                            taska_id: @taska.id,
                            own_name: own_name.upcase,
                            own_dob: own_dob,
                            own_ph: own_ph,
                            own_email: own_email.upcase,
                            tn_name: tn_name.upcase,
                            tn_dob: tn_dob,
                            tn_ph: tn_ph,
                            tn_email: tn_email.upcase)
          

        else
          clsr = Classroom.new(classroom_name: row["BLOCK/ROAD"].upcase,
                                  description: hs_no.upcase,
                                  topay: row["SEND BILL TO"],
                                  taska_id: @taska.id,
                                  own_name: own_name.upcase,
                                  own_dob: own_dob,
                                  own_ph: own_ph,
                                  own_email: own_email.upcase,
                                  tn_name: tn_name.upcase,
                                  tn_dob: tn_dob,
                                  tn_ph: tn_ph,
                                  tn_email: tn_email.upcase)

          unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
          while Classroom.where(unq: unq).present? #arr.include? unq 
            unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
          end
          clsr.unq = unq
          
          clsr.save
          Foto.create(foto_name:"Owner Pic",classroom_id: clsr.id)
          Foto.create(foto_name:"Tenant Pic",classroom_id: clsr.id)
        end #end create 

      end #if hse no and this is present

    end #end all rows
    flash[:success] = "FILE UPLOADED"
    redirect_to taskashow_path(@taska)
  end



  def upld_res_old
    xlsx = Roo::Spreadsheet.open(params[:file])
    header = xlsx.row(xlsx.first_row+2)
    tskcls = @taska.classrooms
    ((xlsx.first_row+4)..(xlsx.last_row)).each do |n|
      
      xlsx.row(n)
      row = Hash[[header, xlsx.row(n)].transpose]
      if row["BLOCK/ROAD"].present? && row["UNIT NO"].present?

        own_name = ""
        own_dob = ""
        own_ph = ""
        own_email = ""
        tn_name = ""
        tn_dob = ""
        tn_ph = ""
        tn_email = ""

        #owner details
        if row["OWNER DETAILS"].present?
          own_dtl=row["OWNER DETAILS"].gsub("\n","").split(";")
          own_name = own_dtl[0]
          own_dob = own_dtl[1].to_date
          own_ph = own_dtl[2]
          own_email = own_dtl[3]
        end

        #tenant details
        if row["TENANT DETAILS"].present?
          tn_dtl=row["TENANT DETAILS"].gsub("\n","").split(";")
          tn_name = tn_dtl[0]
          tn_dob = tn_dtl[1].to_date
          tn_ph = tn_dtl[2]
          tn_email = tn_dtl[3]
        end


        #check existing
        if (cls=tskcls.where(classroom_name: row["BLOCK/ROAD"].upcase,description: row["UNIT NO"].upcase)).present?
          clsr = cls.first
          clsr.update(topay: row["BILL TO"],
                            taska_id: @taska.id,
                            own_name: own_name.upcase,
                            own_dob: own_dob,
                            own_ph: own_ph,
                            own_email: own_email.upcase,
                            tn_name: tn_name.upcase,
                            tn_dob: tn_dob,
                            tn_ph: tn_ph,
                            tn_email: tn_email.upcase)
          

        else
          clsr = Classroom.new(classroom_name: row["BLOCK/ROAD"].upcase,
                                  description: row["UNIT NO"].upcase,
                                  topay: row["BILL TO"],
                                  taska_id: @taska.id,
                                  own_name: own_name.upcase,
                                  own_dob: own_dob,
                                  own_ph: own_ph,
                                  own_email: own_email.upcase,
                                  tn_name: tn_name.upcase,
                                  tn_dob: tn_dob,
                                  tn_ph: tn_ph,
                                  tn_email: tn_email.upcase)

          unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
          while Classroom.where(unq: unq).present? #arr.include? unq 
            unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
          end
          clsr.unq = unq
          
          clsr.save
          Foto.create(foto_name:"Owner Pic",classroom_id: clsr.id)
          Foto.create(foto_name:"Tenant Pic",classroom_id: clsr.id)
        end

        #create vehicle
        if row["VEHICLES LIST"].present?
          vhcl=row["VEHICLES LIST"].gsub("\n","").split(";")
          vhcl.each do |iv|
            puts iv
            ivn = iv.split(",")
            cls_vhcl = clsr.vhcls.where(plt: ivn[0]).first
            if cls_vhcl.present?
              cls_vhcl.update(plt: ivn[0],
                        brnd: ivn[1],
                        typ: ivn[2],
                        classroom_id: clsr.id)
            else
              Vhcl.create(plt: ivn[0],
                        brnd: ivn[1],
                        typ: ivn[2],
                        classroom_id: clsr.id)
            end

          end
        end

        #puts "#{vhcl}"
        #puts vhcl.class
        

      end

    end
    flash[:success] = "FILE UPLOADED"
    redirect_to taskashow_path(@taska)
  end

  def upd_bilitm
    pars = params[:cls]
    @taska = Taska.find(pars[:id])
    @taska.bilitm.clear
    pars.each do |k,v|
      if k != "id"
        if v[:itm].present? && v[:amt].present?
          @taska.bilitm[v[:itm]]=v[:amt].to_f
        end
      end
    end
    @taska.save
    flash[:success] = "Bill Items Updated"
    redirect_to shw_bilitm_path(id: @taska.id)
  end

  def shw_bilitm
    render action: "shw_bilitm", layout: "admin_db/admin_db-fee" 
  end


  def edit
    @fotos = @taska.fotos
    render action: "edit", layout: "admin_db/admin_db-resident" 
  end

  def update
    if @taska.update(taska_params)
      flash[:success] = "#{@taska.name} was successfully updated"
      #if @taska.bank_status == nil 
        #redirect_to create_billplz_bank_path(id: @taska.id)
      #else
        redirect_to taskashow_path(@taska)
      #end
      #format.html { redirect_to @taska, notice: 'Taska was successfully updated.' }
      #format.json { render :show, status: :ok, location: @taska }
    else
      flash[:success] = "Update unsuccessfull. Please try again"
      format.html { render :edit }
      #format.json { render json: @taska.errors, status: :unprocessable_entity }
    end
  end


  def show
    sch = params[:sch_fld]
    str = params[:sch_str]
    @all_ajk = @taska.extras
    @ajks = @taska.extras.where(classroom_id: nil)

    @clsrs = @taska.classrooms

    #create array road name
    @rd_names = []
    @clsrs.order('classroom_name ASC').each do |cls|
      @rd_names << cls.classroom_name unless @rd_names.include? cls.classroom_name
    end

    if str.present?
      str = str.upcase
    end
    if sch.present? || params[:sch].present?
      @units = @taska.classrooms

      if sch == "Block/Road"
        @units= @taska.classrooms.where('classroom_name LIKE ?', "%#{str}%")
        #flash[:notice] = "#{@units.count} results found"
      elsif sch == "Unit No"
        @units= @taska.classrooms.where(description: str)
      elsif sch == "Name"
        cls = @taska.classrooms
        @units = cls.where('own_name LIKE ?', "%#{str}%").or(cls.where('tn_name LIKE ?', "%#{str}%"))
      elsif sch == "DOB (DD/MM/YYYY)"
        date = Date.new(str[6..9].to_i,str[3..4].to_i,str[0..1].to_i)
        if date.blank?
          return
        end
        @units= @taska.classrooms.where(id: 6)
      elsif sch == "Phone No"
        cls = @taska.classrooms
        @units = cls.where('own_ph LIKE ?', "%#{str}%").or(cls.where('tn_ph LIKE ?', "%#{str}%"))
      elsif sch == "Email"
        cls = @taska.classrooms
        @units = cls.where('own_email LIKE ?', "%#{str}%").or(cls.where('tn_email LIKE ?', "%#{str}%"))
      elsif sch == "Plate No"
        cls = @taska.classrooms
        vhall=nil
        cls.each do |cl|
          if vhall.blank?
            vhall = Vhcl.where(classroom_id: cl.id)
          else
            vhall = vhall.or(Vhcl.where(classroom_id: cl.id))
          end
        end
        finvhc = vhall.where('plt LIKE ?', "%#{str}%")
        @units = cls.where(id: nil)
        finvhc.each do |vh|
          @units = @units.or(cls.where(id: vh.classroom_id))
        end
      end
      if params[:blk].present?
        @units= @units.where(classroom_name: params[:blk])
      end
    else
      if params[:all].present?
        @units = @taska.classrooms
      else
        @units = @taska.classrooms.where(id: nil)
      end
    end
    @units = @units.order('classroom_name ASC').order('description ASC')
    render action: "show", layout: "admin_db/admin_db-resident" 
  end

  def tsk_ajk
    @ajks = @taska.extras.order('created_at ASC')
    if @admin
      render action: "tsk_ajk", layout: "admin_db/admin_db-ajk" 
    end
  end

  def crt_ajk
    Extra.create(name: "TYPE HERE", taska_id: @taska.id)
    redirect_to tsk_ajk_path(id: @taska.id)
  end

  def dlt_ajk
    @extra = Extra.find(params[:ajk])
    @extra.destroy
    redirect_to tsk_ajk_path(id: @taska.id)
  end

  def upd_ajk
    pars = params[:ajk]
    pars.each do |k,v|
      if k != "id"
        @extra = Extra.find(k)
        @extra.name = v[:name].upcase
        @extra.save
      end
    end
    flash[:success] = "AJK List Updated"
    redirect_to tsk_ajk_path(id: params[:ajk][:id])
  end

  def tsk_fee
    @payments = @taska.payments.where(name: "RSD M BILL")
    @clsrs = @taska.classrooms

    #create array road name
    @rd_names = []
    @clsrs.order('classroom_name ASC').each do |cls|
      @rd_names << cls.classroom_name unless @rd_names.include? cls.classroom_name
    end

    if 1==1  ##params[:sch].present?
      str = params[:sch_str]

      #search year
      if params[:sch_yr].present?
        @payments = @payments.where(bill_year: params[:sch_yr].to_i)
      end

      #search month
      if params[:sch_mth].present?
        @payments = @payments.where(bill_month: params[:sch_mth].to_i)
      end

      #search status
      if params[:sch_stt] == "PAID"
        @payments = @payments.where(paid: true)
      elsif params[:sch_stt] == "UNPAID"
        @payments = @payments.where(paid: false)
      end

      kb = KidBill.where(payment_id: @payments.ids)
      arr = []

      if params[:sch_rd].present?
        cls_rd = @clsrs.where(classroom_name: params[:sch_rd])
        @payments = @payments.where(classroom_id: cls_rd.ids) unless cls_rd.blank?
      end


      if params[:sch_fld] == "Month" 
        @payments = @payments.where(bill_month: params[:sch_str])

      elsif params[:sch_fld] == "Unit No" || params[:sch_fld] == "Block/Road"
        # kb = kb.where('clsname LIKE ?', "%#{str.upcase}%")
        # kb.each do |k|
        #   arr<<k.payment_id
        # end
        # @payments = @payments.where(id: arr)
        cls_unt = @clsrs.where(description: str)
        @payments = @payments.where(classroom_id: cls_unt.ids) unless cls_unt.blank?

      elsif params[:sch_fld] == "Phone No" || params[:sch_fld] == "Name" || params[:sch_fld] == "Email"
        kb.each do |k|
         arr<<k.payment_id unless !k.extra.any? {|s| s.include? str.upcase}
        end
        @payments = @payments.where(id: arr)

      elsif params[:sch_fld] == "Bill ID"
        @payments = @payments.where('bill_id LIKE ?', "%#{str}%")
      end

    end

    #calculate report
    @amt = 0.00
    @bill_paid = 0
    @payments.each do |pmt|
      if pmt.paid
        @amt = @amt + pmt.amount
        if pmt.mtd.include? "BILLPLZ"
          @amt = @amt - 1.5
        end 
        @bill_paid += 1
      end
    end

    render action: "tsk_fee", layout: "admin_db/admin_db-fee" 
  end

  def tsk_vismgmt
    render action: "tsk_vismgmt", layout: "admin_db/admin_db-vismgmt" 
  end

  def tsk_activt
    render action: "tsk_activt", layout: "admin_db/admin_db-activity" 
  end

  def tsk_newblast
    render action: "tsk_newblast", layout: "admin_db/admin_db-news" 
  end

  def tsk_financial

    yr = params[:sch_yr].to_i

    if params[:sch_mth].blank? #whole year
      @fin_arr = []
      

      (1..12).each do |n|
        financial_summ(n,yr)

        if @bills_ovr.blank?
          @bills_ovr = @ori_bills
        else
          @bills_ovr = @bills_ovr.or(@ori_bills)
        end

        if @exps_ovr.blank?
          @exps_ovr = @exps
        else
          @exps_ovr = @exps_ovr.or(@exps)
        end
        
        bilpz = @bil_plz.sum(:amount) - (@bil_plz.count*1.5)
        #new calculation method
        # bilplz_curr = 0.00
        # bilnorm_curr = 0.00
        # bilplz_ovr_curr = 0.00

        bilplz_curr = @ori_bills.where('mtd LIKE ?', "%BILLPLZ%")
        bilnorm_curr = @ori_bills.where.not('mtd LIKE ?', "%BILLPLZ%")
        bilplz_ovr_curr = bilplz_curr.sum(:amount) - (bilplz_curr.count*1.5)
        
        @fin_arr << [n,yr,
                    bilplz_ovr_curr + bilnorm_curr.sum(:amount),
                    @exps.where(kind: "INCOME").sum(:cost),
                    @exps.where(kind: "EXPENSE").sum(:cost),
                    bilpz + @bil_norm.sum(:amount)]
      end

    elsif params[:sch_mth].present? # month only
      financial_summ(params[:sch_mth],yr)
    end

    render action: "tsk_financial", layout: "admin_db/admin_db-financial" 
  end


 

  private
    
    def financial_summ(mth,yr)
      @exps = @taska.expenses.where(month: mth, year: yr)
      @ori_bills = @taska.payments.where(name: "RSD M BILL", bill_year: yr,bill_month: mth)
      bills = @taska.payments.where(name: "RSD M BILL",paid: true).where('extract(year  from pdt) = ?', yr).where('extract(month  from pdt) = ?', mth)
      @bil_plz = bills.where('mtd LIKE ?', "%BILLPLZ%")
      @bil_norm = bills.where.not('mtd LIKE ?', "%BILLPLZ%")
      #return arr
    end

    def updtskplan
      @taska = Taska.find(params[:id])
      tskpln = @taska.payments.where(name: "TASKA PLAN", paid: false)

      if tskpln.present?
        tskpln.each do |pb|
          url_bill = "#{ENV['BILLPLZ_API']}bills/#{pb.bill_id}"
          data_billplz = HTTParty.get(url_bill.to_str,
                  :body  => {}.to_json, 
                              #:callback_url=>  "YOUR RETURN URL"}.to_json,
                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
          #render json: data_billplz and return
          data = JSON.parse(data_billplz.to_s)
          if data["paid"] == true
            pb.paid = true
            pb.updated_at = data["paid_at"]
            pb.save
            if (expire = @taska.expire) >= pb.updated_at
              @taska.expire = expire + 1.months
            else
              @taska.expire = pb.updated_at + 1.months
            end
            @taska.save
          elsif data["paid"] == false
            #delete dekat billplz
            pb.destroy
          end
        end
      end

    end

    def set_taska
      @taska = Taska.find(params[:id])
    end

    def set_all
      @teacher = current_teacher
      @parent = current_parent
      @admin = current_admin  
      if @admin.present?
        @spv = @admin.spv
      end
      @owner = current_owner
    end

    #Create multiple leaves
    def leave_params(lv)
      lv.permit(:name, :day, :teacher_id, :taska_id, :tsklv_id)
    end

    def payinfo_params
      params.require(:tch).permit(:amt,
                                  :alwnc,
                                  :fxddc,
                                  :epf,
                                  :epfa,
                                  :socs,
                                  :socsa,
                                  :sip,
                                  :sipa,
                                  :teacher_id,
                                  :taska_id)
    end

    def payslip_params
      params.require(:payslip).permit(:mth,
                                      :year,
                                      :amt,
                                      :alwnc,
                                      :fxddc,
                                      :epf,
                                      :addtn,
                                      :desc,
                                      :teacher_id,
                                      :taska_id,
                                      :epfa,
                                      :amtepfa,
                                      :psl_id,
                                      :socs,
                                      :socsa,
                                      :sip,
                                      :sipa,
                                      :dedc,
                                      :descdc,
                                      :notf,
                                      :xtra)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def taska_params
      params.require(:taska).permit(:name,
                                    :email,
                                    :phone_1,
                                    :phone_2,
                                    :address_1,
                                    :address_2,
                                    :city,
                                    :states,
                                    :postcode,
                                    :supervisor,
                                    :bank_name,
                                    :acc_no,
                                    :acc_name,
                                    :ssm_no,
                                    :plan,
                                    :booking,
                                    :discount,
                                    :pslm,
                                    :blgt,
                                    :rato,
                                    :cred,
                                    fotos_attributes: [:foto, :picture, :foto_name]  )
    end
    def taska_params_bank
      params.require(:taska).permit(:bank_name,
                                    :acc_no,
                                    :acc_name,
                                    :ssm_no)
    end

    def foto_params
      params.require(:bill).permit(:foto_name, :picture)
    end

    def check_admin
      same = false
      @taska.admins.each do |admin|
        if admin == current_admin
          same = true
        end
      end
      if !same
        flash[:danger] = "You dont have access"
        redirect_to admin_index_path
      end
    end
end

################# OLD ############################

 ## OLD TASKAS ##
  #START ANSYS
  def admansys
    tsk = Taska.find(params[:id])
    tsk.states = params[:st]
    tsk.save
    flash[:success] = "UPDATE SUCCESSFULL"
    redirect_to statansys_path
  end

  def delansys
    tsk = Taska.find(params[:id])
    if tsk.destroy
      flash[:danger] = "Delete berjaya"
      redirect_to statansys_path
    end
  end

  def rsvpans
    @taska=Taska.find(params[:id])
  end

  def updrsvp
  end

  def updrsvpadm
  end

  def regansys
    @taska = Taska.new
    @taska.fotos.build
  end

  def crtansys
    @taska = Taska.new(taska_params)
    if (t=Taska.where(name: 
                    @taska.name, 
                    email: @taska.email, 
                    plan: @taska.plan)).present?
      @taska = t.first
    end
    if @taska.save
      flash[:notice] = "PENDAFTARAN DITERIMA"
      redirect_to statansys_path
    end
  end

  def statansys
    @taskas = Taska.where(plan: "ansys19")
    if params[:par].present?
      if params[:par] == "nil"
        st = nil
      else
        st = params[:par]
      end
      @tsort = Taska.where(plan: "ansys19", states: st)
    else
      @tsort = @taskas
    end
  end

  def editansys
    @taska = Taska.find(params[:id])
  end

  def updansys
    @taska = Taska.find(params[:taska][:id])
    rsvp = params[:taska][:rsvp]
    if @taska.update(taska_params)
      flash[:notice] = "KEMASKINI BERJAYA"
      if rsvp == "0"
        redirect_to statansys_path
      else
        redirect_to succansys_path
      end
    end
  end

  def succansys
  end

  def ansys_xls
    @taskas = Taska.where(plan: "ansys19")
    respond_to do |format|
      #format.html
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="SENARAI SYMPOSIUM ANIS.xlsx"'
      }
    end
  end
  #END ANSYS


  # START MBR
  def regmbr19
    @taska = Taska.new
    @taska.fotos.build
  end

  def crtmbr19
    @taska = Taska.new(taska_params)
    if (t=Taska.where(name: 
                    @taska.name, 
                    email: @taska.email, 
                    plan: @taska.plan)).present?
      @taska = t.first
    end
    if @taska.save
      flash[:notice] = "PENDAFTARAN DITERIMA"
      redirect_to editmbr19_path(id: @taska.id)
    end
  end

  def statmbr19
    @taskas = Taska.where(plan: "mbr19")
  end

  def editmbr19
    @taska = Taska.find(params[:id])
  end

  def updmbr19
    @taska = Taska.find(params[:taska][:id])
    if @taska.update(taska_params)
      flash[:notice] = "KEMASKINI BERJAYA"
      redirect_to editmbr19_path(id: @taska.id)
    end
  end

  def mbr19_xls
    @taskas = Taska.where(plan: "mbr19")
    respond_to do |format|
      #format.html
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="SENARAI TASKA MBR19.xlsx"'
      }
    end
  end
  # END MBR


  def index
    @taskas = Taska.all
  end

  def hiscrdt
    @taska.hiscred.each do |hc|
      if hc.class == String
        url_bill = "#{ENV['BILLPLZ_API']}bills/#{hc}"
        data_billplz = HTTParty.get(url_bill.to_str,
                :body  => { }.to_json, 
                            #:callback_url=>  "YOUR RETURN URL"}.to_json,
                :basic_auth => { :username => "#{ENV['BILLPLZ_APIKEY']}" },
                :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
        #render json: data_billplz and return
        data = JSON.parse(data_billplz.to_s)
        if data["id"].present? 
          if (data["paid"] == true)
            newarr = [(data["paid_amount"].to_f/100),data["paid_at"].to_time,data["id"]]
            @taska.cred += data["paid_amount"].to_f/100
          else
            newarr = 0.00
          end
          modarr = @taska.hiscred.map { |x| x == data["id"] ? newarr : x }
          @taska.hiscred = modarr
          @taska.save
        end
      end
    end
    render action: "hiscrdt", layout: "dsb-admin-overview" 
  end

  def topcred
    amt = params[:amt].to_f * 100
    url_bill = "#{ENV['BILLPLZ_API']}bills"
    data_billplz = HTTParty.post(url_bill.to_str,
            :body  => { :collection_id => "#{ENV['COLLECTION_ID']}", 
                        :email=> "bill@kidcare.my",
                        :name=> "#{@taska.name} Credit Reload", 
                        :amount=>  amt,
                        :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update?taska=#{@taska.id}",
                        :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update?taska=#{@taska.id}",
                        :description=>"Credit Reload for #{@taska.name}(#{@taska.id})"}.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    #render json: data_billplz and return
    data = JSON.parse(data_billplz.to_s)
    if (bill_id=data["id"]).present?
      @taska.hiscred << bill_id
      @taska.save
      redirect_to "#{ENV['BILLPLZ_URL']}/bills/#{bill_id}"
    else
      flash[:danger] = "Credit Topup Failed. Please try again"
      redirect_to hiscrdt_path(@taska)
    end
    
  end

  def xlsclsrm
    render action: "xlsclsrm", layout: "dsb-admin-overview" 
  end

  def tempclsrmxls
    respond_to do |format|
      #format.html
      format.xlsx{
                  response.headers['Content-Disposition'] = 'attachment; filename="Classroom Template.xlsx"'
      }
    end
  end

  def upldclsrm
    xlsx = Roo::Spreadsheet.open(params[:file])
    header = xlsx.row(xlsx.first_row+2)
    ((xlsx.first_row+4)..(xlsx.last_row)).each do |n|
      xlsx.row(n)
      row = Hash[[header, xlsx.row(n)].transpose]
      if row["NAMA"].present? && row["YURAN (RM)"].present?
        Classroom.create(classroom_name: row["NAMA"], 
                      taska_id: @taska.id, 
                      description: row["MAKLUMAT"],
                      base_fee: row["YURAN (RM)"])
      end
    end
    flash[:success] = "CLASSROOMS ADDED"
    redirect_to classroom_index_path(@taska)
  end

  def xlskid
    render action: "xlskid", layout: "dsb-admin-overview"
  end

  def tempkidxls
    @taska = Taska.find(params[:id])
    respond_to do |format|
      #format.html
      format.xlsx{
                  response.headers['Content-Disposition'] = 'attachment; filename="Borang Tambah Pelajar.xlsx"'
      }
    end
  end

  def upldkid
    xlsx = Roo::Spreadsheet.open(params[:file])
    header = xlsx.row(xlsx.first_row+2)
    ((xlsx.first_row+4)..(xlsx.last_row)).each do |n|
      
      xlsx.row(n)
      row = Hash[[header, xlsx.row(n)].transpose]
      if row["NAMA"].present? && row["MYKID"].present?
        if @taska.classrooms.where(id: row["ID KELAS"]).present?
          cls = row["ID KELAS"]
        else
          cls = nil
        end
        ic1= row["MYKID"][0..5]
        ic2= row["MYKID"][7..8]
        ic3= row["MYKID"][10..13]
        if !@taska.kids.where(ic_1: ic1, ic_2: ic2, ic_3: ic3).present?
          kid=Kid.create(name: row["NAMA"], 
                    parent_id: 1, 
                    taska_id: @taska.id,
                    classroom_id: cls,
                    ic_1: row["MYKID"][0..5],
                    ic_2: row["MYKID"][7..8],
                    ic_3: row["MYKID"][10..13],
                    dob: row["TARIKH LAHIR"].to_date,
                    ph_1: row["NO TELEFON"][0..2],
                    ph_2: row["NO TELEFON"][4..11],
                    father_name: row["NAMA BAPA"],
                    mother_name: row["NAMA IBU"],
                    gender: row["JANTINA"])
          Foto.create(foto_name:"CHILD MYKID", kid_id: kid.id)
          Foto.create(foto_name:"CHILDREN PICTURE", kid_id: kid.id)
          Foto.create(foto_name:"IMMUNIZATION RECORD", kid_id: kid.id)
          Foto.create(foto_name:"FATHER MYKAD", kid_id: kid.id)
          Foto.create(foto_name:"MOTHER MYKAD", kid_id: kid.id)
        end
      end

    end
    flash[:success] = "FILE UPLOADED"
    redirect_to taska_path(@taska)
  end

  def find_spv
    if params[:email].blank?
      flash.now[:danger] = "Please enter email"
    else
      @admin_list = Admin.where(email: params[:email])
    end
    flash.now[:danger] = "NO RECORD FOUND" unless @admin_list.present?
    respond_to do |format|
      format.js { render partial: 'taskas/resultspv' } 
    end
  end

  def add_role
    adm = Admin.find(params[:adm])
    if adm.taskas.where(id: @taska.id).present?
      flash[:danger] = "Role already assigned to #{@taska.name}"
    else
      TaskaAdmin.create(taska_id: @taska.id, admin_id: adm.id)
      if params[:spv] == "1"
        adm.spv = true
        adm.save
        role = "Supervisor"
      else
        role = "Admin"
      end
      flash[:success] = "#{adm.username} successfully assigned to #{@taska.name} as #{role}"
    end
    redirect_to taska_path(@taska)
  end

  def rmv_role
    adm = Admin.find(params[:adm])
    tskadm = TaskaAdmin.where(taska_id: @taska.id, admin_id: adm.id)
    tskadm.delete_all
    if adm.taskas.count < 1
      adm.spv = nil
      adm.save
    end
    flash[:success] = "#{adm.username} successfully removed"
    redirect_to taska_path(@taska)
  end

  def index_parent
    @parent = current_parent
    if params[:reg] == "1"
      redirect_to new_kid_path(taska_id: params[:taska_id])
    else
      @taskas = Taska.all.where.not(name: "Taska admin master").where.not(name: "TASKA Wma").where.not(name: "taska mirror tsp")
    end
  end

  def taska_pricing
  end

  def taska_page
    @taska = Taska.find(params[:id])
    @fotos = @taska.fotos
  end

  def unreg_kids
    @taska = Taska.find(params[:id])
    @kid = Kid.new
    @unregistered_kids = @taska.kids.where(classroom_id: nil).order('name ASC')
    @taska_classrooms = @taska.classrooms
    render action: "unreg_kids", layout: "dsb-admin-overview"
  end

  def childlist_xls
    @taska = Taska.find(params[:id])
    @taska_kids = @taska.kids.order('name ASC')
    respond_to do |format|
      #format.html
      format.xlsx{
                  response.headers['Content-Disposition'] = 'attachment; filename="Children List.xlsx"'
      }
    end
  end

  def add_subdomain
    @taska = Taska.find(params[:id])
    subdomain = params[:taska][:subdomain]
    exist = Taska.where(subdomain: subdomain)
    if exist.present?
      flash[:danger] = "Website name not available. Please choose another name"
    else
      @taska.subdomain = subdomain
      @taska.save
      flash[:success] = "Website name successfully added"
    end
    redirect_to taska_path(@taska)
  end

  def find_child
    #@classroom = Classroom.find(params[:id])
    @taska = Taska.find(params[:id])
    @kid = Kid.find(params[:child])
    if params[:name].blank? 
      flash.now[:danger] = "You have entered an empty request"
    else
      @kid_search = @taska.kids.where("name like?", "%#{params[:name].upcase}%" ).where.not(classroom_id: nil)
      flash.now[:danger] = "Cannot find child" unless @kid_search.present?
    end
    respond_to do |format|
      format.js { render partial: 'taskas/result' } 
    end
  end

  def taska_receipts
    @taska = Taska.find(params[:id])
    @taska_receipts = @taska.payments.where(name: "TASKA PLAN").where(paid: true)
    render action: "taska_receipts", layout: "dsb-admin-overview" 
  end

  def all_bills
    @taska = Taska.find(params[:id])
    @kid = Kid.find(params[:kid_id])
    @kid_bills = @kid.payments.where(taska_id: @taska.id).order("paid ASC").order("updated_at ASC")
    render action: "all_bills", layout: "dsb-admin-classroom"
  end

  def remove_taska
    @kid = Kid.find(params[:kid])
    @taska = @kid.taska
    if (bill =@kid.payments.where(name: "TASKA BOOKING").where(taska_id: @taska.id).where(paid: false)).present?
      bill.last.destroy
    end
    @kid.taska_id = nil
    if @kid.save
      flash[:success] = "Children has been successfully removed"
    else
      flash[:danger] = "Unsuccessful. Please try again"
    end
    
    redirect_to unreg_kids_path(@taska)
  end

  def child_bill_index
    @taska = Taska.find(params[:id])
    @kid = Kid.find(params[:kid])
    @kid_bills = @kid.payments.where(taska_id: @taska.id).order('bill_year DESC').order('paid ASC').order('bill_month DESC')
    render action: "child_bill_index", layout: "dsb-admin-classroom"
  end


  # GET /taskas/1

  # GET /taskas/1.json
  def show_old
    # ada kt bawah func set_taska
    if 1==0 #@taska.classrooms.count < 1
      redirect_to xlsclsrm_path(@taska)
    elsif 2==0 #@taska.kids.count < 1
      redirect_to xlskid_path(@taska)
    else
      updtskplan()
      @admin_taska = current_admin.taskas
      @admintsk = @taska.admins.where.not(id: 4)
      @unregistered_no = @taska.kids.where(classroom_id: nil).count
      # #check payment status
      # all_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false)
      # all_unpaid.each do |payment|
      #   if !payment.paid 
      #     url_bill = "#{ENV['BILLPLZ_API']}bills/#{payment.bill_id}"
      #     data_billplz = HTTParty.get(url_bill.to_str,
      #             :body  => { }.to_json, 
      #                         #:callback_url=>  "YOUR RETURN URL"}.to_json,
      #             :basic_auth => { :username => "#{ENV['BILLPLZ_APIKEY']}" },
      #             :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      #     #render json: data_billplz and return
      #     data = JSON.parse(data_billplz.to_s)
      #     if data["id"].present? && (data["paid"] == true)
      #       payment.paid = data["paid"]
      #       payment.save
      #     end
      #   end
      # end
      time = Time.now.in_time_zone('Singapore')
      @mth = time.month
      @yr = time.year 
      psldt = time - @taska.pslm.months
      #calculate unpaid - partial
      upd_par = 0.00
      @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false)
      @kid_unpaid.each do |pm|
        upd_par += pm.parpayms.sum(:amt)
      end
      @totkid_unpaid = @kid_unpaid.sum(:amount) - upd_par

      @taska_expense = @taska.expenses.where(month: @mth).where(year: @yr).order('CREATED_AT DESC')
      @payslips = @taska.payslips.where(mth: psldt.month, year: psldt.year)
      @applvs = @taska.applvs.where.not(stat: "APPROVED").where.not(stat: "REJECTED")
      #display expense at front
      #planper = time + 1.months
      #plan = @taska.payments.where(bill_month: planper.in_time_zone('Singapore').month).where(name: "TASKA PLAN").where(bill_year: planper.in_time_zone('Singapore').year).where(paid: true).sum(:amount)
      plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(year  from updated_at) = ?', @yr).where('extract(month  from updated_at) = ?', @mth).sum(:amount)
      #START BILLS
        dt = Time.find_zone("Singapore").local(@yr,@mth)
        payment = @taska.payments.where.not(name: "TASKA PLAN")
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
        #bills_paid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: true).where('extract(year  from updated_at) = ?', @yr).where('extract(month  from updated_at) = ?', @mth).sum(:amount)

      #END BILLS
      @disp =  -plan + @taska_expense.where(kind: "INCOME").sum(:cost) - @taska_expense.where(kind: "EXPENSE").sum(:cost) + bills_paid +bills_partial-@payslips.sum(:amtepfa)

      session[:taska_id] = @taska.id
      session[:taska_name] = @taska.name  
      render action: "show", layout: "dsb-admin-overview" 
    end
  end

  def sms_reminder
      @taska = Taska.find(params[:id])
      @payment = Payment.find(params[:bill])
      @kid = Kid.find(params[:kid])
    if params[:xtrarem].present?
      phk = "#{params[:phk]}"
      if @taska.cred < 0.5
        nufcred = false
      else
        nufcred = true
      end
    else
      phk = "#{@kid.ph_1}#{@kid.ph_2}"
      nufcred = true
    end
    if 1==1 && nufcred #Rails.env.production?
      @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
        @client.messages.create(
          to: "+6#{phk}",
          from: ENV["TWILIO_PHONE_NO"],
          body: "Reminder from #{@taska.name.upcase}. Please click here <#{billview_url(payment: @payment.id, kid: @kid.id, taska: @taska.id)}> to payment."
        )
    end
    if params[:xtrarem].present? && nufcred
      @taska.hiscred << [-0.5,Time.now,phk,@payment.bill_id]
      @taska.cred -= 0.5
      @taska.save
    else
      @payment.reminder = true
      @payment.save
    end
    if nufcred 
      flash[:success] = "SMS reminder send to +6#{phk}"
    else
      flash[:danger] = "Insufficient credit. Please reload"
    end
    if params[:account].present?
      redirect_to bill_account_path(@taska, 
                                    month: params[:month],
                                    year: params[:year],
                                    paid: false)
    else
      redirect_to unpaid_index_path(@taska)
    end
  end

  def bill_account
    @taska = Taska.find(params[:id])
    paid = params[:paid]
    mth = params[:month].to_i
    year = params[:year].to_i
    if params[:month] == "0"
      if paid == "true"
        @kid_unpaid = nil
        @w=[]
        (1..12).each do |m|
          dt = Time.find_zone("Singapore").local(year,m)
          payment = @taska.payments.where.not(name: "TASKA PLAN")
          curr_pmt = payment.where(bill_month: m).where(bill_year: year)
          curr_pmt_paid = curr_pmt.where(paid: true)
          curr_pmt_unpaid = curr_pmt.where(paid: false)
          #CDTN_1 = current period pay early
          @cdtn_1 = curr_pmt_paid.where("updated_at < ?", dt)
          #CDTN_2 = current period pay this month
          @cdtn_2 = curr_pmt_paid.where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', m)
          #CDTN_3 = previous period pay this month
          dt_lp = dt
          stp_lp = Time.find_zone("Singapore").local(2016,1)
          @cdtn_3 = nil
          while dt_lp >= stp_lp
            if @cdtn_3.blank?    
              @cdtn_3 = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', m)
            else
              tmp = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', m)
              @cdtn_3 = @cdtn_3.or(tmp)
            end
            dt_lp = dt_lp - 1.months
          end
          if @kid_unpaid.blank?
            @kid_unpaid = @cdtn_1.or(@cdtn_2.or(@cdtn_3))
          else
            tmp = @cdtn_1.or(@cdtn_2.or(@cdtn_3))
            @kid_unpaid = @kid_unpaid.or(tmp)
          end

          #start for partial
          #CDTN_1 All partials paid this month or previous month for current month bill
          cdtn_1par = nil
          cdtn_2par = nil
          
          curr_pmt_unpaid.each do |pmt|
            if pmt.parpayms.present?
              tmp = pmt.parpayms.where("upd < ?", dt).or(pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', m)) 
              if tmp.ids.present?
                tmp.ids.each do |k|
                  @w<<k
                end
              end
              
            end
          end
          #CDTN_2 previous months bills paid partially this month
          #cdtn_2par = 0.00
          dt_lp=dt-1.months
          while dt_lp >= stp_lp
            payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
              tmp = pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', m)
              if tmp.ids.present?
                tmp.ids.each do |k|
                  @w<<k
                end
              end
            end
            dt_lp -= 1.months
          end
          #END PARTIAL 

          @w.each do |w|
            tmp = Parpaym.find(w)
            if @kid_unpaid.present?
              @kid_unpaid = @kid_unpaid.or(Payment.where(id: tmp.payment.id))
            else
              @kid_unpaid = Payment.where(id: tmp.payment.id)
            end
          end
        end
        @kid_unpaid = @kid_unpaid.order('updated_at DESC')
        #@kid_unpaid = @cdtn_1.or(@cdtn_2.or(@cdtn_3))
        #@kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: params[:paid]).where(bill_year: params[:year]).order('bill_month ASC')
      else
        @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: params[:paid]).where(bill_year: params[:year]).order('bill_month ASC')
      end
    else
      dt = Time.find_zone("Singapore").local(year,mth)
      if paid == "true"
        payment = @taska.payments.where.not(name: "TASKA PLAN")
        curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
        curr_pmt_paid = curr_pmt.where(paid: true)
        curr_pmt_unpaid = curr_pmt.where(paid: false)
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
            cdtn_3 = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
          else
            tmp = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
            cdtn_3 = cdtn_3.or(tmp)
          end
          dt_lp = dt_lp - 1.months
        end

        #start for partial
        #CDTN_1 All partials paid this month or previous month for current month bill
        cdtn_1par = nil
        cdtn_2par = nil
        @all_par = nil
        @w=[]
        curr_pmt_unpaid.each do |pmt|
          if pmt.parpayms.present?
            tmp = pmt.parpayms.where("upd < ?", dt).or(pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth))
            if cdtn_1par.blank?
              cdtn_1par = tmp unless tmp.blank?
            else
              cdtn_1par = cdtn_1par.or(tmp) unless tmp.blank?
            end
            if tmp.ids.present?
              tmp.ids.each do |k|
                @w<<k
              end
            end
            @cdtn = cdtn_1par
            #cdtn_1par = cdtn_1par.or(pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth))
          end
        end
        #CDTN_2 previous months bills paid partially this month
        #cdtn_2par = 0.00
        dt_lp=dt-1.months
        while dt_lp >= stp_lp
          payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
            tmp = pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth)
            if cdtn_2par.blank?
              cdtn_2par = tmp unless tmp.blank?
            else
              cdtn_2par = cdtn_2par.or(tmp) unless tmp.blank?
            end
            if tmp.ids.present?
              tmp.ids.each do |k|
                @w<<k
              end
            end
          end
          dt_lp -= 1.months
        end
        #END PARTIAL 

        @kid_unpaid = cdtn_1.or(cdtn_2.or(cdtn_3))
        @w.each do |w|
          tmp = Parpaym.find(w)
          if @kid_unpaid.present?
            @kid_unpaid = @kid_unpaid.or(Payment.where(id: tmp.payment.id))
          else
            @kid_unpaid = Payment.where(id: tmp.payment.id)
          end
        end
        @kid_unpaid = @kid_unpaid.order('updated_at DESC')
      else
        @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: params[:paid]).where(bill_month: params[:month]).where(bill_year: params[:year]).order('updated_at DESC')
      end
      
      #@kid_all_bills = @taska.payments.where.not(name: "TASKA PLAN").order('bill_year ASC').order('bill_month ASC')
    end
    render action: "bill_account", layout: "dsb-admin-account" 
  end

  def unpaid_index
    @taska = Taska.find(params[:id])
    #check all unpaid bills with billplz
    
    @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).order('bill_year ASC').order('bill_month ASC')
    @kid_all_bills = @taska.payments.where.not(name: "TASKA PLAN").order('bill_year ASC').order('bill_month ASC')
    render action: "unpaid_index", layout: "dsb-admin-overview" 
  end

  def updunpaid
    @taska = Taska.find(params[:id])   
    pre_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false)
    pre_unpaid.each do |pb|
      url_bill = "#{ENV['BILLPLZ_API']}bills/#{pb.bill_id}"
      data_billplz = HTTParty.get(url_bill.to_str,
              :body  => {}.to_json, 
                          #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      #render json: data_billplz and return
      data = JSON.parse(data_billplz.to_s)
      if data["paid"] == true
        pb.paid = true
        pb.updated_at = data["paid_at"]
        pb.save
      end
    end
    flash[:success] = "Payment Status Updated"
    redirect_to unpaid_index_path(@taska)
  end

  def manupdbill
    @pdf = false
    @payment = Payment.find(params[:bill]) 
    #@kid = Kid.find(params[:kid])
    @kid = @payment.kids.first
    @taska = Taska.find(params[:taska])
    @fotos = @taska.fotos
    render action: "manupdbill", layout: "dsb-admin-overview"
  end

  def svupdbill
    bill = params[:bill]
    @taska = Taska.find(bill[:taska_id])
    @payment = Payment.find(bill[:payment_id])
    #@foto = @taska.fotos.build
    if bill[:paid] == "FULL PAYMENT"
      
      @payment.paid = true
      @payment.mtd = bill[:mtd]
      @payment.updated_at = bill[:updated_at]
      @foto = Foto.new
      @foto.picture = bill[:picture]
      @foto.foto_name = bill[:foto_name]
      @foto.payment_id = bill[:payment_id]
      if @foto.save && @payment.save
        flash[:notice] = "BILL UPDATED"
      else
        flash[:danger] = "UPDATE FAILED"
      end

    elsif bill[:paid] == "PARTIAL PAYMENT"
      currppm = @payment.parpayms.sum(:amt) + bill[:amt].to_f
      if currppm >= @payment.amount
        flash[:danger] = "WRONG AMOUNT OR PAYMENT STATUS ENTERED"
        redirect_to tsk_manupdbill_path(@taska, bill: @payment.id,kid: @payment.kids.first.id ,taska: @taska.id) and return
      else
        ppm = Parpaym.new
        ppm.kind = bill[:paid]
        ppm.amt = bill[:amt]
        ppm.payment_id = @payment.id
        ppm.upd = bill[:updated_at]
        ppm.mtd = bill[:mtd]
        if ppm.save
          @foto = Foto.new
          @foto.picture = bill[:picture]
          @foto.foto_name = bill[:foto_name]
          @foto.parpaym_id = ppm.id
          @foto.save
          flash[:notice] = "BILL UPDATED"
        else
          flash[:danger] = "UPDATE FAILED"
        end
      end

    elsif bill[:paid] == "FINAL PAYMENT"
      currppm = @payment.parpayms.sum(:amt) + bill[:amt].to_f
      if currppm != @payment.amount
        flash[:danger] = "WRONG AMOUNT OR PAYMENT STATUS ENTERED"
        redirect_to tsk_manupdbill_path(@taska, bill: @payment.id,kid: @payment.kids.first.id ,taska: @taska.id) and return
      else
        ppm = Parpaym.new
        ppm.kind = bill[:paid]
        ppm.amt = bill[:amt]
        ppm.payment_id = @payment.id
        ppm.upd = bill[:updated_at]
        ppm.mtd = bill[:mtd]
        @payment.paid = true
        @payment.mtd = "MULTIPLE METHOD. REFER BILL"
        @payment.updated_at = bill[:updated_at]
        if ppm.save && @payment.save
          @foto = Foto.new
          @foto.picture = bill[:picture]
          @foto.foto_name = bill[:foto_name]
          @foto.parpaym_id = ppm.id
          @foto.save
          flash[:notice] = "BILL UPDATED"
        else
          flash[:danger] = "UPDATE FAILED"
        end
      end
    end
    redirect_to unpaid_index_path(id: bill[:taska_id])
  end

  def delete_parpaym
    @parpaym = Parpaym.find(params[:prppm])
    @payment = @parpaym.payment
    @taska = @payment.taska
    if @parpaym.destroy && @parpaym.fotos.first.destroy
      flash[:notice] = "SUCCESS"
    else
      flash[:danger] = "FAILED"
    end
      redirect_to tsk_manupdbill_path(@taska, bill: @payment.id,kid: @payment.kids.first.id ,taska: @taska.id)
  end

  def check_bill
    @taska = Taska.find(params[:id])
    @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).order('bill_year ASC').order('bill_month ASC')
  end

  def sms_reminder_all
    @taska = Taska.find(params[:id])
    if params[:account].present?
      if params[:month] == "0"
        @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).where(reminder: false).where(bill_year: params[:year])
      else
        @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).where(reminder: false).where(bill_year: params[:year]).where(bill_month: params[:month])
      end
    else
      @kid_unpaid = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).where(reminder: false)
    end
    #@taska_all = Taska.all
    ctr = 0
    #render json: @taska_all and return
    @kid_unpaid.each do |bill|
      @kid = bill.kids.first
      if Rails.env.production?
        @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
        @client.messages.create(
          to: "+6#{@kid.ph_1}#{@kid.ph_2}",
          from: ENV["TWILIO_PHONE_NO"],
          body: "Reminder from #{@taska.name.upcase}. Please click here <#{bill_view_url(payment: bill.id, kid: @kid.id, taska: @taska.id)}> to payment."
        )
      end
      bill.reminder = true
      bill.save
      ctr = ctr + 1
    end
    flash[:success] = "SMS reminders sent to #{ctr} parents"
    if params[:account].present?
      redirect_to bill_account_path(@kid.taska, 
                                    month: params[:month],
                                    year: params[:year],
                                    paid: false)
    else
      redirect_to unpaid_index_path(@taska)
    end
  end

  def unpaid_xls
    @taska = Taska.find(params[:id])
    mth = params[:month].to_i
    year = params[:year].to_i
    paid = params[:paid]
    if mth != 0
      dt = Time.find_zone("Singapore").local(year,mth)
      if paid == "true" # i dont use false because too complicated
        payment = @taska.payments.where.not(name: "TASKA PLAN")
        curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
        curr_pmt_paid = curr_pmt.where(paid: true)
        curr_pmt_unpaid = curr_pmt.where(paid: false)
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
            cdtn_3 = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
          else
            tmp = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
            cdtn_3 = cdtn_3.or(tmp)
          end
          dt_lp = dt_lp - 1.months
        end

        #start for partial
        #CDTN_1 All partials paid this month or previous month for current month bill
        cdtn_1par = nil
        cdtn_2par = nil
        @all_par = nil
        @w=[]
        curr_pmt_unpaid.each do |pmt|
          if pmt.parpayms.present?
            tmp = pmt.parpayms.where("upd < ?", dt).or(pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth))
            if cdtn_1par.blank?
              cdtn_1par = tmp unless tmp.blank?
            else
              cdtn_1par = cdtn_1par.or(tmp) unless tmp.blank?
            end
            if tmp.ids.present?
              tmp.ids.each do |k|
                @w<<k
              end
            end
            @cdtn = cdtn_1par
            #cdtn_1par = cdtn_1par.or(pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth))
          end
        end
        #CDTN_2 previous months bills paid partially this month
        #cdtn_2par = 0.00
        dt_lp=dt-1.months
        while dt_lp >= stp_lp
          payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
            tmp = pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth)
            if cdtn_2par.blank?
              cdtn_2par = tmp unless tmp.blank?
            else
              cdtn_2par = cdtn_2par.or(tmp) unless tmp.blank?
            end
            if tmp.ids.present?
              tmp.ids.each do |k|
                @w<<k
              end
            end
          end
          dt_lp -= 1.months
        end
        #END PARTIAL 

        @bills = cdtn_1.or(cdtn_2.or(cdtn_3))
        @w.each do |w|
          tmp = Parpaym.find(w)
          if @bills.present?
            @bills = @bills.or(Payment.where(id: tmp.payment.id))
          else
            @bills = Payment.where(id: tmp.payment.id)
          end
        end
        #@bills = @bills.order('bill_year ASC').order('bill_year ASC')
        @bills = @bills.order('updated_at ASC')
        @unpaid_bills = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).where(bill_month: params[:month]).where(bill_year: params[:year]).order('updated_at DESC')
      end
      #@bills = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: year, bill_month: mth, paid: paid).order('bill_month ASC')
    else
      #START EVERY MONTH
      (1..12).each do |mth|
        dt = Time.find_zone("Singapore").local(year,mth)
        if paid == "true" # i dont use false because too complicated
          payment = @taska.payments.where.not(name: "TASKA PLAN")
          curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
          curr_pmt_paid = curr_pmt.where(paid: true)
          curr_pmt_unpaid = curr_pmt.where(paid: false)
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
              cdtn_3 = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
            else
              tmp = payment.where(paid: true).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).where('extract(year  from updated_at) = ?', year).where('extract(month  from updated_at) = ?', mth)
              cdtn_3 = cdtn_3.or(tmp)
            end
            dt_lp = dt_lp - 1.months
          end

          #start for partial
          #CDTN_1 All partials paid this month or previous month for current month bill
          cdtn_1par = nil
          cdtn_2par = nil
          @all_par = nil
          @w=[]
          curr_pmt_unpaid.each do |pmt|
            if pmt.parpayms.present?
              tmp = pmt.parpayms.where("upd < ?", dt).or(pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth))
              if cdtn_1par.blank?
                cdtn_1par = tmp unless tmp.blank?
              else
                cdtn_1par = cdtn_1par.or(tmp) unless tmp.blank?
              end
              if tmp.ids.present?
                tmp.ids.each do |k|
                  @w<<k
                end
              end
              @cdtn = cdtn_1par
              #cdtn_1par = cdtn_1par.or(pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth))
            end
          end
          #CDTN_2 previous months bills paid partially this month
          #cdtn_2par = 0.00
          dt_lp=dt-1.months
          while dt_lp >= stp_lp
            payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
              tmp = pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth)
              if cdtn_2par.blank?
                cdtn_2par = tmp unless tmp.blank?
              else
                cdtn_2par = cdtn_2par.or(tmp) unless tmp.blank?
              end
              if tmp.ids.present?
                tmp.ids.each do |k|
                  @w<<k
                end
              end
            end
            dt_lp -= 1.months
          end
          #END PARTIAL 
          if @bills.present?
            @bills = @bills.or(cdtn_1.or(cdtn_2.or(cdtn_3)))
          else
            @bills = cdtn_1.or(cdtn_2.or(cdtn_3))
          end
          @w.each do |w|
            tmp = Parpaym.find(w)
            if @bills.present?
              @bills = @bills.or(Payment.where(id: tmp.payment.id))
            else
              @bills = Payment.where(id: tmp.payment.id)
            end
          end
          
          
        end
      end
      #END EVERY MONTH
      #@bills = @bills.order('bill_year ASC').order('bill_month ASC')
      @bills = @bills.order('updated_at ASC')
      @unpaid_bills = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).where(bill_year: params[:year]).order('bill_month ASC')
      #@bills = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: year, paid: paid).order('bill_month ASC')
      #@unpaid_bills = @taska.payments.where.not(name: "TASKA PLAN").where(paid: false).where(bill_year: params[:year]).order('updated_at DESC')

    end

    respond_to do |format|
      #format.html
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="Billing List.xlsx"'
      }
    end
  end

  def unpaid_xls_old
    @taska = Taska.find(params[:id])

    if params[:month].present? && params[:year].present?
      if params[:paid] == "false"
        if params[:month] == "0"
          @bills = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: params[:year]).where(paid: params[:paid]).order('bill_month ASC')
        else
          @bills = @taska.payments.where.not(name: "TASKA PLAN").where(bill_month: params[:month]).where(bill_year: params[:year]).where(paid: params[:paid])
        end
      else
        if params[:month] == "0"
          @bills = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: params[:year]).order('bill_month ASC')
        else
          @bills = @taska.payments.where.not(name: "TASKA PLAN").where(bill_month: params[:month]).where(bill_year: params[:year])
        end
      end
    else
      if params[:paid] == "false"
        @bills = @taska.payments.where.not(name: "TASKA PLAN").where(paid: params[:paid]).order('bill_year ASC').order('bill_month ASC')
      else
        @bills = @taska.payments.where.not(name: "TASKA PLAN").order('bill_year ASC').order('bill_month ASC')
      end
    end

    respond_to do |format|
      #format.html
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="download.xlsx"'
      }
    end
  end

  def pl_xls
    @taska = Taska.find(params[:id])
    if params[:month] == "0"
      @payslips = @taska.payslips.where(year: params[:year])
      @taska_expenses = @taska.expenses.where(year: params[:year]).order('month ASC')
      #START BILL
      year = params[:year].to_i
      @taska_bills = nil
      @bill_hash = Hash.new
      @tot_par = 0.00
      (1..12).each do |mth|
        dt = Time.find_zone("Singapore").local(year,mth)
        payment = @taska.payments.where.not(name: "TASKA PLAN")
        curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
        curr_pmt_paid = curr_pmt.where(paid: true)
        curr_pmt_unpaid = curr_pmt.where(paid: false)
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
        #start for partial
        #CDTN_1 All partials paid this month or previous month for current month bill
        cdtn_1par = 0.00
        curr_pmt_unpaid.each do |pmt|
          if pmt.parpayms.present?
            cdtn_1par += pmt.parpayms.where("upd < ?", dt).sum(:amt) 
            cdtn_1par += pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth).sum(:amt) 
          end
        end
        #CDTN_2 previous months bills paid partially this month
        cdtn_2par = 0.00
        dt_lp=dt-1.months
        while dt_lp >= stp_lp
          payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
            cdtn_2par += pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth).sum(:amt)
          end
        dt_lp -= 1.months
        end
        @bills_partial = cdtn_1par + cdtn_2par
        @tot_par += @bills_partial
        #END PARTIAL
        @bill_hash[mth]= all_payments.where(paid: true).sum(:amount) + @bills_partial
        if @taska_bills.blank?
          @taska_bills = all_payments
        else
          @taska_bills = @taska_bills.or(all_payments)
        end
      end

      #@taska_bills = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: params[:year])

      #END BILL
      @taska_plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(year from updated_at) = ?', params[:year])
    else
      dt = Date.new(params[:year].to_i,params[:month].to_i)
      mth = dt.month
      year = dt.year
      psldt = dt - @taska.pslm.months
      @payslips = @taska.payslips.where(mth: psldt.month, year: psldt.year)
      @taska_expenses = @taska.expenses.where(month: params[:month]).where(year: params[:year])
      #START FOR BILL
      payment = @taska.payments.where.not(name: "TASKA PLAN")
      curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
      curr_pmt_paid = curr_pmt.where(paid: true)
      curr_pmt_unpaid = curr_pmt.where(paid: false)
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
      taska_payments = cdtn_1.or(cdtn_2.or(cdtn_3))
      @taska_bills = taska_payments.where(paid: true)

      #start for partial
      #CDTN_1 All partials paid this month or previous month for current month bill
      cdtn_1par = 0.00
      curr_pmt_unpaid.each do |pmt|
        if pmt.parpayms.present?
          cdtn_1par += pmt.parpayms.where("upd < ?", dt).sum(:amt) 
          cdtn_1par += pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth).sum(:amt) 
        end
      end
      #CDTN_2 previous months bills paid partially this month
      cdtn_2par = 0.00
      dt_lp=dt-1.months
      while dt_lp >= stp_lp
        payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
          cdtn_2par += pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth).sum(:amt)
        end
      dt_lp -= 1.months
      end
      @bills_partial = cdtn_1par + cdtn_2par
      #END PARTIAL

      #END FOR BILLS
      @taska_plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(month from updated_at) = ?', params[:month]).where('extract(year from updated_at) = ?', params[:year])
    end
      
    respond_to do |format|
      #format.html
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="Accounting Summary.xlsx"'
      }
    end
  end

  def plrpt_xls
    @taska = Taska.find(params[:id])
    @payslips = @taska.payslips.where(year: params[:year])
    @taska_expense = @taska.expenses.where(year: params[:year]).order('month ASC')
    #START BILLS
    @taska_payments = nil
    @bill_hash = Hash.new
    @unpaid_hash = Hash.new
    @tot_par = 0.00
    @tot_unpaid = 0.00
    year = params[:year].to_i
    (1..12).each do |mth|
      dt = Time.find_zone("Singapore").local(year,mth)
      payment = @taska.payments.where.not(name: "TASKA PLAN")
      curr_pmt = payment.where(bill_month: mth).where(bill_year: year)
      curr_pmt_paid = curr_pmt.where(paid: true)
      curr_pmt_unpaid = curr_pmt.where(paid: false)
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
      #start for partial
      #CDTN_1 All partials paid this month or previous month for current month bill
      cdtn_1par = 0.00
      curr_pmt_unpaid.each do |pmt|
        if pmt.parpayms.present?
          cdtn_1par += pmt.parpayms.where("upd < ?", dt).sum(:amt) 
          cdtn_1par += pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth).sum(:amt) 
        end
      end
      #CDTN_2 previous months bills paid partially this month
      cdtn_2par = 0.00
      dt_lp=dt-1.months
      while dt_lp >= stp_lp
        payment.where(paid: false).where("bill_month = ? AND bill_year = ?", dt_lp.month, dt_lp.year).each do |pmt|
          cdtn_2par += pmt.parpayms.where('extract(year  from upd) = ?', year).where('extract(month  from upd) = ?', mth).sum(:amt)
        end
      dt_lp -= 1.months
      end
      @bills_partial = cdtn_1par + cdtn_2par
      @tot_par += @bills_partial
      @payments_dues = curr_pmt
      @unpaid_hash[mth] = @payments_dues.where(paid: false).sum(:amount) - cdtn_1par
      @tot_unpaid += @unpaid_hash[mth]
      #END PARTIAL
      @bill_hash[mth]= all_payments.where(paid: true).sum(:amount) + @bills_partial
      if @taska_payments.blank?
        @taska_payments = all_payments
      else
        @taska_payments = @taska_payments.or(all_payments)
      end
    end

    #@taska_payments = @taska.payments.where.not(name: "TASKA PLAN").where(bill_year: params[:year]) 
    #END BILLS
    @taska_plan = @taska.payments.where(name: "TASKA PLAN").where(paid: true).where('extract(year from updated_at) = ?', params[:year])  
    respond_to do |format|
      #format.html
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="Accounting Report.xlsx"'
      }
    end
  end

  # START TEACHER CLASSROOMS AND LEAVE

  def tchleave_xls
    @taska = Taska.find(params[:id])
    @tsklvs = @taska.tsklvs.order('name ASC')
    @classrooms = @taska.classrooms
    tchdid = Array.new
    @classrooms.each do |cls|
      cls.teachers.each do |tch|
        tchdid << tch.tchdetail.id
      end
    end
    @applvs = @taska.applvs.order('start DESC')
    @tchdetails = Tchdetail.where(id: tchdid).order('name ASC')
    respond_to do |format|
      #format.html
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="Teachers Report.xlsx"'
      }
    end
  end

  def tchleave
    time = Time.now
    @teacher = Teacher.find(params[:tch_id])
    @tchlvs = @teacher.tchlvs
    @tchapplvs = @teacher.applvs.where('extract(year  from start) = ?', time.year).order('start DESC')
    @tchapplvs_all = @teacher.applvs.order('start DESC')
    render action: "tchleave", layout: "dsb-admin-teacher" 
  end

  def taskateachers
    @newteachers = @taska.taska_teachers.where(stat: true)
    @classrooms = @taska.classrooms
    @applvs = @taska.applvs
    if params[:mthpsl].present? && params[:yrpsl].present?
      @tchpayslips = Payslip.where(mth: params[:mthpsl]).where(year: params[:yrpsl]).where(taska_id: @taska.id).order('created_at DESC')
    end
    render action: "taskateachers", layout: "dsb-admin-teacher" 
  end

  def tchinfo_new
    @teacher = Teacher.find(params[:tchid])
    @classroom = nil
    render action: "tchinfo_new", layout: "dsb-admin-teacher" 
  end

  def tchinfo_save
    TeachersClassroom.create(teacher_id: params[:tch][:teacher_id], classroom_id: params[:tch][:classroom_id])
    
    params[:tch][:leaves].each do |k,v|
      #render json: v  and return
      Tchlv.create(leave_params(v))
    end
    Payinfo.create(payinfo_params)
    flash[:notice] = "TEACHER SUCCESSFULLY ADDED"
    redirect_to taskateachers_path(id: params[:tch][:taska_id],
                                  tb2_a: "active",
                                  tb2_ar: "true",
                                  tb2_d: "show active")
  end

  def tchrm_cls
    @taska = Taska.find(params[:id])
    tchcls = TeachersClassroom.where(teacher_id: params[:tch], classroom_id: params[:cls]).first
    tchcls.destroy
    tchlvs = Tchlv.where(teacher_id: params[:tch])
    tchlvs.delete_all
    applvs = Applv.where(teacher_id: params[:tch])
    applvs.delete_all
    payinfos = Payinfo.where(teacher_id: params[:tch])
    payinfos.delete_all
    flash[:notice] = "TEACHER REMOVED"
    redirect_to taskateachers_path(@taska,
                                  tb3_a: "active",
                                  tb3_ar: "true",
                                  tb3_d: "show active")
  end

  def tchinfo_edit
    @teacher = Teacher.find(params[:tchid])
    @classroom = @teacher.classrooms.first.id
    render action: "tchinfo_edit", layout: "dsb-admin-teacher" 
  end

  def tchinfo_update
    teacher = Teacher.find(params[:tch][:teacher_id])
    classroom = teacher.classrooms.first
    tchcls = TeachersClassroom.where(teacher_id: teacher.id, classroom_id: classroom.id).first
    tchcls.classroom_id = params[:tch][:classroom_id]
    tchcls.save
    payinfo = Payinfo.where(taska_id: params[:tch][:taska_id], teacher_id: params[:tch][:teacher_id]).last
    params[:tch][:leaves].each do |k,v|
      #render json: v[:teacher_id]  and return
      tchlv = Tchlv.where(teacher_id: v[:teacher_id], taska_id: v[:taska_id], tsklv_id: v[:tsklv_id]).first
      tchlv.update(leave_params(v)) unless !tchlv.present?
    end
    payinfo.update(payinfo_params)
    flash[:notice] = "SUCCESSFULLY UPDATED"
    redirect_to taskateachers_path(id: params[:tch][:taska_id],
                                  tb3_a: "active",
                                  tb3_ar: "true",
                                  tb3_d: "show active")
  end

  # END TEACHER CLASSROOMS AND LEAVE

  # START TEACHER PAYSLIP
  def tchpayslip
    @teacher = Teacher.find(params[:tch_id])
    @tchpayslips = Payslip.where(taska_id: params[:id], teacher_id: params[:tch_id]).order('year DESC').order('mth DESC')
    render action: "tchpayslip", layout: "dsb-admin-teacher" 
  end

  def chkpayslip
    par = params[:payslip]
    payslip = Payslip.where(mth: par[:month], 
                            year: par[:year],
                            teacher_id: par[:teacher],
                            taska_id: par[:taska] )
    if payslip.present?
      flash[:danger] = "PAYSLIP ALREADY EXIST FOR #{$month_name[par[:month].to_i]}-#{par[:year]}"
      redirect_to tchpayslip_path(id: par[:taska], tch_id: par[:teacher])
    else
      redirect_to newpayslip_path(id: par[:taska], 
                                  tch_id: par[:teacher],
                                  month: par[:month],
                                  year: par[:year])
    end
  end

  def newpayslip
    @teacher = Teacher.find(params[:tch_id])
    @payinfo = @teacher.payinfos.where(teacher_id: params[:tch_id], taska_id: params[:id]).first
    unpaid_leave = @taska.tsklvs.where(name: "UNPAID LEAVE").first
    @tchunpaid = @teacher.applvs.where(kind: unpaid_leave.id, stat: "APPROVED").order('start ASC')
    @count = 0
    @tchunpaid.each do |lv|
      if (lv.start.month == params[:month].to_i && lv.start.year == params[:year].to_i) && (lv.end.month == params[:month].to_i && lv.end.year == params[:year].to_i)
        @count += lv.tot
      end
    end

    render action: "newpayslip", layout: "dsb-admin-teacher"
  end

  def crtpayslip
    @payslip = Payslip.new(payslip_params)
    if @payslip.save
      
      if (Rails.env.production?) && (@payslip.notf == 1)
        mth = @payslip.mth
        yr = @payslip.year
        tsk = @payslip.taska
        tch = @payslip.teacher
        tchd = tch.tchdetail
        #SEND EMAIL
        mail = SendGrid::Mail.new
        mail.from = SendGrid::Email.new(email: 'do-not-reply@kidcare.my', name: 'KidCare')
        mail.subject = "NEW PAYSLIP FOR #{$month_name[mth]}-#{yr}"
        #Personalisation, add cc
        personalization = SendGrid::Personalization.new
        personalization.add_to(SendGrid::Email.new(email: "#{tch.email}"))
        personalization.add_cc(SendGrid::Email.new(email: "#{tsk.email}"))
        mail.add_personalization(personalization)
        #add content
        msg = "<html>
                <body>
                  Hi <strong>#{tchd.name.upcase}</strong><br><br>


                  <strong>#{tsk.name.upcase}</strong> had created your payslip for <strong>#{$month_name[mth]}-#{yr}</strong>.<br>
                  <br>

                  Please login to view.<br> 

                  Many thanks for your continous support.<br><br>

                  Powered by <strong>www.kidcare.my</strong>
                </body>
              </html>"
        #sending email
        mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
        @response = sg.client.mail._('send').post(request_body: mail.to_json)
        flash[:success] = "PAYSLIP CREATION SUCCESSFULL AND NOTIFICATION EMAIL SENT TO STAFF"
      else
        flash[:success] = "PAYSLIP CREATION SUCCESSFULL"
      end   
    else
      flash[:danger] = "PAYSLIP CREATION FAILED. PLEASE TRY AGAIN"
    end
    redirect_to tchpayslip_path(id: @payslip.taska_id,
                                tch_id: @payslip.teacher_id)
  end

  def editpayslip
    @payslip = Payslip.find(params[:psl])
    @teacher = @payslip.teacher
    unpaid_leave = @taska.tsklvs.where(name: "UNPAID LEAVE").first
    @tchunpaid = @teacher.applvs.where(kind: unpaid_leave.id, stat: "APPROVED").order('start ASC')
    @count = 0
    @tchunpaid.each do |lv|
      if (lv.start.month == params[:month].to_i && lv.start.year == params[:year].to_i) && (lv.end.month == params[:month].to_i && lv.end.year == params[:year].to_i)
        @count += lv.tot
      end
    end

    render action: "editpayslip", layout: "dsb-admin-teacher"
  end

  def updpayslip
    psl = params[:payslip]
    @payslip = Payslip.where(teacher_id: psl[:teacher_id]).where(taska_id: psl[:taska_id]).where(psl_id: psl[:psl_id]).first
    if @payslip.update(payslip_params)
      if (Rails.env.production?) && (psl[:notf] == "1")
        mth = @payslip.mth
        yr = @payslip.year
        tsk = @payslip.taska
        tch = @payslip.teacher
        tchd = tch.tchdetail
        #SEND EMAIL
        mail = SendGrid::Mail.new
        mail.from = SendGrid::Email.new(email: 'do-not-reply@kidcare.my', name: 'KidCare')
        mail.subject = "NEW PAYSLIP FOR #{$month_name[mth]}-#{yr}"
        #Personalisation, add cc
        personalization = SendGrid::Personalization.new
        personalization.add_to(SendGrid::Email.new(email: "#{tch.email}"))
        personalization.add_cc(SendGrid::Email.new(email: "#{tsk.email}"))
        mail.add_personalization(personalization)
        #add content
        msg = "<html>
                <body>
                  Hi <strong>#{tchd.name.upcase}</strong><br><br>


                  <strong>#{tsk.name.upcase}</strong> had created your payslip for <strong>#{$month_name[mth]}-#{yr}</strong>.<br>
                  <br>

                  Please login to view.<br> 

                  Many thanks for your continous support.<br><br>

                  Powered by <strong>www.kidcare.my</strong>
                </body>
              </html>"
        #sending email
        mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
        @response = sg.client.mail._('send').post(request_body: mail.to_json)
        flash[:success] = "PAYSLIP UPDATE SUCCESSFULL AND NOTIFICATION EMAIL SENT TO STAFF"
      else
        flash[:success] = "PAYSLIP UPDATE SUCCESSFULL"
      end
      #redirect_to viewpsl_path(psl: @payslip.id)
    else
      flash[:danger] = "Update failed. Please try again"
      
    end
    redirect_to viewpsl_path(psl: @payslip.id)
  end

  # END TEACHER PAYSLIP

  def taskateachers_classroom
    @taskateachers = @taska.teachers
  end

  def classrooms_index
    @taska_classrooms = @taska.classrooms
    @taska_extras = @taska.extras.order('name ASC')
    render action: "classrooms_index", layout: "dsb-admin-classroom" 
  end

  def children_index
    @taska_classrooms = @taska.classrooms
  end

  # GET /taskas/new
  def new
    if params[:chg] == "1"
      redirect_to tsk_svplan_path(id: params[:id], plan: params[:plan])
    else
      @taska = Taska.new
      @taska.fotos.build
    end
  end

  # POST /taskas
  # POST /taskas.json
  def create
    @taska = Taska.new(taska_params)
    @taska.expire = Time.now + 1.months
    @taska.cred = 0.00
    # if Rails.env.development?
    #   @taska.collection_id = "andkymil"
    # elsif Rails.env.production?
    #   @taska.collection_id = "x7w_y71n"
    # end
    @taska.collection_id = $clt
    @taska.collection_id2 = $clt
    @taska.name = @taska.name.upcase
    @taska.plan = "PAY PER USE"
    if @taska.save
      taska_admin1 = TaskaAdmin.create(taska_id: @taska.id, admin_id: current_admin.id)
      # annlv = Tsklv.create(taska_id: @taska.id, 
      #                     name: "ANNUAL LEAVE",
      #                     desc: "PLEASE INSERT YOUR DESCRIPTION AND THE DEFAULT DAYS",
      #                     day: 15)
      # annlv = Tsklv.create(taska_id: @taska.id, 
      #                     name: "UNPAID LEAVE",
      #                     desc: "PLEASE INSERT YOUR DESCRIPTION AND THE DEFAULT DAYS",
      #                     day: 15)
      if current_admin != Admin.first
        taska_admin2 = TaskaAdmin.create(taska_id: @taska.id, admin_id: Admin.first.id)
      end
      flash[:notice] = "Community was successfully created"
      #redirect_to create_bill_taska_path(id: @taska)
      redirect_to admin_index_path
    else
      render :new 
      
    end  
  end

  def chgplan
    render action: "chgplan", layout: "dsb-admin-overview" 
  end

  def svplan
    old = @taska.plan
    @taska.plan = params[:plan]
    if params[:plan] == "PAY PER USE"
      kidno = 100000000
    else
      kidno = $package_child[params[:plan]]
    end
    if (curr_kid = @taska.kids.where.not(classroom_id: nil).count) > kidno
      flash[:danger] = "No of registered children with your center exceeds the #{params[:plan]} plan quota. Please choose a higher plan or Pay/Use"
      redirect_to tsk_chgplan_path(@taska, chg: 1)
    else
      # if params[:plan] == "PAY PER USE" && curr_kid > 100
      #   @taska.discount = (2.4/2.8)
      # else
        
      # end
      @taska.save
      flash[:success] = "Successfully changed from #{old} to #{params[:plan]} plan. This will be reflected in your next bill"
      redirect_to taska_path(@taska)
    end
    
  end

  # GET /taskas/1/edit
  
  

  def update_bank
    @taska = Taska.find(params[:id])
    @taska.bank_name = params[:bank_name]
    @taska.acc_name = params[:acc_name]
    @taska.acc_no = params[:acc_no]
    @taska.ssm_no = params[:ssm_no]
    if @taska.save
        flash[:success] = "Taska was successfully updated"
        redirect_to create_billplz_bank_path(id: @taska.id)
    else
        flash[:danger] = "Update unsuccessfull. Please try again"
    end
    #redirect_to edit_taska_path(@taska)

  end

  # PATCH/PUT /taskas/1
  # PATCH/PUT /taskas/1.json
  def update
    if @taska.update(taska_params)
      flash[:success] = "#{@taska.name} was successfully updated"
      #if @taska.bank_status == nil 
        #redirect_to create_billplz_bank_path(id: @taska.id)
      #else
        redirect_to taskashow_path(@taska)
      #end
      #format.html { redirect_to @taska, notice: 'Taska was successfully updated.' }
      #format.json { render :show, status: :ok, location: @taska }
    else
      flash[:success] = "Update unsuccessfull. Please try again"
      format.html { render :edit }
      #format.json { render json: @taska.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /taskas/1
  # DELETE /taskas/1.json
  def destroy
    @taska.destroy
    # respond_to do |format|
    #   format.html { redirect_to taskas_url, notice: 'Taska was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end
