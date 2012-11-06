migration 5, :create_colors do
  up do
    create_table :colors do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :color_code, String, :length => 255
    end
  end

  down do
    drop_table :colors
  end
end
