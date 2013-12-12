class AddChargeCountToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :charge_count, :integer, null: false, default: 0
  end
end
