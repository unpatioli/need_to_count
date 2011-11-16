require 'spec_helper'

describe Cuisine do
  
  context "counts public recipes" do
    
    before(:each) do
      @cuisine = create :cuisine
      @public_recipes = build_list :only_recipe, 2
      private_recipes = build_list :only_recipe, 2, :private => true
      total_recipes = @public_recipes + private_recipes
      @cuisine.recipes << total_recipes
    end

    it "on create" do
      @cuisine.reload.public_recipes_count.should == @public_recipes.size
    end
    
    it "on append" do
      @cuisine.recipes << build(:only_recipe)
      @cuisine.recipes << build(:only_recipe, :private => true)
      @cuisine.reload.public_recipes_count.should == @public_recipes.size + 1
    end
    
    it "on assignment" do
      cuisine = create :cuisine
      cuisine.recipes = [build(:only_recipe), build(:only_recipe, :private => true)]
      cuisine.save
      cuisine.reload.public_recipes_count.should == 1
    end


    context "when private recipe" do
      
      before(:each) do
        @private_recipe = @cuisine.recipes.where(:private => true).first
      end
      
      it "is deleted" do
        @cuisine.recipes.delete @private_recipe
        
        @cuisine.reload.public_recipes_count.should == @public_recipes.size
      end
      
      context "is destroyed" do
        it "by object.destroy" do
          @private_recipe.destroy

          @cuisine.reload.public_recipes_count.should == @public_recipes.size
        end
        
        it "by collection.destroy object" do
          @cuisine.recipes.destroy @private_recipe
          
          @cuisine.reload.public_recipes_count.should == @public_recipes.size
        end
      end
    end

    context "when public recipe" do
      
      before(:each) do
        @public_recipe = @cuisine.recipes.where(:private => false).first
      end
      
      it "is deleted" do
        @cuisine.recipes.delete @public_recipe
        
        @cuisine.reload.public_recipes_count.should == @public_recipes.size - 1
      end
      
      context "is destroyed" do
        it "by object.destroy" do
          @public_recipe.destroy

          @cuisine.reload.public_recipes_count.should == @public_recipes.size - 1
        end
        
        it "by collection.destroy object" do
          @cuisine.recipes.destroy @public_recipe
          
          @cuisine.reload.public_recipes_count.should == @public_recipes.size - 1
        end
      end
    end

    it "on delete_all" do
      @cuisine.recipes.delete_all
      @cuisine.public_recipes_count.should == 0
    end

  end

end

describe Recipe do
 context "makes Cuisine to update public recipes count" do
   
   before(:each) do
     @cuisine = create :cuisine
     @public_recipes = build_list :only_recipe, 2
     private_recipes = build_list :only_recipe, 2, :private => true
     total_recipes = @public_recipes + private_recipes
     @cuisine.recipes << total_recipes
     
     @private_recipe = @cuisine.recipes.where(:private => true).first
     @public_recipe = @cuisine.recipes.where(:private => false).first
   end
   
   it "when Recipe#private is changed" do
     @private_recipe.update_attribute :private, false
      
     @cuisine.reload.public_recipes_count.should == @public_recipes.size + 1
   end
   
   it "when Recipe#cuisine_id is changed" do
     new_cuisine = create :cuisine
     
     @private_recipe.update_attribute :cuisine_id, new_cuisine.id
     @public_recipe.update_attribute :cuisine_id, new_cuisine.id
     
     @cuisine.reload.public_recipes_count.should == @public_recipes.size - 1
     new_cuisine.reload.public_recipes_count.should == 1
   end
   
   it "when both Recipe#private and Recipe#cuisine_id are changed" do
     new_cuisine = create :cuisine
     
     @private_recipe.cuisine_id = new_cuisine.id
     @private_recipe.update_attribute :private, false
                   
     @public_recipe.cuisine_id = new_cuisine.id
     @public_recipe.update_attribute :private, true
     
     @cuisine.reload.public_recipes_count.should == @public_recipes.size - 1
     new_cuisine.reload.public_recipes_count.should == 1
   end
 end
end
