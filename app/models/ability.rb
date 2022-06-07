# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #

      s_admin = 0
      if user.catalog_roles.count > 0      
        user.catalog_roles.each do |rol|
          if rol.nombre == "Superadministrador"
            s_admin = 1
            break
          end      
        end
      end
  
      if user.user == "admin" || s_admin == 1 
        can :manage, :all
      else
          user.permissions.each do |permiso|
            #byebug
            begin
              if permiso.clase_id.nil?
                can permiso.accion.to_sym, permiso.clase.constantize
              else
                can permiso.accion.to_sym, permiso.clase.constantize, :id => permiso.clase_id
              end
            rescue
              can permiso.accion.to_sym, permiso.clase.to_sym
            end
            #puts "-------------------------------" +permiso.accion.to_sym.to_s + " " + permiso.clase.to_s
          end
      end

    
    # Combustible -------------------------------------------------

    # Consumo por vehículos
    alias_action :index,:filtrado_cargas, :show, to: :ver_index_consumo_vehiculos
    alias_action :index, :show, :import_consumption, :template_download_consumption, to: :subir_carga_consumos
    alias_action :documentos_factura, :cargar_factura, :descargar_factura, to: :cargar_facturas_consumos
    alias_action :documentos_pdf, :descargar_pdf, :cargar_pdf, to: :cargar_pdf_consumos
    alias_action :generar_reporte,to: :generar_consumo
    alias_action :edit,:update, to: :editar_impuestos
    alias_action :imprimir_solicitud, :consumo_excel, :solicitar_autorizacion, :solicitar_autorizacion8, :solicitar_autorizacion16, to: :solicitud_consumo
    alias_action :borrar_carga,to: :borrrar_cargas_combustible
    alias_action :modal_cambio_usuario,:editar_usuario_aut, to: :cambio_usuario_combustible
    # Solicitudes autorizadas

    alias_action :indice_solicitud, :busqueda_solicitud, :ver_solicitud,:documentos_pdf, :descargar_pdf, :cargar_pdf,:generar_reporte, :imprimir_solicitud, :consumo_excel, :solicitar_autorizacion, :solicitar_autorizacion8, :solicitar_autorizacion16, to: :ver_index_solicitudes_aut

    # Reporte de control de combustible acumulado
    alias_action :reporte_acumulado,:filtrado_acumulado_combustible, :detalle, :generar_excel_acumulado, to: :reportes_combustible_acumulado

    # Reporte de rendimiento mensual de reparto
    alias_action :reporte_mensual,:rendimiento_excel, to: :index_rendimiento_mensual_reparto

    # Indicador vehículos dentro de rendimiento
    alias_action :indicador_rendimiento, :filtrado_indicadores, to: :indicador_vehiculos_dentro_rendimiento

    # Indicador vehículos fuera de presupuesto
    alias_action :indicador_presupuesto, :filtrado_acumulado, to: :indicador_vehiculos_fuera_presupuesto
    
    # Indicador vehículos dentro del objetivo del gasto por km
    alias_action :indicador_km, :filtrado_km, to: :indicador_vehiculos_objetivo_gasto
    alias_action :indice_solicitud, :show, to: :ver_index_solicitudes_aut

    #maestro de vehiculos
    alias_action :new,:create,:import_vehicles,:template_download_vehicles,:cancelar_compra,:edit,:update, to: :compra_vehiculos
    alias_action :edit,:update, to: :editar_vehiculos
    alias_action :import_vehicles, :plantilla_maestro_vehiculo_completa, :importar_maestro_vehiculos, :plantilla_carta_porte, to: :importar_vehiculos
    alias_action :destroy, to: :eliminar_vehiculos
    alias_action :show, :ver_documentos,:document_detail,:uploads, :vehicle_files, :upload_document, :destroy_vehicle_file, to: :expediente_vehiculo
    alias_action :venta,:registrar_encabezado,:guardar_encabezado,:registrar_costos,:guardar_costos,:registrar_mantenimiento,:guardar_mantenimiento,:solicitar_venta,:imprimir_formato_venta,:cancelar_venta, to: :venta_vehiculos
    alias_action :listado_checklist,:detalle_checklist, to: :checklist_vehiculos
    #orden de compra
    alias_action :index,:filtrado_ordenes, to: :orden_compra
    alias_action :nueva_orden,:crear_orden,:formulario_agregar_detalle_orden,:guardar_detalle_orden,:edit,:update,:eliminar_partida_orden, to: :crear_orden_compra
    alias_action :documentos_orden,:factura_orden,:cargar_factura_orden,:cargar_documento_orden, to: :adjuntar_documento
    alias_action :imprimir_orden,:show,to: :generar_pdf_orden
    #presupuestos
    # alias_action :index,:show,:imprimir_pres, to: :ver_presupuesto_venta
    # alias_action :solicitar_presupuesto_venta, to: :solicitar_autorizacion_presupuesto_venta
    # alias_action :nuevo_presupuesto, :crear_presupuesto,:edit,:update,:eliminar_partida,:formulario_agregar_detalle,:guardar_detalle, to: :presupuestos_venta
    # alias_action :index, :show,:imprimir_ad, to: :ver_presupuesto_administracion
    # alias_action :solicitar_presupuesto_admin, to: :solicitar_autorizacion_presupuesto_administracion
    # alias_action :nuevo_presupuesto_admin,:crear_presupuesto_admin,:formulario_agregar_detalle_admin,:guardar_detalle_admin,:edit,:eliminar_partida_admin,:update,:solicitar_presupuesto_admin, to: :presupuestos_administracion
    # alias_action :index, :show,:imprimir, to: :ver_presupuesto_reparto
    # alias_action :solicitar_presupuesto_reparto, to: :solicitar_autorizacion_presupuesto_reparto
    # alias_action :nuevo_pres_reparto,:crear_presupuesto_reparto,:guardar_detalle_reparto,:formulario_agregar_detalle_reparto,:edit,:eliminar_partida_reparto,:update,:solicitar_presupuesto_reparto, to: :presupuestos_reparto
    # alias_action :borrar_presupuesto_admin, to: :eliminar_pres_admin
    # alias_action :borrar_presupuesto_venta, to: :eliminar_pres_venta
    # alias_action :destroy, to: :eliminar_pres_dis

    alias_action :index, :show, to: :ver_presupuestos
    alias_action :index, :show, :new, :create, :edit, :add_item_budget, :save_item_budget, :update, :destroy, to: :registrar_presupuestos
    alias_action :index, :show, :request_budget, to: :solicitar_autorizacion_presupuestos

    #seguridad
    alias_action :index, :create_new_user, :update,:ajax_seguridad_add_roles,:desactivar_usuario,:ajax_seguridad_permisos,:ajax_seguridad_add_permisos, to: :crear_usuarios
    alias_action :index, :new, :edit,:create,:update,:destroy,:assign_permissions, to: :crear_roles
    alias_action :index, :modal_asignar_rol, :eliminar_rol_asignado,:asignar_rol,:recarga_datatable_rol_usuario,:filtrado_usuarios_rol, to: :roles_usuarios
    alias_action :index,:recarga_datatable_cedis_usuario,:asignar_rol,:eliminar_rol_asignado,:modal_asignar_rol,:filtrado_usuarios_cedis, to: :asignacion_cedis_usuarios
    alias_action :modal_cambio_factura,:editar_factura,:modal_cambio_factura_adaptacion,:editar_factura_adaptacion,to: :cambiar_folios_facturas
    #mantenimiento
    alias_action :index,:filtrado_historico, :new,:show, to: :ver_control_mantenimiento
    alias_action :create,:edit,:update,:destroy, to: :control_mantenimiento
    alias_action :binnacle, to: :ver_bitacora_mantenimiento
    #alias_action :nuevo_mantenimiento,:crear_mantenimiento,:edit,:formulario_agregar_mantenimiento_detalle,:edit,:guardar_detalle_mantenimiento,:eliminar_detalle,:update, to: :bitacora_mantenimiento
    alias_action :index,:filtrado_seguimiento, to: :seguimiento_kilometraje
    alias_action :index,:filtrado_programa,:edit,:update, to: :programa_mmto
    #tickets
    alias_action :index,:filtrado_tickets,to: :ver_tickets_mmto
    alias_action :edit,:update ,to: :editar_ticket_mmto
    alias_action :autorizar_ticket,:rechazar_ticket,:crear_orden_ticket,:guardar_orden_ticket, to: :autorizacion_tickets_mmto
    #citas (mantenimiento)
    alias_action :index,:filtrado_citas,:show, to: :ver_citas
    #orden de servicio
    alias_action :asignar_taller,:guardar_taller,:consulta_taller, to: :asignacion_taller
    alias_action :index,:show,:filtrado_ordenes_servicio, to: :orden_servicio
    alias_action :edit,:update, to: :agregar_descripcion
    alias_action :autorizar_orden,:autorizar_cotizacion,:rechazar_cotizacion,:cancelar_orden,:asignar_taller,:guardar_taller,:consulta_taller, to: :autorizar_orden_servicio
    alias_action :registrar_salida,:guardar_fecha_salida, to: :registrar_salida_ordenes
    alias_action :factura_servicio_orden,:cargar_factura_servicio,:pdf_orden,:cargar_pdf_orden, to: :adjuntar_documentos_orden
    alias_action :registrar_servicio, to: :ver_servicios_adicionales
    alias_action :registrar_servicio,:guardar_servicio,:solicitar_servicio, to: :solicitar_servicios_adicionales
    alias_action :autorizar_servicio_adicional,:rechazar_servicio_adicional, to: :autorizacion_servicios_adicionales
    alias_action :reagendar_orden, to: :cambiar_fecha_mmto
    alias_action :finalizar_servicio,:registrar_control, to: :finalizar_orden_servicio
    #cotizaciones mmto
    alias_action :crear_cotizacion,:detalle_cotizacion,:guardar_detalle_cotizacion,:solicitar_cotizacion, to: :creacion_cotizaciones
    alias_action :ver_cotizacion,to: :cotizacion_detalle
    #indicadores  y reportes mantenimiento
    alias_action :indicador_horas_taller,:filtrado_horas,to: :indicador_taller_hrs
    alias_action :indicador_costo_mantemiento,:filtrado_costos, to: :indicador_costo_mmto
    alias_action :reporte_presupuesto_mantenimiento,:filtrado_pres_mant, to: :reporte_pres_mantenimiento
    alias_action :indicador_respuestas_taller,:filtrado_respuestas,to: :indicador_respuestas
    #siniestralidad
    alias_action :index,:filtrado_tickets_aseguradora,:reporte_tickets_siniestrabilidad_excel,:show, to: :ver_tablero_siniestralidad
    alias_action :new, :create,:consulta_vehiculo_serie, to: :crear_registros_siniestralidad
    alias_action :edit,:update,:consulta_vehiculo_serie, to: :editar_registros_siniestralidad
    alias_action :destroy, to: :eliminar_registros_siniestralidad
    alias_action :generar_ticket_siniestrabilidad, to: :generar_ticket
    alias_action :corte_ticket, to: :realizar_corte
    alias_action :index,:filtrado_incidentes,:excel_incidentes,:excel_1_incidentes,:excel_2_incidentes,:excel_3_incidentes, to: :reporte_siniestralidad
    alias_action :index,:filtro_informe_sin,:filtro_informe_sin_comparativo,:excel_informe_sin,:excel_informe_sin_com,:abrir_modal_comparativo_informe,:abrir_modal_prima,:registrar_prima_inf,to: :informe_siniestralidad
    alias_action :filtrado_indicadores_daniado,:indicadores_porcentaje_excel,:index,to: :indicador_flotillas_siniestrada
    alias_action :filtrado_indicadores_monto,:indicadores_monto_excel,:index,to: :indicador_monto_siniestrada
    alias_action :filtrado_indicadores_porcentaje,:indicadores_porcentaje_excel,:index,to: :indicador_porcentaje_siniestrada
    alias_action :claims_branch_indicator,:filtrado_indicadores_cedis,to: :indicador_cedis
    #reportes
    alias_action :reporte_responsivas,:reporte_responsivas_detalle,:reporte,:generar_excel_responsivas,:reasignar_responsables_modal,:reasignar_responsable, to: :reporte_acumulado_responsivas
    #certificacion de talleres
    alias_action :index,:show, to: :ver_cetificacion_talleres
    alias_action :edit,:update,to: :editar_cerficacion_talleres
    alias_action :fotos_taller,:cargar_fotos_taller,:caratulas_taller,:cargar_caratulas_taller,:constancia_taller,:cargar_constancia_taller,:rfc_taller,:cargar_rfc_taller,:comprobante_taller,:cargar_comprobante_taller, to: :adjuntar_documentos_taller
    alias_action :imprimir_formato_alta, to: :imp_formato_alta
    #adaptaciones 
    alias_action :agregar_adaptaciones,:guardar_adaptaciones, to: :adaptaciones_vehiculos
    alias_action :solicitar_adaptacion, to: :sol_adaptacion
    alias_action :factura_adaptacion,:cargar_factura_adaptacion,:pdf_adaptacion,:cargar_pdf_adaptacion, to: :adjuntar_documento_adaptacion

    #tickets llantas y baterias 
    alias_action :index,:ver_fotos, to: :ver_tablero_ticket_compra
    alias_action :autorizar_compra_ticket,:rechazar_compra_ticket,:agregar_motivo_rechazo, to: :autorizacion_ticket_compra
    alias_action :crear_orden_compra,:generar_orden,to: :orden_ticket
    #categorias
    alias_action :index,:ver_conceptos,:modal_nva_categoria,:modal_editar_categoria,:guardar_categoria,:editar_categoria,:eliminar_categoria,:asignar_categorias, to: :catalogo_categorias_mmto
    alias_action :descargar_plantilla_categorias,:importar_categorias,:plantilla_frecuencias, to: :importar_categorias_mmto
    #conceptos
    alias_action :index_conceptos,:modal_nvo_concepto,:modal_editar_concepto,:guardar_concepto,:editar_concepto,:eliminar_concepto,:asignar_servicios,:ver_servicio,to: :catalogo_conceptos_mmto
    alias_action :assign_concept_brand,:save_actions_brand, to: :asignacion_accion_linea
    alias_action :importar_conceptos,:descargar_plantilla_conceptos, to: :importar_conceptos_mmto
    #importar bitacora
    alias_action :importar_bitacora_mantenimiento,:plantilla_frecuencias, to: :importar_bitacora_mmto
    #bitacora
    alias_action :binnacles_index,:mostrar_bitacora,:update_binnacle,:editar_bitacora, to: :index_bitacora
    #catalogos
    alias_action :index, :new, :create,:edit,:update,:destroy, :modal_crear, :modal_editar, :asignacion_tasa_cedis, :eliminar_tasa_cedis, to: :administrar_tasas
    alias_action :index, :new, :create,:edit,:update,:destroy,:filtrado_centros, to: :catalogo_centro_costos
    alias_action :index, to: :catalogo_proveedores
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_beneficiarios
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_cobertura_polizas
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_empresas_facturables
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_reparaciones
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_estatus_vehiculos
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_tipo_vehiculos
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_estados_plaqueo
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_rutas
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_tipo_orden_servicio
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_empresas
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_lineas
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_modelos
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_asiganacion_vehiculos
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_cedis
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_personal
    alias_action :index, :new, :create,:edit,:update,:destroy,:show,:filtrado_licencias, to: :catalogo_licencias
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_checklist_vehiculos
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_permisos
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_adaptaciones
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_presupueto_combustible
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_tipo_siniestro
    alias_action :index, :new, :create,:edit,:update,:destroy,:filtrado_afectaciones, to: :catalogo_afeccion_contable
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_inidicadores_entrega
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_objetivo_rendimiento
    alias_action :index, :new, :create,:edit,:update,:destroy,:filtrado_competencias, to: :catalogo_tabla_competencias
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_areas
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_responsables
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_motivos
    alias_action :index, to: :catalogo_clientes
    alias_action :index, to: :catalogo_direcciones_entrega
    alias_action :index, :new, :create,:edit,:update,:destroy,:filtrado_talleres, to: :catalogo_talleres
    alias_action :index, :new, :create,:edit,:update,:destroy,:filtrado_precios, to: :catalogo_lista_precios
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_objetivo_gastos
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_consideraciones_fisicas
    alias_action :index, :new, :create,:edit,:update,:destroy, to: :catalogo_revision_mecanica
    alias_action :index,:new,:create,:edit,:update,:destroy, to: :catalogo_revision_talleres
    alias_action :index,:new,:create,:edit,:update,:destroy,:filtrado_frecuencias, to: :catalogo_frecuencia_mantenimiento
    alias_action :index,:new,:create,:edit,:update,:destroy,:filtrado_llantas, to: :catalogo_llantas_baterias
    alias_action :index,:new,:create,:edit,:update,:destroy, to: :catalogo_respuestas
    alias_action :index,:new,:create,:edit,:update,:destroy, to: :catalogo_preguntas
    alias_action :index,:new,:create,:edit,:update,:destroy, to: :catalogo_servicios
    alias_action :index,:new,:create,:edit,:update,:destroy, to: :cortes_gastos

    alias_action :index,:new,:create,:edit,:update,:destroy,:asignar_area,:guardar_area,:ver_areas,:borrar_area, to: :catalogo_secciones_areas

    alias_action :index, :autorizar, :modal_rechazar, :rechazar_orden_compra, to: :autorizacion_ordenes_compra
    
    alias_action :ejecutar_mantenimiento, to: :ejecutar_programa_mantenimiento
    #bitacoras
    alias_action :index, to: :bitacora_vehiculos
    alias_action :index,to: :bitacora_polizas



    # Reporte de licencias por expirar
    alias_action :index, :filtrado_licencias_expirar, :excel_licencias_expirar, to: :reporte_licencias_expirar

    # Almacenes
    alias_action :index, :modal_crear, :modal_editar, :create, :update, :destroy, to: :administrar_almacenes


    # Vehículos
    alias_action :vehicle_expenses, :gastos_vehiculo_x_fecha, to: :ver_gastos_maestro_vehiculos


    alias_action :vehicle_receive_data, :registrar_checklist_vehiculo,  to: :show_vehicle_receive 

    alias_action :assign_vehicle_data, :register_assign_vehicle,  to: :show_assign_vehicle 

    alias_action :assigned_vehicle_data, :register_assigned_vehicle,  to: :show_assigned_vehicle 

    alias_action :vehicle_verification_data, :register_verification,  to: :show_vehicles_verification 
    
    alias_action :index,  to: :show_vehicle_consumptions 

    alias_action :solicitud_pago, to: :show_vehicle_consumptions

    















 
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
