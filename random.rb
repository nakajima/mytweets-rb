require 'rubygems'
require 'json'

$TWEETS = JSON.parse(File.read('my-tweets.json'))

class Tweetion
  def self.random
    tweets = $TWEETS
    tweets = tweets.reject { |tweet| tweet['text'].include?('@') }
    tweets = tweets.reject { |tweet| tweet['text'].include?('http') }
    tweets[rand(tweets.size)]
  end
end

if __FILE__ == $0
  tweet = Tweetion.random
  if ARGV.include?('--open')
    system("open http://twitter.com/#{tweet['user']['screen_name']}/statuses/#{tweet['id']}")
  else
    puts tweet['text']
    puts "http://twitter.com/#{tweet['user']['screen_name']}/statuses/#{tweet['id']}"
  end
end
