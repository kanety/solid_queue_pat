class WorkerForFileReopenTest < SolidQueue::Worker
  attr_reader :_booted, :_reopened_files

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

  def reopen_files
    super.tap do
      @_reopened_files = true
    end
  end
end

describe SolidQueuePat::Processes::FileReopenable do
  let :worker do
    WorkerForFileReopenTest.new(polling_interval: 10)
  end

  it 'reopens files by USR1 singal' do
    thread = Thread.new { worker.start }
    wait_until { worker._booted }

    Process.kill(:USR1, Process.pid)
    wait_until { worker._reopened_files }

    worker.stop
    wait_until { thread.join }

    expect(worker._reopened_files).to eq(true)
  end
end
