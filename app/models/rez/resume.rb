module Rez
  class Resume < ActiveRecord::Base
    belongs_to :user, class_name: ::Toke::User
    belongs_to :profile
    belongs_to :address
    has_and_belongs_to_many :items

    validates :name, presence: true

    # def sections
    #   Section.where(id: section_ids)
    # end
    # 
    # def sections=(sections)
    #   self.section_ids = []
    #   sections.each do |section|
    #     self.section_ids << section.id
    #   end
    #   save_section_ids!
    # end
    # 
    # def add_section(section)
    #   section_ids << section.id
    #   save_section_ids!
    # end
    # 
    # private
    # 
    # def save_section_ids!
    #   section_ids_will_change!
    #   save
    # end
  end
end
