require 'dm-serializer/common'


module DataMapper
  
    class Collection
      
      def as_json(*args)
        options = args.first
        options = {} unless options.kind_of?(Hash)
        resource_options = options.merge(:to_json => false)
        collection = map { |resource| resource.as_json(resource_options) }
        collection
      end
      
    end
end