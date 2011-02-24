# -*- encoding: utf-8 -*-
require 'easyload/helpers'

module Easyload
  # The singleton methods that are defined for a module that includes {Easyload}.
  module SingletonExtensions
    # The root path that easyload should use when loading a child constant for this module.
    # 
    # Defaults to the path component form of the class/module's name
    attr_reader :easyload_root
    
    # Sets easyload_root.
    def easyload_from(root_path)
      @easyload_root = root_path.to_s
    end
    
    # Converts a CamelCased symbol into a path component.
    # 
    # * A +Single+ symbol becomes +single+.
    # * +MultiWordSymbols+ become +multi_word_symbols+.
    # * +ACRONYMS+ are treated like words: +acronyms+.
    # * +ABCFoo+ is considered to be a mix of acronyms and words: +abc_foo+.
    def easyload_path_component_for_sym(sym)
      path = sym.to_s.dup
      path.gsub!(/([A-Z]+)([A-Z][a-z]+)/, '\1_\2_')
      path.gsub!(/([A-Z][a-z]+)/, '\1_')
      path.gsub!(/_+/, '_')
      path.chomp!('_')
      path.downcase!
    end
    
    # The meat of easyloading happens here.
    # 
    # @private
    def const_missing(sym)
      if not self.instance_variable_defined? :@easyload_root
        $stderr.puts "You must call easyload_from() before you can easyload #{self}::#{sym}"
        return super(sym)
      end
      
      path_component = self.easyload_path_component_for_sym(sym)
      easyload_path = File.join(@easyload_root, "#{path_component}.rb")
      
      # Do we have a file to easyload?
      path_to_easyload = Helpers.find_loadable_file(easyload_path)
      if path_to_easyload.nil?
        raise NameError.new("Unknown constant #{self}::#{sym} - tried to easyload it from '#{@easyload_root}/#{path_component}'", sym)
      end
      file_source = File.read(path_to_easyload)
      
      # Perform the easyload with a manual eval.  module_eval doesn't allow for relative constants
      # in the easyloaded file, so we need to manually construct the context to evaluate within.
      easyload_binding = self.module_eval('::Kernel.binding')
      easyload_binding.eval(file_source, path_to_easyload)
      
      # Did we get our target constant?
      if not self.const_defined? sym
        raise LoadError.new("Attempted to easyload #{sym} from '#{path_to_easyload}', but it doesn't appear to exist in that source file.")
      end
      
      # Make sure that we propagate easyload behaviors
      target_const = self.const_get(sym)
      class << target_const
        include SingletonExtensions
      end
    
      target_const.easyload_from(File.join(self.easyload_root, path_component))
    
      return self.const_get(sym)
    end
  end
end
