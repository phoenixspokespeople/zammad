web: bundle exec script/rails server -p ${PORT:=3000}
worker: bundle exec script/scheduler.rb start -t
websocket: bundle exec script/websocket-server.rb start
