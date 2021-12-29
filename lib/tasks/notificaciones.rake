namespace :notificaciones do
	task correo_siniestros_x_mes: :environment do
		VehicleIndicator.correo_siniestros_x_mes
	end
	task cantidad_siniestros_x_cedis: :environment do
		VehicleIndicator.cantidad_siniestros_x_cedis
	end 
	task cantidad_siniestros_x_responsable: :environment do
		VehicleIndicator.cantidad_siniestros_x_responsable
	end 
	task correo_monto_siniestros_x_mes: :environment do
		VehicleIndicator.correo_monto_siniestros_x_mes
	end
	task licencias_x_expirar: :environment do
		CatalogLicence.envio_correo_licencias_expirar
	end
end
