---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by al-kov.
--- DateTime: 25.11.2019 16:21
---
local log = require('log')

local function init_schema()
    if not box.space.data then
        log.info('Creating non-existing space "data"...')
        local data = box.schema.space.create('data')
        data:create_index('primary', {parts = {{field = 1, type ='str', collation='unicode_ci'}}})
    end

    if not box.space.counter then
        log.info('Creating non-existing space "counter"...')
        -- We could save request times, but it would be a bit more complex solution)
        local counter = box.schema.create_space('counter')
        counter:create_index('primary', {parts = {{field = 1, type ='int'}}})
    end
    log.info('Schema is ready.')
end

return {
    init = init_schema
}