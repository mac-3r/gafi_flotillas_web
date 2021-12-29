class VehicleConsumptionsMailer < ApplicationMailer

  def solicitud_pago(user,id)
    #funciones del reporte
    @encabezado = Consumption.find_by(id: id)
    @monto = VehicleConsumption.joins(:consumption).where(consumptions: {catalog_branch_id:@encabezado.catalog_branch_id,catalog_vendor_id:@encabezado.catalog_vendor_id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
    @competencia = CompetitionTable.where("catalog_branch_id = #{@encabezado.catalog_branch_id} and monto >= #{@monto} and tipo = 'Combustible'").order(monto: :asc)
    @monto_competencia = @competencia.first
    #envia correo al email del gerente
    mail(to: user.email, subject: 'Solicitud de pago de combustible', cc: "no_replay_flotillas@gafi.com.mx")
  end

  def mail_no_personal(arreglo, sucursal)
    rol = CatalogRole.find_by(clave: "4")
    usuarios = CatalogPersonal.joins(:user).joins(user: [:catalog_branches_users]).joins(user: [:catalog_roles_users]).where(catalog_branches_users: {catalog_branch_id: sucursal}, catalog_roles_users: {catalog_role_id: rol.id})
    @arreglo_usuarios = arreglo
    mail(to: usuarios.map{|x| x.correo}, subject: 'Error con responsables en programa de mantenimiento', cc: "no_replay_flotillas@gafi.com.mx")
  end
  
  def mail_no_usuario(arreglo, sucursal)
    rol = CatalogRole.find_by(clave: "4")
    usuarios = CatalogPersonal.joins(:user).joins(user: [:catalog_branches_users]).joins(user: [:catalog_roles_users]).where(catalog_branches_users: {catalog_branch_id: sucursal}, catalog_roles_users: {catalog_role_id: rol.id})
    @arreglo_usuarios = arreglo
    mail(to: usuarios.map{|x| x.correo}, subject: 'Error con usuarios en programa de mantenimiento', cc: "no_replay_flotillas@gafi.com.mx")
  end
end
