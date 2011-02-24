# -*- encoding: utf-8 -*-
module Easyload
  module Helpers
    # Looks for a file on the $LOAD_PATH and returns the full path to the first match.
    def self.find_loadable_file(path)
      $LOAD_PATH.each do |load_root|
        full_load_path = File.join(load_root, path)
        return full_load_path if File.exists? full_load_path
      end
      
      return nil
    end
  end
end
