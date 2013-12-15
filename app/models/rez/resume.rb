module Rez
  class Resume < ActiveRecord::Base
    belongs_to :profile
    belongs_to :address
  end
end
