# frozen_string_literal: true

event_data = JSON.parse(File.read(ENV["GITHUB_EVENT_PATH"]))

p event_data