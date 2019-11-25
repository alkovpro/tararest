#!/usr/bin/env tarantool
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by alkov.
--- DateTime: 22.11.2019 17:00
---

local log = require('log')

log.info('Starting App...')

box.cfg {}
box.once('schema', function()
    local data = box.schema.create_space('data')
    data:format({
        {name = 'key', type = 'string'},
        {name = 'value', type = 'map'},
    })
    data:create_index('primary', {parts = {{field = 1, type ='str', collation='unicode_ci'}}})

    --local counter = box.schema.create_space('counter')
    --counter:format({
    --    {name = 'name', type = 'string'},
    --    {name = 'value', type = 'int'},
    --})
    --counter:create_index('primary', {parts = {{field = 1, type ='str'}}})
end)

local rest = require('app.rest')
local httpd = require('http.server')
local server = httpd.new('127.0.0.1', 8080, {
    log_requests = true,
    log_errors = true
})

server:set_router(rest.router)

server:start()