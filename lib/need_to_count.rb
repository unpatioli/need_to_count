require "need_to_count/version"

require "active_support"
require "active_record"

module NeedToCount
  extend ActiveSupport::Concern
  
  module ClassMethods
    def counts(association_name, params={})
      has_many_association = reflect_on_association(association_name)

      # Todo: error messages
      return unless has_many_association
      return unless has_many_association.macro == :has_many

      parent_class = has_many_association.active_record
      child_class = has_many_association.klass
      foreign_key_name = has_many_association.foreign_key
      counter_name = params[:in].to_sym || nil

      # Add after_add, after_remove callbacks to has_many association
      #
      # Adding after_add callback
      full_callback_name = "after_add_for_#{has_many_association.name}"
      send(full_callback_name) << lambda do |parent, child|
        condition = block_given? ? yield(child) : true
        parent.class.increment_counter counter_name, parent.id if condition
      end

      # Adding after_remove callback
      full_callback_name = "after_remove_for_#{has_many_association.name}"
      send(full_callback_name) << lambda do |parent, child|
        condition = block_given? ? yield(child) : true
        if condition and not child.destroyed?
          parent.class.decrement_counter counter_name, parent.id
        end
      end

      # Add after_destroy, before_update callbacks to association class
      # binding.pry
      child_class.class_eval do
        before_update do |obj|
          attrs_were = obj.changes.inject(obj.attributes) { |h, (k, v)| h[k] = v.first; h }
          obj_was = has_many_association.build_association attrs_were

          condition = block_given? ? yield(obj) : true
          condition_was = block_given? ? yield(obj_was) : true
          condition_changed = condition != condition_was

          id = obj.send(foreign_key_name)
          id_was = obj.send("#{foreign_key_name}_was")

          if obj.send("#{foreign_key_name}_changed?")
            # Update conditional
            if condition
              parent_class.increment_counter(counter_name, id)
              parent_class.decrement_counter(counter_name, id_was) unless condition_changed
            elsif condition_changed
              parent_class.decrement_counter(counter_name, id_was)
            end
          elsif condition_changed
            if condition
              parent_class.increment_counter(counter_name, id)
            else
              parent_class.decrement_counter(counter_name, id)
            end
          end
        end

        after_destroy do |obj|
          condition = block_given? ? yield(obj) : true
          if condition
            id = obj.send(foreign_key_name)
            parent_class.decrement_counter(counter_name, id)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, NeedToCount
