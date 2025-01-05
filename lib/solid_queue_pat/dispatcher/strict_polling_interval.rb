# frozen_string_literal: true

module SolidQueuePat
  module Dispatcher
    module StrictPollingInterval
      def initialize(**options)
        @strict_polling_interval = options[:strict_polling_interval]
        super
      end

      private

      def polling_interval
        if @strict_polling_interval
          polling_interval_for_next_execution
        else
          @polling_interval
        end
      end

      def polling_interval_for_next_execution
        now = Time.zone.now.to_f
        next_execution = SolidQueue::ScheduledExecution.ordered.non_blocking_lock.first
        if next_execution && next_execution.scheduled_at.to_f - now < @polling_interval
          next_execution.scheduled_at.to_f - now
        else
          @polling_interval
        end
      end
    end
  end
end

SolidQueue::Dispatcher.prepend SolidQueuePat::Dispatcher::StrictPollingInterval
