
module SolidQueuePat
  module Worker
    module PoolWithCompleteSignal
      def post(execution)
        send_sigwinch
        super.tap do |future|
          future.add_observer do
            send_sigwinch
          end
        end
      end

      def send_sigwinch
        Process.kill(:SIGWINCH, Process.pid)
      end
    end
  end
end

SolidQueue::Pool.prepend SolidQueuePat::Worker::PoolWithCompleteSignal
