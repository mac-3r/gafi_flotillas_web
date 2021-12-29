class ResponsablesController < ApplicationController
  before_action :set_responsable, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /responsables
  # GET /responsables.json
  def index
    keyword = "#{params[:keyword]}"
    if keyword !=""
      @responsables = Responsable.where("nombre LIKE '%#{keyword}%'").order(nombre: :asc)
    else
      @responsables = Responsable.all.order(nombre: :asc)
    end 
  end

  # GET /responsables/1
  # GET /responsables/1.json
  def show
  end

  # GET /responsables/new
  def new
    @responsable = Responsable.new
  end

  # GET /responsables/1/edit
  def edit
  end

  # POST /responsables
  # POST /responsables.json
  def create
    begin
      @responsable = Responsable.new(responsable_params)
      if !params[:responsable][:status].present?
        @responsable.status = false
        end
        id_personal = @responsable.catalog_personal_id
        busqueda = CatalogPersonal.find_by(id: id_personal)
        @responsable.update(nombre:busqueda.nombre)
      respond_to do |format|
        if @responsable.save
          format.html { redirect_to responsables_path, notice: 'El responsable se creo con éxito.' }
          format.json { render :show, status: :created, location: @responsable }
        else
          format.html { render :new }
          format.json { render json: @responsable.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to responsables_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /responsables/1
  # PATCH/PUT /responsables/1.json
  def update
    begin
      if !params[:responsable][:status].present?
        params[:responsable][:status] = false
        else
        params[:responsable][:status] = true
        end
        id_personal = params[:responsable][:catalog_personal_id]
        busqueda = CatalogPersonal.find_by(id: id_personal)
        @responsable.update(nombre:busqueda.nombre)
        #byebug
      respond_to do |format|
        if @responsable.update(responsable_params)
          format.html { redirect_to responsables_path, notice: 'Responsable was successfully updated.' }
          format.json { render :show, status: :ok, location: @responsable }
        else
          format.html { render :edit }
          format.json { render json: @responsable.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to responsables_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /responsables/1
  # DELETE /responsables/1.json
  def destroy
    @responsable.destroy
    respond_to do |format|
      format.html { redirect_to responsables_url, notice: 'Responsable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_responsable
      @responsable = Responsable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def responsable_params
      params.require(:responsable).permit(:nombre, :status,:catalog_personal_id)
    end
    def invalid_foreign_key
      redirect_to responsables_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
