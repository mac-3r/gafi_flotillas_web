class CatalogResponsivesController < ApplicationController
  before_action :set_catalog_responsife, only: [:show, :edit, :update, :destroy]

  # GET /catalog_responsives
  # GET /catalog_responsives.json
  def index
    @catalog_responsives = CatalogResponsife.all
  end

  # GET /catalog_responsives/1
  # GET /catalog_responsives/1.json
  def show
  end

  # GET /catalog_responsives/new
  def new
    @catalog_responsife = CatalogResponsife.new
  end

  # GET /catalog_responsives/1/edit
  def edit
  end

  # POST /catalog_responsives
  # POST /catalog_responsives.json
  def create
    @catalog_responsife = CatalogResponsife.new(catalog_responsife_params)
    params[:catalog_responsife][:catalog_branch_id] = params[:catalog_responsife][:catalog_branch_id]
    params[:catalog_responsife][:catalog_personal_id] = params[:catalog_responsife][:catalog_personal_id]
    params[:catalog_responsife][:catalog_area_id] = params[:catalog_responsife][:catalog_area_id]
    if !params[:catalog_responsife][:status].present?
      @catalog_responsife.status = false
      end
    respond_to do |format|
      if @catalog_responsife.save
        format.html { redirect_to @catalog_responsife, notice: 'La resposiva se creó con exito.' }
        format.json { render :show, status: :created, location: @catalog_responsife }
      else
        format.html { render :new }
        format.json { render json: @catalog_responsife.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalog_responsives/1
  # PATCH/PUT /catalog_responsives/1.json
  def update
    if !params[:catalog_responsife][:status].present?
      params[:catalog_responsife][:status] = false
      else
      params[:catalog_responsife][:status] = true
      end
    respond_to do |format|
      if @catalog_responsife.update(catalog_responsife_params)
        format.html { redirect_to @catalog_responsife, notice: 'La responsiva se actualizó con exito.' }
        format.json { render :show, status: :ok, location: @catalog_responsife }
      else
        format.html { render :edit }
        format.json { render json: @catalog_responsife.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalog_responsives/1
  # DELETE /catalog_responsives/1.json
  def destroy
    @catalog_responsife.destroy
    respond_to do |format|
      format.html { redirect_to catalog_responsives_url, notice: 'La responsiva se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_responsife
      @catalog_responsife = CatalogResponsife.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_responsife_params
      params.require(:catalog_responsife).permit(:catalog_branch_id, :catalog_personal_id, :catalog_area_id, :correo, :status)
    end
end
