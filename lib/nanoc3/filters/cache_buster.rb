module Nanoc3
  module Filters
    class CacheBuster < Nanoc3::Filter
      identifier :cache_buster

      def run(content, options = {})
        
        if @item[:extension].match(/\.(haml|html)$/)
          dependencies = Array.new 
          @items.each do |i|
            if i[:extension].match(/\.(css|js|jpg|jpeg|gif|png)$/)
              dependencies << i
            end
          end
          depend_on(dependencies)
        end
        
        kind = options[:strategy] || (stylesheet? ? :css : :html)
        strategy = Nanoc3::Cachebuster::Strategy.for(kind , site, item)
        content.gsub(strategy.class::REGEX) do |m|
          begin
            strategy.apply m, $1, $2, $3, $4
          rescue Nanoc3::Cachebuster::NoSuchSourceFile
            m
          end
        end
      end

    private

      # See if the current item is a stylesheet.
      #
      # This is a simple check for filetypes, but you can override what strategy to use
      # with the filter options. This provides a default.
      #
      # @see Nanoc3::Cachebuster::FILETYPES_CONSIDERED_CSS
      # @return <Bool>
      def stylesheet?
        Nanoc3::Cachebuster::FILETYPES_CONSIDERED_CSS.include?(item[:extension].to_s)
      end
    end
  end
end