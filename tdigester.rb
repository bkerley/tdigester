# http://twitter.com/statuses/user_timeline/bonzoesc.atom
require 'rubygems'
require 'twitter'
require 'active_support'
require 'erubis'

SINCE = 24.hours.ago
USER = 'BonzoESC'

c = Twitter::Client.new

statuses = c.timeline_for :user, :id=>USER, :since=>SINCE

template = File.read('output.atom.erb')
erb = Erubis::Eruby.new(template)

$stdout.write erb.result(binding())
