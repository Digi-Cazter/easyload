# -*- encoding: utf-8 -*-

::SpecRoot.load_count += 1

module LoadCounter
  ABOUT = "load counter: #{::SpecRoot.load_count}"
end
