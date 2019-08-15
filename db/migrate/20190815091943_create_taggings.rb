class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.references :task, foreign_key: true, null: false
      t.references :tag, foreign_key: true, null: false
    end
    
    add_index :taggings, [:tag_id, :task_id], unique: true, name: :uniq_taggings
  end
end
