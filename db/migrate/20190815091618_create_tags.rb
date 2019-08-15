class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.text :title, null: false
    end
    
    add_index :tags, :title, unique: true
  end
end
