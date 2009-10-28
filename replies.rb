require 'json'

$TWEETS = JSON.parse(File.read('my-tweets.json'))

class Tweetion
  def self.replies
    $TWEETS.inject({}) do |res, tweet|
      name = tweet['in_reply_to_screen_name']
      next res if name.nil?
      res[name] ||= 0
      res[name]  += 1
      res
    end
  end
end

if __FILE__ == $0
  replies = Tweetion.replies.sort_by { |key,val| -val }
  replies.map! { |key,val| "@#{key}: #{val}" }
  if limit = ARGV.delete('--limit') || ARGV.delete('-l')
    puts replies[0..ARGV.last.to_i]
  else
    puts replies
  end
end
