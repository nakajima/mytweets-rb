require 'json'

$TWEETS = JSON.parse(File.read('my-tweets.json'))

class Tweet
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
  mentions = Tweet.mentions.sort_by { |key,val| -val }
  mentions.map! { |key,val| "#{key}: #{val}" }
  if limit = ARGV.delete('--limit') || ARGV.delete('-l')
    puts mentions[0..ARGV.last.to_i]
  else
    puts mentions
  end
end
