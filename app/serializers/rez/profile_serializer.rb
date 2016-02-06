module Rez
  class ProfileSerializer < ActiveModel::Serializer
    attributes :id, :firstname, :middlename, :lastname, :nickname, :prefix, :suffix, :title, :email
  end
end
