FactoryGirl.define do
  factory :recipe do
    # Fields
    title "Propp"

    # Associations
    cuisine
    
    # Traits
    trait :nil_associations do
      cuisine nil
    end
    
    # Traited factories
    factory :only_recipe, :traits => [:nil_associations]
  end
end
