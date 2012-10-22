class TextModulesController < ApplicationController
  before_filter :authentication_check

=begin

Format:
JSON

Example:
{
  "id":1,
  "name":"some text_module",
  "user_id": null,
  "keywords":"some keywords",
  "content":"some content",
  "active":true,
  "updated_at":"2012-09-14T17:51:53Z",
  "created_at":"2012-09-14T17:51:53Z",
  "updated_by_id":2.
  "created_by_id":2,
}
  
=end

=begin

Resource:
GET /api/text_modules.json

Response:
[
  {
    "id": 1,
    "name": "some_name1",
    ...
  },
  {
    "id": 2,
    "name": "some_name2",
    ...
  }
]

Test:
curl http://localhost/api/text_modules.json -v -u #{login}:#{password}

=end

  def index
    model_index_render(TextModule, params)
  end

=begin

Resource:
GET /api/text_modules/#{id}.json

Response:
{
  "id": 1,
  "name": "name_1",
  ...
}

Test:
curl http://localhost/api/text_modules/#{id}.json -v -u #{login}:#{password}
 
=end

  def show
    model_show_render(TextModule, params)
  end

=begin

Resource:
POST /api/text_modules.json

Payload:
{
  "name": "some name",
  "keywords":"some keywords",
  "content":"some content",
  "active":true,
}

Response:
{
  "id": 1,
  "name": "some_name",
  ...
}

Test:
curl http://localhost/api/text_modules.json -v -u #{login}:#{password} -H "Content-Type: application/json" -X POST -d '{"name": "some_name","active": true, "note": "some note"}'

=end

  def create
    model_create_render(TextModule, params)
  end

=begin

Resource:
PUT /api/text_modules/{id}.json

Payload:
{
  "name": "some name",
  "keywords":"some keywords",
  "content":"some content",
  "active":true,
}

Response:
{
  "id": 1,
  "name": "some_name",
  ...
}

Test:
curl http://localhost/api/text_modules.json -v -u #{login}:#{password} -H "Content-Type: application/json" -X PUT -d '{"name": "some_name","active": true, "note": "some note"}'

=end

  def update
    model_update_render(TextModule, params)
  end

=begin

Resource:
DELETE /api/text_modules/{id}.json

Response:
{}

Test:
curl http://localhost/api/text_modules.json -v -u #{login}:#{password} -H "Content-Type: application/json" -X DELETE

=end

  def destroy
    model_destory_render(TextModule, params)
  end
end
