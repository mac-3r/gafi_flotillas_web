class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /sections
  # GET /sections.json
  def index
    @sections = Section.all.order(nombre: :asc)
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  def asignar_area

  end
  def guardar_area
    busqueda = CatalogAreasSection.find_by(catalog_area_id:params[:catalog_area_id] )
    #byebug
    if busqueda
      flash[:alert] = "Esta área ya ha sido asignada."
      redirect_to sections_path
    else
      asignar = CatalogAreasSection.new(catalog_area_id:params[:catalog_area_id],section_id:params[:id])
      if asignar.save
        flash[:notice] = "Área asignada con éxito."
        redirect_to sections_path
      else
        asignar.errors.full_messages.each do |error|
          #byebug
          flash[:alert] = "Ocurrio un error."
          redirect_to sections_path
        end
      end
    end
  end

  def ver_areas
    @areas= CatalogAreasSection.where(section_id:params[:id])
    #byebug
  end

  def borrar_area
			area = CatalogArea.find_by(id: params[:id_area])
      seccion = Section.find_by(id: params[:id_section])
      #byebug
			are_sec = CatalogAreasSection.where(catalog_area_id: params[:id_area], section_id: params[:id_section])
			if area.sections.delete(seccion)
        flash[:notice] = "Área eliminada con éxito."
        redirect_to sections_path
			else
				are_sec.errors.full_messages.each do |error|
          flash[:false] = error
          redirect_to sections_path          
				end
			end
    #byebug
  end
  # POST /sections
  # POST /sections.json
  def create
    begin
      @section = Section.new(section_params)
      if !params[:section][:status].present?
        @section.status = false
      end
      respond_to do |format|
        if @section.save
          format.html { redirect_to sections_path, notice: 'Sección creada con éxito.' }
          format.json { render :show, status: :created, location: @section }
        else
          format.html { render :new }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to sections_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    begin
      if !params[:section][:status].present?
        params[:section][:status] = false
      else
        params[:section][:status] = true
      end
      respond_to do |format|
        if @section.update(section_params)
          format.html { redirect_to sections_path, notice: 'Sección actualizada con exito.' }
          format.json { render :show, status: :ok, location: @section }
        else
          format.html { render :edit }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      end  
    rescue => exception
      redirect_to sections_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Se eliminó la sección con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def section_params
      params.require(:section).permit(:nombre, :status)
    end
end
