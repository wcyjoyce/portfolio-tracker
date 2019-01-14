class RemoveAhoy < ActiveRecord::Migration[5.1]
  def change
    drop_table :ahoy_events
    drop_table :ahoy_visits
  end
end
