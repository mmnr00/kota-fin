class TaskasController < ApplicationController
  before_action :set_taska, only: [:show, :taskateachers, :taskateachers_classroom,:classrooms_index, :edit, :update, :destroy]

  # GET /taskas
  # GET /taskas.json
  def index
    @taskas = Taska.all
  end

  # GET /taskas/1

  # GET /taskas/1.json
  def show
    # ada kt bawah func set_taska
    @admin_taska = current_admin.taskas
    session[:taska_id] = @taska.id
    session[:taska_name] = @taska.name   
  end

  def taskateachers
    @taskateachers = @taska.teachers

  end

  def taskateachers_classroom
    @taskateachers = @taska.teachers
  end

  def classrooms_index
    @taska_classrooms = @taska.classrooms
  end

  # GET /taskas/new
  def new
    @taska = Taska.new
  end

  # GET /taskas/1/edit
  def edit
  end

  # POST /taskas
  # POST /taskas.json
  def create
    @taska = Taska.new(taska_params)

    respond_to do |format|
      if @taska.save
        format.html { redirect_to @taska, notice: 'Taska was successfully created.' }
        format.json { render :show, status: :created, location: @taska }
      else
        format.html { render :new }
        format.json { render json: @taska.errors, status: :unprocessable_entity }
      end
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def taska_params
      params.fetch(:taska, {})
    end
end
