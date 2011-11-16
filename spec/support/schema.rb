ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

module Schema
  def self.create
    ActiveRecord::Base.silence do
      ActiveRecord::Migration.verbose = false
      
      ActiveRecord::Schema.define do
        # ===========
        # = Cuisine =
        # ===========
        create_table :cuisines, :force => true do |t|
          t.string :title
          
          t.integer :recipes_count, default: 0, null: false
          t.integer :public_recipes_count, default: 0, null: false
        end
        
        # ==========
        # = Recipe =
        # ==========
        create_table :recipes, :force => true do |t|
          t.references :cuisine
          
          t.string :title
          t.boolean :private, default: false, null: false
        end
      end
    end
    
  end
end