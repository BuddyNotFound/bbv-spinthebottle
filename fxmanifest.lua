fx_version 'cerulean'
game 'gta5'

description 'bbv-spinthebottle'
version '1.0.0'

client_scripts {
    'wrapper/cl_wrapper.lua',
    'client/cl_main.lua',
}

server_scripts {
    'server/sv_main.lua',
}

shared_scripts {
    'config.lua',
}


lua54 'yes'

