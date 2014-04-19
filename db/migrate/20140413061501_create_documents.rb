class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :content
      t.integer :last_edit_by

      t.timestamps
    end
  end
end
