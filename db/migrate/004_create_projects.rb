migration 4, :create_projects do
  up do
    create_table :projects do
      column :id, Integer, :serial => true
      column :title, String, :length => 255
      column :description, Text
      column :color, String, :length => 255
    end
  end

  down do
    drop_table :projects
  end
end
