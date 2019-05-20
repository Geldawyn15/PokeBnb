class ChangeBattlesToTransfers < ActiveRecord::Migration[5.2]
  def change
    rename_table :battles, :transfers
  end
end
