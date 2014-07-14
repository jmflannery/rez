module Rez
  class Resume < ActiveRecord::Base
    belongs_to :profile
    belongs_to :address

    validates :name, presence: true

    def sections
      Section.where(id: section_ids)
    end

    def add_section(section)
      if valid_section? section
        section_ids << section.id
        save_section_ids!
      end
    end

    private

    def valid_section?(section)
      section && !section.new_record? && section.id > 0
    end

    def save_section_ids!
      section_ids_will_change!
      save
    end
  end
end
