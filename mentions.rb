require 'rubygems'
require 'json'

$TWEETS = JSON.parse(File.read('my-tweets.json'))

class Tweetion
  def self.mentions
    $TWEETS.inject({}) do |res, tweet|
      tweet['text'].scan(/@\w+/).each do |name|
        res[name] ||= 0
        res[name]  += 1
      end
      res
    end
  end
end

if __FILE__ == $0
  mentions = Tweetion.mentions
  display_mentions = mentions \
    .sort_by { |key,val| -val } \
    .map { |key,val| "#{key}: #{val}" }
  if limit = ARGV.delete('--limit') || ARGV.delete('-l')
    puts display_mentions[0..ARGV.last.to_i]
  else
    puts display_mentions
  end
  puts "You've made #{mentions.values.inject(0) { |sum, i| sum + i.to_i }} mentions."
end
