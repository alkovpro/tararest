# tararest
Tarantool based REST API example app

## API:
 - POST /kv body: {key: "test", "value": {SOME ARBITRARY JSON}} 
 - PUT kv/{id} body: {"value": {SOME ARBITRARY JSON}}
 - GET kv/{id} 
 - DELETE kv/{id}

## Error handling:
 - POST returns 409 if key already exists
 - POST, PUT return 400 if body is incorrect
 - PUT, GET, DELETE return 404 if key not exists
 - when RPS is hit the max allowed value, server returns 429.
 
## Logs:
 - There is a log of all requests result

## Environment variables that matter:
 - APP_HOST - host on which server app will be running
 - APP_PORT - port server app will listen on
 - APP_MAX_RPS - maximum requests per second allowed
