class DispatcherForStrictPollingIntervalTest < SolidQueue::Dispatcher
  attr_reader :_booted, :_next_polling_interval

  private

  def boot
    super.tap do
      @_booted = true
    end
  end

  def polling_interval_for_next_execution
    super.tap do |value|
      @_next_polling_interval = value
    end
  end
end

describe SolidQueuePat::Dispatcher::StrictPollingInterval do
  before do
    SolidQueue::Job.destroy_all
  end

  let :dispatcher do
    DispatcherForStrictPollingIntervalTest.new(polling_interval: 1, batch_size: 1, strict_polling_interval: true)
  end

  it 'adjusts polling interval by reading next scheduled job' do
    thread = Thread.new { dispatcher.start }
    wait_until { dispatcher._booted }

    TestJob.set(wait_until: 1.second.after).perform_later
    wait_until { SolidQueue::Job.count == 0 }

    dispatcher.stop
    wait_until { thread.join }

    expect(dispatcher._next_polling_interval).to be <= 1
  end
end
