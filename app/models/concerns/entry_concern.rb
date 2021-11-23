# frozen_string_literal: true

module EntryConcern
  extend ActiveSupport::Concern

  class_methods do
    # Available Part of Speech (PoS) tags
    def pos_available
      %w[adv n ns so lo fn ao v none]
    end

    # Available dialects
    def dialects_available
      %w[all standard_clear standard_cas north_clear north_cas northeast_clear
         northeast_cas south_clear south_cas]
    end

    # Available compound parts
    def compound_parts_available
      %w[modifier head both none]
    end
  end
end
