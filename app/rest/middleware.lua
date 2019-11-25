---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by al-kov.
--- DateTime: 25.11.2019 04:51
---

local tsgi = require('http.tsgi')
local response = require('http.router.response')
local json = require('json')
local log = require('log')
local cfg = require('app.config')

local function limit_rps(env)
    local ts = os.time()
    box.space.counter:upsert({ts, 1}, {{'+', 2, 1}})
    local rps = box.space.counter:select(ts)[1][2]
    if rps > cfg.max_rps then
        local resp = setmetatable({ headers = {} }, response.metatable)
        resp.headers['content-type'] = "application/json; charset=utf-8"
        -- Of course we shouldn't show rps limit to user on a real server)
        resp.body = json.encode({ error = string.format('rps limit hit [%d]! try again later', rps) })
        resp.status = 429
        return resp
    end
    return tsgi.next(env)
end

local function catch_error(env)
    local resp = setmetatable({ headers = {} }, response.metatable)
    local function try()
        resp = tsgi.next(env)
    end
    local res, exception = pcall(try)
    if not res then
        local json_data = { error = string.format('%s', exception) }
        resp.headers['content-type'] = "application/json; charset=utf-8"
        resp.body = json.encode(json_data)
        resp.status = 400
    end
    return resp
end

local function log_response(env)
    local resp = tsgi.next(env)
    log.info('Response: [%d] %s', resp.status or 200, resp.body or "")
    return resp
end

local middleware = {
    catch_error = catch_error,
    limit_rps = limit_rps,
    log_response = log_response,
}

return middleware
