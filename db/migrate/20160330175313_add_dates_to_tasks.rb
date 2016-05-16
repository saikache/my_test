class AddDatesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :start_date, :date
    add_column :tasks, :end_date, :date
    add_column :tasks, :status, :string
  end
end
