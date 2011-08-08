module Nanoc3
  module Helpers
    module CacheBusting

      # Test if we want to filter the output filename for a given item.
      # This is logic used in the Rules file, but doesn't belong there.
      #
      # @example Determining whether to rewrite an output filename
      #   # in your Rules file
      #   route '/assets/*' do
      #     hash = cachebust?(item) ? cachebusting_hash(item) : ''
      #     item.identifier + hash + '.' + item[:extension]
      #   end
      #
      # @param <Item> item is the item to test
      # @return <Boolean>
      def cachebust?(item)
        Nanoc3::Cachebuster.should_apply_fingerprint_to_file?(item)
      end

      # Get a unique fingerprint for a file's content. This currently uses
      # an MD5 hash of the file contents.
      #
      # @todo Also allow passing in an item rather than a path
      # @param <String> filename is the path to the file to fingerprint.
      # @return <String> file fingerprint
      def fingerprint(filename)
        Nanoc3::Cachebuster.fingerprint_file(filename)
      end
      
      # This is a work in progress to get items to recompile based on depencies on
      # other items. It is currently working but no tests have been written.
      def add_dependencies(extensions)
        item_extensions = extensions.join('|')
        if item[:extension].match(/\.(#{item_extensions})$/)
          dependent_extensions = Nanoc3::Cachebuster::FILETYPES_TO_FINGERPRINT.delete_if {|x| x = x.match(/#{item_extensions}/)}.join('|')
          dependencies = Array.new
          @items.each do |i|
            if i[:extension].match(/\.(#{dependent_extensions})$/)
              dependencies << Pathname.new(i.realpath)
            end
          end
          depend_on(dependencies)
        end
      end
      
    end
  end
end
