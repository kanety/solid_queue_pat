class WorkerForPoolDisplayableTest < SolidQueue::Worker
  attr_reader :_booted, :_set_procline

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

  def set_procline
    super.tap do
      @_set_procline = true if @_booted
    end
  end
end

describe SolidQueuePat::Worker::PoolDisplayable do
  before do
    SolidQueue::Job.destroy_all
  end

  let :worker do
    WorkerForPoolDisplayableTest.new(queue: '*', threads: 1, polling_interval: 1)
  end

  it 'sets procline with pool' do
    thread = Thread.new { worker.start }
    wait_until { worker._booted }

    TestJob.perform_later
    wait_until { SolidQueue::Job.count == 0 }

    worker.stop
    wait_until { thread.join }

    expect(worker._set_procline).to eq(true)
  end
end
