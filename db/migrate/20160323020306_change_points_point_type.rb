class ChangePointsPointType < ActiveRecord::Migration
  def change
    change_column :rez_points, :point_type, 'integer USING CAST(point_type AS integer)'
  end
end
