class Cuisine < ActiveRecord::Base
  has_many :recipes, :class_name => "Recipe"
  counts(:recipes, :in => :public_recipes_count) { |recipe| not recipe.private? }
end