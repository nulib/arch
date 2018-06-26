class CreateCloudStorageArchives < ActiveRecord::Migration[5.0]
  def change
    create_table :cloud_storage_archives do |t|
      t.string   :work_id, null: false
      t.string   :status, default: "in_progress"
      t.string   :checksum, null: false
      t.text     :error_info
      t.integer  :progress
      t.integer  :progress_total
      t.integer  :byte_size

      t.timestamps
    end

    add_index :cloud_storage_archives, :work_id, unique: true
  end
end
