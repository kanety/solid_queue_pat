# frozen_string_literal: true

module SolidQueuePat
  module Supervisor
    module FileReopenable
      private

      def handle_signal(signal)
        if signal == :USR1
          reopen_files
          signal_processes(forks.keys, :USR1)
        else
          super
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

SolidQueue::Supervisor.prepend SolidQueuePat::Supervisor::FileReopenable
SolidQueue::Supervisor::Signals::SIGNALS << :USR1
