class Recipe < ActiveRecord::Base
  belongs_to :cuisine, :counter_cache => true
end