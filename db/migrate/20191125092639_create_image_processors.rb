# frozen_string_literal: true

class CreateImageProcessors < ActiveRecord::Migration[5.2]
  def change
    create_table :image_processors do |t|
      t.string :public_id
      t.string :version
      t.string :format
      t.string :url
      t.string :secure_url
      t.string :original_filename

      t.timestamps
    end
  end
end
