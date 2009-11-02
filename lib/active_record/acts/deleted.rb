# Deleted
module ActiveRecord
  module Acts
    module Deleted
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_deleted(options = {})
          configuration = {:deleted_at => "deleted_at"}
          configuration.update(options) if options.is_a?(Hash)

          class_eval <<-EOV
            include ActiveRecord::Acts::Deleted::InstanceMethods

            def destroy
              self.update_attributes :#{configuration[:deleted_at]} => DateTime.now
            end 

            def restore
              self.update_attributes :#{configuration[:deleted_at]} => nil
            end

            def self.all_undestroyed(opts={})
              self.find_all_by_deleted_at(nil, opts)
            end
          EOV
        end
      end

      module InstanceMethods
      end
    end
  end
end

