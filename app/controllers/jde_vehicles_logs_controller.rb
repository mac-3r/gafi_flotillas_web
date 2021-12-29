class JdeVehiclesLogsController < ApplicationController
  
  def index
    @logs = JdeVehiclesLog.all.order(fecha: :desc)
  end
end
