class JdeLogsController < ApplicationController
  before_action :set_jde_log, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /jde_logs
  # GET /jde_logs.json
  def index
    @jde_logs = JdeLog.all.order(created_at: :desc)
  end

  # GET /jde_logs/1
  # GET /jde_logs/1.json
  def show
  end

  # GET /jde_logs/new
  def new
    @jde_log = JdeLog.new
  end

  # GET /jde_logs/1/edit
  def edit
  end

  # POST /jde_logs
  # POST /jde_logs.json
  def create
    @jde_log = JdeLog.new(jde_log_params)

    respond_to do |format|
      if @jde_log.save
        format.html { redirect_to @jde_log, notice: 'Jde log was successfully created.' }
        format.json { render :show, status: :created, location: @jde_log }
      else
        format.html { render :new }
        format.json { render json: @jde_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jde_logs/1
  # PATCH/PUT /jde_logs/1.json
  def update
    respond_to do |format|
      if @jde_log.update(jde_log_params)
        format.html { redirect_to @jde_log, notice: 'Jde log was successfully updated.' }
        format.json { render :show, status: :ok, location: @jde_log }
      else
        format.html { render :edit }
        format.json { render json: @jde_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jde_logs/1
  # DELETE /jde_logs/1.json
  def destroy
    @jde_log.destroy
    respond_to do |format|
      format.html { redirect_to jde_logs_url, notice: 'Jde log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Bitácora de pólizas"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_jde_log
      @jde_log = JdeLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jde_log_params
      params.require(:jde_log).permit(:fecha, :hora, :json_enviado, :respuesta)
    end
end
