class CreateContents < ActiveRecord::Migration[8.1]
  def change
    create_table :contents, id: false do |t|
      t.uuid :id, primary_key: true, null: false
      t.string :title, null: false
      t.string :body, null: false
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
