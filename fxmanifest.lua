fx_version 'cerulean'
game 'gta5'

description 'bbv-spinthebottle'
version '1.0.0'

ox_lib 'locale'

client_scripts {
    'wrapper/cl_wrapper.lua',
    'client/cl_main.lua',
}

server_scripts {
    'server/sv_main.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config.lua',
}

files {
    'locales/*.json'
}


dependencies {
    'ox_lib',
}




lua54 'yes'

