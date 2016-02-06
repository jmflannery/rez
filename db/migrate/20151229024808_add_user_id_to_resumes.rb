class AddUserIdToResumes < ActiveRecord::Migration
  def change
    add_reference :rez_resumes, :user, index: true
  end
end
