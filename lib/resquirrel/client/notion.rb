# frozen_string_literal: true

require "net/http"
require "json"

class NotionClient
  def initialize(api_key, database_id)
    @api_key = api_key
    @database_id = database_id
  end

  def update_database(summary)
    uri = URI("https://api.notion.com/v1/pages")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@api_key}"
    request["Notion-Version"] = "2022-06-28"
    request.content_type = "application/json"
    request.body = {
      parent: { type: "database_id", database_id: @database_id },
      properties: {
        title: {
          title: [
            {
              type: "text",
              text: {
                content: summary
              }
            }
          ]
        }
      }
    }.to_json

    p @api_key
    p "---test---"

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      response = http.request(request)
      puts response.body
    end
  end
end
