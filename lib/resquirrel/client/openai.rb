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
                   "これからGitHub PRのタイトルと内容を送ります。
                   この内容を、プログラミングやウェブ技術にそれほど詳しくない人のために要約してください。
                   日本語で必ず返答してください。
                   要約の文章はタイトル：本文：のようにせず、文章だけでお願いします。
                   タイトルと本文を踏まえて、どのような変更があったのか文章にわかりやすくまとめてください。
                   以下がPRの内容です。
                   タイトル： #{title}
                   本文： #{body}"}],
      max_tokens: max_tokens
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
