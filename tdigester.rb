# http://twitter.com/statuses/user_timeline/bonzoesc.atom
require 'rubygems'
require 'twitter'
require 'active_support'

SINCE = 24.hours.ago
USER = 'BonzoESC'

c = Twitter::Client.new

s = c.timeline_for :user, :id=>USER, :since=>SINCE