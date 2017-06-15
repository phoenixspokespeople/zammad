web: bundle exec script/rails server -p ${PORT:=3000}
websocket: bundle exec script/websocket-server.rb -p ${ZAMMAD_WEBSOCKET_PORT:=6042} start
worker: bundle exec script/scheduler.rb start -t
