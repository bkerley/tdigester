require 'rubygems'
require 'twitter'
require 'active_support'
require 'builder'

SINCE = 24.hours.ago
USER = 'BonzoESC'
LANG = 'en-us'

client = Twitter::Client.new

statuses = client.timeline_for :user, :id=>USER, :since=>SINCE

content_collector = String.new
content = Builder::XmlMarkup.new :indent=>2, :out=>content_collector
content.div(:class=>'twitter') { |d|
	statuses.reverse.each { |status|
		d.p { |p|
			# p.span(:class=>'user') { |s|
			# 				s.img :src=>status.user.profile_image_url
			# 				s.span status.user.name, :class=>'username'
			# 			}
			p.span "At #{status.created_at.strftime("%H:%M:%S")}: ", :class=>'timestamp'
			p.span status.text, :class=>'content'
		}
	}
}

collector = String.new
atom = Builder::XmlMarkup.new :indent=>2, :out=>collector
atom.instruct!
atom.feed(:'xml:lang'=>LANG, :xmlns=>'http://www.w3.org/2005/Atom') { |f|
	f.title "Twitter Digest for #{USER}"
	f.subtitle "Twitter updates since #{SINCE} for #{USER}"
	f.id 'tag:brycekerley.net,2008-05-24:digest'
	f.link :href=>"http://twitter.com/#{USER}", :rel=>'alternate', :type=>'text/html'
	f.author {|a|
		a.name USER
		a.uri "http://twitter.com/#{USER}"
	}
	f.updated statuses.first.created_at.strftime('%Y-%m-%dT%H:%M:%SZ')
	f.entry { |e|
		e.title "Updates since #{SINCE}"
		e.updated statuses.first.created_at.strftime('%Y-%m-%dT%H:%M:%SZ')
		e.id "http://twitter.com/#{USER}/statuses/#{statuses.first.id}"
		e.content(content.target!, :type=>'html')
	}
}

puts atom.target!