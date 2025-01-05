class WorkerForMemcheckableTest < SolidQueue::Worker
  attr_reader :_booted, :_stopped, :_stopped_for_memory

  def initialize(**options)
    super
    @mode = 'fork'
  end

  private

  def boot
    super.tap do
      @_booted = true
    end
  end

  def stop
    super.tap do
      @_stopped = true
    end
  end

  def stop_for_memory
    super.tap do
      @_stopped_for_memory = true
    end
  end
end

describe SolidQueuePat::Worker::Memcheckable do
  before do
    SolidQueue::Job.destroy_all
  end

  let :worker do
    WorkerForMemcheckableTest.new(queue: '*', threads: 1, polling_interval: 1, max_memory: 1.megabytes)
  end

  it 'checks memory usage after job performed' do
    thread = Thread.new { worker.start }
    wait_until { worker._booted }

    sleep 2
    wait_until { worker._stopped }
    wait_until { thread.join }

    expect(worker._stopped_for_memory).to eq(true)
  end
end
