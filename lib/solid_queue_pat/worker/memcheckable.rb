# frozen_string_literal: true

require 'get_process_mem'

module SolidQueuePat
  module Worker
    module Memcheckable
      def initialize(**options)
        @max_memory = options[:max_memory]
        super
      end

      private

      def poll
        super.tap do
          check_memory if @max_memory
        end
      end

      def check_memory
        mem = GetProcessMem.new
        if mem.bytes > @max_memory
          SolidQueue.instrument(:stop_worker_for_memory, process: self, memory: mem.bytes, max_memory: @max_memory)
          stop_for_memory
        end
      end

      def stop_for_memory
        sleep polling_interval until pool.idle?
        stop
      end
    end
  end
end

SolidQueue::Worker.prepend SolidQueuePat::Worker::Memcheckable
