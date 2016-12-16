class CreateJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table(:recipes_tags) do |t|
      t.column(:recipe_id, :integer)
      t.column(:tag_id, :integer)
    end
  end
end
