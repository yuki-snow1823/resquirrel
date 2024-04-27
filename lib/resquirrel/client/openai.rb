# frozen_string_literal: true

require "net/http"
require "json"

class OpenAiClient
  BASE_URL = "https://api.openai.com/v1"

  def initialize(api_key, model: "gpt-3.5-turbo")
    @api_key = api_key
    @model = model
  end

  def chat_completion(messages, max_tokens: 200)
    uri = URI("#{BASE_URL}/chat/completions")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@api_key}"
    request.content_type = "application/json"
    request.body = {
      model: @model,
      messages: messages + "Please reply with from OpenAI at the last",
      max_tokens: max_tokens
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
