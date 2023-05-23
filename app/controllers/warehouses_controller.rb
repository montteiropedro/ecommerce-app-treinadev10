class WarehousesController < ApplicationController
  def index
    @warehouses = Warehouse.all
  end

  def show
    @warehouse = Warehouse.find(params[:id])

    return unless @warehouse.blank?

    redirect_to root_path, notice: 'Não foi possível carregar o galpão.' 
  end
end
