module Rez
  class Item < ActiveRecord::Base
    has_many :paragraphs
  end
end
