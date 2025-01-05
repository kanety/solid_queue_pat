# frozen_string_literal: true

module SolidQueuePat
  module Supervisor
    module Restartable
      private

      def handle_signal(signal)
        if signal == :USR2
          restart_gracefully
        else
          super
        end
      end

      def restart_gracefully
        SolidQueue.instrument(:restart_gracefully, process: self)
        stop
        terminate_gracefully
        delete_pidfile
        exec(*(['./bin/jobs'] + ARGV))
      end
    end
  end
end

SolidQueue::Supervisor.prepend SolidQueuePat::Supervisor::Restartable
SolidQueue::Supervisor::Signals::SIGNALS << :USR2
