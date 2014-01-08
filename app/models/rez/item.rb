module Rez
  class Item < ActiveRecord::Base
    has_many :points
  end
end
