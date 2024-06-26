# frozen_string_literal: true

require "net/http"
require "json"

class NotionClient
  def initialize(api_key, database_id)
    @api_key = api_key
    @database_id = database_id
  end

  def create_release_note(summary, url)
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
        },
        URL: {
          url: url
        }
      }
    }.to_json

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end
end
