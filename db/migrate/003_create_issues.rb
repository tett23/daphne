migration 3, :create_issues do
  up do
    create_table :issues do
      column :id, Integer, :serial => true
      column :title, String, :length => 255
      column :description, Text
    end
  end

  down do
    drop_table :issues
  end
end
