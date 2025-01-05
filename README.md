# SolidQueuePat

Some patches for solid_queue.

* Add signal handlers for reopening files and restarting supervisor process.
* Check worker's memory usage after jobs performed.

## Dependencies

* ruby 3.1+
* rails 7.2+
* solid_queue 1.1

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solid_queue_pat'
```

And then execute:

    $ bundle

## Usage

Set solid_queue's pid file for your application:

```ruby
Rails.application.config.solid_queue.supervisor_pidfile = Rails.root.join('tmp/pids/jobs.pid')
```

Reopen files:

    $ kill -USR1 `cat tmp/pids/jobs.pid`

Restart supervisor process:

    $ kill -USR2 `cat tmp/pids/jobs.pid`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kanety/solid_queue_pat.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
