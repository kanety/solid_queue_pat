# frozen_string_literal: true

module SolidQueuePat
  class LogSubscriber < ActiveSupport::LogSubscriber
    def reopen_files(event)
      debug do
        formatted_event(event, action: 'Reopen files', **process_attributes(event))
      end
    end

    def restart_gracefully(event)
      debug do
        formatted_event(event, action: 'Restart gracefully', **process_attributes(event))
      end
    end

    def stop_worker_for_memory(event)
      debug do
        formatted_event(event, action: 'Stop wroker for memory', **process_attributes(event).merge(memory_attributes(event)))
      end
    end

    private

    def process_attributes(event)
      process = event.payload[:process]
      {
        hostname: process.hostname,
        pid: process.pid,
        name: process.name
      }
    end

    def memory_attributes(event)
      {
        current_memory: megabytes(event.payload[:memory]),
        max_memory: megabytes(event.payload[:max_memory])
      }
    end

    def megabytes(size)
      (size.to_f / 1024**2).to_i.to_s + ' MB'
    end

    def formatted_event(event, action:, **attributes)
      "SolidQueue-#{SolidQueue::VERSION} #{action} (#{event.duration.round(1)}ms)  #{formatted_attributes(**attributes)}"
    end

    def formatted_attributes(**attributes)
      attributes.map { |attr, value| "#{attr}: #{value.inspect}" }.join(", ")
    end
  end
end
