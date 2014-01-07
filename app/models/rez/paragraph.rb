module Rez
  class Paragraph < ActiveRecord::Base
    belongs_to :item
  end
end
