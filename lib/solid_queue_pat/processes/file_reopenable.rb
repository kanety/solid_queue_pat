# frozen_string_literal: true

module SolidQueuePat
  module Processes
    module FileReopenable
      private

      def register_signal_handlers
        super.tap do
          trap(:USR1) do
            Thread.new { reopen_files }
          end
        end
      end

      def reopen_files
        SolidQueue.instrument(:reopen_files, process: self) do
          SolidQueuePat::FileReopener.call
        end
      end
    end
  end
end

SolidQueue::Worker.prepend SolidQueuePat::Processes::FileReopenable
SolidQueue::Dispatcher.prepend SolidQueuePat::Processes::FileReopenable
