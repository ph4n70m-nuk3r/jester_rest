import jester

routes:
  get "/ping":
    resp Http200, @{"Content-type":"application/json"}, "{\"value\": \"pong\"}"

