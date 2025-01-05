class SupervisorForRestartTest < SolidQueue::Supervisor
  attr_reader :_booted, :_restarted

  private

  def boot
    super.tap do
      @_booted = true
    end
  end

  def restart_gracefully
    super.tap do
      @_restarted = true
    end
  end
end

describe SolidQueuePat::Supervisor::Restartable do
  let :supervisor do
    SupervisorForRestartTest.new(SolidQueue::Configuration.new)
  end

  it 'restarts gracefully by USR2 singal' do
    thread = Thread.new { supervisor.start }
    wait_until { supervisor._booted }

    allow(supervisor).to receive(:exec).and_return(nil)
    Process.kill(:USR2, Process.pid)
    wait_until { supervisor._restarted }

    supervisor.stop
    supervisor.send(:terminate_immediately)
    wait_until { thread.join }

    expect(supervisor._restarted).to eq(true)
  end
end
