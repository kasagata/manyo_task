class AddLabelnotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :labels, :name, false
  end
end
