class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :name
      t.string :description
      t.string :status
      t.integer :author_id
      t.integer :assignee_id

      t.timestamps null: false
    end

    add_index :issues, :status
    add_index :issues, :author_id
    add_index :issues, [:author_id, :status]
  end
end
