require 'json'
require 'active_support'

$TWEETS = JSON.parse(File.read('my-tweets.json'))

ONE_YEAR_AGO = 1.year.ago.strftime('%m-%d-%Y')

class Tweetion
  def self.last_year
    $TWEETS.inject([]) do |res, tweet|
      created_at = DateTime.parse(tweet['created_at'])
      res << tweet if ONE_YEAR_AGO == created_at.strftime('%m-%d-%Y')
      res
    end
  end
end

if __FILE__ == $0
  last_year = Tweetion.last_year.map { |tweet| "- #{tweet['text']}" }
  if limit = ARGV.delete('--limit') || ARGV.delete('-l')
    puts last_year[0..ARGV.last.to_i]
  else
    puts last_year
  end
end
