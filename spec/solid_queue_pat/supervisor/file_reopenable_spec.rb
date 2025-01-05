class SupervisorForFileReopenTest < SolidQueue::Supervisor
  attr_reader :_booted, :_reopened_files

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

describe SolidQueuePat::Supervisor::FileReopenable do
  let :supervisor do
    SupervisorForFileReopenTest.new(SolidQueue::Configuration.new)
  end

  it 'reopens files by USR1 singal' do
    thread = Thread.new { supervisor.start }
    wait_until { supervisor._booted }

    Process.kill(:USR1, Process.pid)
    wait_until { supervisor._reopened_files }

    supervisor.stop
    supervisor.send(:terminate_immediately)
    wait_until { thread.join }

    expect(supervisor._reopened_files).to eq(true)
  end
end
