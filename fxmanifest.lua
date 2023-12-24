fx_version "cerulean"
game 'gta5'
lua54 'yes'

version '2.0.0'

ui_page 'web/build/index.html'

shared_script "@ox_lib/init.lua"
client_script "client/**/*"
server_script "server/**/*"

files {
	'web/build/index.html',
	'web/build/**/*',
}