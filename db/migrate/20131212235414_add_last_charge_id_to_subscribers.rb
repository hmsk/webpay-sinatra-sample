class AddLastChargeIdToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :last_charge_id, :string
  end
end
