# From https://github.com/mdub/enumerating/blob/master/lib/enumerating/concatenating.rb
module Enumerating
  class Concatenator
    include Enumerable

    def initialize(enumerables)
      @enumerables = enumerables
    end

    def each(&block)
      @enumerables.each do |enumerable|
        enumerable.each(&block)
      end
    end
  end
end
