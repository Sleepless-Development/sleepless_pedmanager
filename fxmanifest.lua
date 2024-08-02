fx_version "cerulean"
game 'gta5'
lua54 'yes'

version '1.2.9'

files {
    "data.lua"
}

shared_script "@ox_lib/init.lua"
client_script "client/**/*"
server_script "server/**/*"