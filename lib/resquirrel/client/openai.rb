# frozen_string_literal: true

require "net/http"
require "json"

class OpenAiClient
  BASE_URL = "https://api.openai.com/v1"

  def initialize(api_key, model: "gpt-3.5-turbo")
    @api_key = api_key
    @model = model
  end

  def summary_pr(title, body, max_tokens: 200)
    uri = URI("#{BASE_URL}/chat/completions")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@api_key}"
    request.content_type = "application/json"
    request.body = {
      model: @model,
      messages: [{ "role": "user",
                   "content": 
                   "I will now send you the title and content of the GitHub PR.
                   You are to summarize this content for those who are not that familiar with programming and web technologies.
                   Please keep the content concise.
                   title: #{title}
                   body: #{body}" }],
      max_tokens: max_tokens
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
