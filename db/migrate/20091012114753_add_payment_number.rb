class AddPaymentNumber < ActiveRecord::Migration
  def self.up

    add_column :payments, :number, :string
    
    execute "UPDATE #{quote_table_name(:payments)} SET number = id WHERE number IS NULL"

  end

  def self.down

    remove_column :payments, :number

  end
end
