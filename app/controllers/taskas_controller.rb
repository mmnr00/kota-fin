class TaskasController < ApplicationController
  before_action :set_taska, only: [:show,:children_index, :taskateachers, :taskateachers_classroom,:classrooms_index, :edit, :update, :destroy]
  before_action :set_all

  # GET /taskas
  # GET /taskas.json
  def index
    @taskas = Taska.all
  end

  def index_parent
    @parent = Parent.find(params[:id])
    @taskas = Taska.all
  end

  def taska_pricing
  end


  # GET /taskas/1

  # GET /taskas/1.json
  def show
    # ada kt bawah func set_taska
    @admin_taska = current_admin.taskas
    session[:taska_id] = @taska.id
    session[:taska_name] = @taska.name  
    render action: "show", layout: "dsb-admin-overview" 
  end

  def taskateachers
    @taskateachers = @taska.teachers

  end

  def taskateachers_classroom
    @taskateachers = @taska.teachers
  end

  def classrooms_index
    @unregistered_kids = @taska.kids.where(classroom_id: nil).order('name ASC')
    @taska_classrooms = @taska.classrooms
    render action: "classrooms_index", layout: "dsb-admin-classroom" 
  end

  def children_index
    @taska_classrooms = @taska.classrooms
  end

  # GET /taskas/new
  def new
    @taska = Taska.new
    @taska.fotos.build
  end

  # GET /taskas/1/edit
  def edit
  end

  # POST /taskas
  # POST /taskas.json
  def create
    @taska = Taska.new(taska_params)

    
      if @taska.save
        taska_admin1 = TaskaAdmin.create(taska_id: @taska.id, admin_id: current_admin.id)
        taska_admin2 = TaskaAdmin.create(taska_id: @taska.id, admin_id: Admin.first.id)
        flash[:notice] = "Taska was successfully created"
        redirect_to create_bill_taska_path(id: @taska.id)
      else
        render :new 
        
      end
    
  end

  # PATCH/PUT /taskas/1
  # PATCH/PUT /taskas/1.json
  def update
    respond_to do |format|
      if @taska.update(taska_params)
        format.html { redirect_to @taska, notice: 'Taska was successfully updated.' }
        format.json { render :show, status: :ok, location: @taska }
      else
        format.html { render :edit }
        format.json { render json: @taska.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taskas/1
  # DELETE /taskas/1.json
  def destroy
    @taska.destroy
    respond_to do |format|
      format.html { redirect_to taskas_url, notice: 'Taska was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_taska
      @taska = Taska.find(params[:id])
    end

    def set_all
    @teacher = current_teacher
    @parent = current_parent
    @admin = current_admin  
    @owner = current_owner
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
                                    fotos_attributes: [:foto, :picture, :foto_name]  )
    end
end
