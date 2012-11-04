migration 2, :create_tasks do
  up do
    create_table :tasks do
      column :id, Integer, :serial => true
      column :title, String, :length => 255
      column :description, Text
    end
  end

  down do
    drop_table :tasks
  end
end
