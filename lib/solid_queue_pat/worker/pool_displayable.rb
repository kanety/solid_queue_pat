# frozen_string_literal: true

module SolidQueuePat
  module Worker
    module PoolDisplayable
      private

      def register_signal_handlers
        super.tap do
          trap(:SIGWINCH) do
            Thread.new { set_procline }
          end
        end
      end

      def set_procline
        super.tap do
          executor = pool.send(:executor)
          $0 += " (active #{executor.active_count} of #{executor.max_length} threads)"
        end
      end
    end
  end
end

SolidQueue::Worker.prepend SolidQueuePat::Worker::PoolDisplayable
