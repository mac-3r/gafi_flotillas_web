set :output, "log/cron_log.log"
env :PATH, ENV['PATH']
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
every 2.minutes do
#every 1.day, :at => '8:00 am' do
    rake "notificaciones:correo_siniestros_x_mes"
end

every 2.minutes do
#every 1.day, :at => '8:00 am' do
    rake "notificaciones:cantidad_siniestros_x_cedis"
end

every 2.minutes do
#every 1.day, :at => '8:00 am' do
    rake "notificaciones:cantidad_siniestros_x_responsable"
end

every 2.minutes do
#every 1.day, :at => '8:00 am' do
    rake "notificaciones:correo_monto_siniestros_x_mes"
end

every 2.minutes do
#every 1.day, :at => '8:00 am' do
    rake "notificaciones:licencias_x_expirar"
end
# Learn more: http://github.com/javan/whenever
