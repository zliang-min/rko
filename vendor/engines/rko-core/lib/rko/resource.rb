module Rko
  class Resource
    include Mongoid::Document

    field 'title'
    field 'description'
  end
end
