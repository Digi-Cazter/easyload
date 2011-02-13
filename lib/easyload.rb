# -*- encoding: utf-8 -*-
require 'easyload/singleton_extensions'

# An alternative to autoload that relies on your project's directory structure to determine its
# module hierarchy, recursively.
# 
# This is an opinionated loading method that attempts to simplify your development process by
# enforcing that your directory and file names follow convention and are consistent with your
# project's module hierarchy.  Additionally, it allows for painless refactoring and reduces code
# repetition by removing the need of declaring your module hierarchy in every single source
# file.  The project's directory structure determines that; it's just extra work to keep the two
# in sync.
# 
# Easyload frowns upon the require statement, and would much rather that your library know how
# to load itself.  Simply reference the constant that you want, and it's there.
#
# = General Use
# To easyload a project, it must define at least one top level module to be used as the easyload
# root.  From that root, and the search path that it defines, all child constants are easyloaded
# according to your directory structure.
# 
# For example, with a directory structure of:
#   lib/
#     my_easyloaded_module.rb
#     my_easyloaded_module/
#       child_module.rb
#       child_module/
#         leafy.rb
#       node.rb
# 
# +lib/my_easyloaded_module.rb+:
#   module MyEasyloadedModule
#     import Safis::Toolkit::Easyload
#   end
# 
# +lib/my_easyloaded_module/child_module.rb+:
#   module ChildModule
#     # ... 
#   end
# 
# +lib/my_easyloaded_module/child_module/leafy.rb+:
#   class Leafy
#     # ...
#   end
# 
# +lib/my_easyloaded_module/node.rb+:
#   class Node
#     # ...
#   end
# 
# Would result in the following module/class hierarchy being easyloadable:
#   MyEasyloadedModule
#   MyEasyloadedModule::ChildModule
#   MyEasyloadedModule::ChildModule::Leafy
#   MyEasyloadedModule::Node
# 
# = Easyload Configuration
# When a class or module includes {Easyload Safis::Toolkit::Easyload}, the 
# {EasyloadSingletonExtensions} module is mixed into that class or module's singleton methods, 
# providing the easyload API.  See {EasyloadSingletonExtensions} for a reference of what
# configuration can be performed on an easyloaded class or module.
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