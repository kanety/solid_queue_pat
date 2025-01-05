def wait_until(timeout: 5)
  Timeout.timeout(timeout) do
    loop do
      break if yield
      sleep 0.2
    end
  end
rescue
  Timeout::Error
end
