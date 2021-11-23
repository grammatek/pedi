# frozen_string_literal: true

json.extract! entry, :id, :word, :sampa, :comment, :pos, :dialect, :is_compound, :comp_part,
              :prefix, :created_at, :updated_at
json.url entry_url(entry, format: :json)
