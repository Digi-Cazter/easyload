# -*- encoding: utf-8 -*-
require 'easyload/singleton_extensions'

module Easyload
  autoload :VERSION, 'version'
  
  # Handle module/class inclusions in a clean manner, and try to guess our easyload root.
  # 
  # @private
  def self.included(in_mod)
    class << in_mod
      include SingletonExtensions
    end
    
    if in_mod.name
      components = in_mod.name.split('::').map {|n| in_mod.easyload_path_component_for_sym(n)}
      in_mod.easyload_from(components.join('/'))
    end
  end
end
