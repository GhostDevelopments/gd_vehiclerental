fx_version "cerulean"
game "gta5"

author "Ghost Developments"
description "A Simple Rental Script For The Qbox Framwork"
version "1.0.0"

ui_page "html/ui.html"

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua"
}

client_scripts {
    "client/main.lua"
}

server_scripts {
    "server/main.lua"
}

files {
    "html/ui.html",
    "html/script.js"
}