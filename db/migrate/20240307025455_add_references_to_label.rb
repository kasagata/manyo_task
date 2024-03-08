class AddReferencesToLabel < ActiveRecord::Migration[6.1]
  def change
    add_reference :labels, :user, foregin_key: true
  end
end
