require 'rubygems'
require 'open-uri'
require 'json'
require 'oauth'

begin
  require 'config.rb'
  raise ArgumentError unless defined?(CONSUMER_KEY) and defined?(CONSUMER_SECRET) and defined?(TOKEN) and defined?(TOKEN_SECRET) and defined?(USERNAME)
rescue LoadError, ArgumentError
  puts "You must define CONSUMER_KEY, CONSUMER_SECRET, TOKEN, TOKEN_SECRET, and USERNAME config.rb"
  exit 1
end

class Retriever
  APIURL = 'http://twitter.com/statuses/user_timeline/'
  FORMAT = 'json'
  TARGET = 'my-tweets.json'

  def retrieve
    page = 0

    if File.exist?(TARGET)
      results = JSON.parse(File.read(TARGET))
      @since_id = results.last['id']
      $stderr.puts("Found #{results.size} tweets already retrieved. Updating...")
    else
      results = []
    end

    loop do
      page += 1

      $stderr.print("Fetching page #{page}... ")
      $stderr.flush

      if new_tweets = fetch(page)
        results += new_tweets
        results  = results.sort_by { |tweet| tweet['id'] }
        write results.to_json
        $stderr.puts('done.')
      else
        $stderr.puts('No more tweets.')
        break results.to_json
      end
    end

    results.to_json
  end

  def fetch(page=nil)
    uri = APIURL + USERNAME + '.' + FORMAT + '?count=200'
    uri += "&page=#{page}" if page
    uri += "&since_id=#{@since_id}" if @since_id

    begin
      body = request(uri)
    rescue OpenURI::HTTPError => e
      $stderr.puts("ERROR: #{e.message}", "Trying again in 1 minute.")
      sleep 60
      retry
    end

    tweets = JSON.parse(body)
    tweets.empty? ? false : tweets
  end

  def request(uri)
    # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
      :site => "http://api.twitter.com",
      :scheme => :header
    })

    # now create the access token object from passed values
    token_hash = {
      :oauth_token => TOKEN,
      :oauth_token_secret => TOKEN_SECRET
    }

    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    response = access_token.request(:get, uri)
    if response.code != "200"
      puts "Error. Response code was #{response.code}. Retrying..."
      sleep 5
      request(uri)
    else
      response.body
    end
  end

  def write(text)
    File.open(TARGET, 'w+') do |f|
      f.puts(text)
    end
  end
end

if ARGV.delete('--count') || ARGV.delete('-c')
  if ! File.exist?(Retriever::TARGET)
    Retriever.new.retrieve
  end

  tweets = JSON.parse(File.read(Retriever::TARGET))
  puts tweets.size
  exit 0
end

if ARGV.delete('--verbose') || ARGV.delete('-v')
  puts Retriever.new.retrieve
else
  Retriever.new.retrieve
end
