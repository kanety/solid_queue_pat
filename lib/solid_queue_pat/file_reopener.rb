# frozen_string_literal: true

module SolidQueuePat
  module FileReopener
    class << self
      def call
        ObjectSpace.each_object(File) do |file|
          next if file.closed? || !file.sync
          file.reopen file.path
          file.flush
        end
      end
    end
  end
end
