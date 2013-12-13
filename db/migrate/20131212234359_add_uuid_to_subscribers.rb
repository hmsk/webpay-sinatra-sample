class AddUuidToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :uuid, :string
  end
end
