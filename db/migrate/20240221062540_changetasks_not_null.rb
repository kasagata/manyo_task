class ChangetasksNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :title, :string, null: false
  end
end
