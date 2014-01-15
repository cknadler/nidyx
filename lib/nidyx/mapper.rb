require 'nidyx/objc/mapper'

module Nidyx
  module Mapper
    extend self

    # Proxies model mapping to the proper platform mapper
    # @param models [Hash] a hash with model name keys and Model values
    # @param options [Hash] runtime options
    # @return [Array] an array of models generated for a specific platform
    def map(models, options)
      models = models.values
      case options[:platform].downcase
      when "objc", "objective-c"
        Nidyx::ObjCMapper.map(models, options)
      end
    end
  end
end
