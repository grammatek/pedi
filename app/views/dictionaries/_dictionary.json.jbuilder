# frozen_string_literal: true

json.extract! dictionary, :id, :name, :edited, :created_at, :updated_at
json.url dictionary_url(dictionary, format: :json)
