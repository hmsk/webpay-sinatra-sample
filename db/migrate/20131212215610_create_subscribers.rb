class CreateSubscribers < ActiveRecord::Migration
  def up
    create_table :subscribers do |t|
      t.string :customer_id
    end
  end

  def down
    drop_table :subscribers
  end
end
