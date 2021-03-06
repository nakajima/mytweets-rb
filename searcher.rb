require 'rubygems'
require 'json'

$TWEETS = JSON.parse(File.read('my-tweets.json'))

class Tweetion
  def self.search(term, options={})
    $TWEETS.select do |tweet|
      if term.is_a?(Regexp)
        tweet['text'] =~ term
      else
        tweet['text'].include?(term.to_s)
      end
    end
  end
end

if term = ARGV.pop
  puts Tweetion.search(term).map { |tweet| "- #{tweet['text']}" }
end
