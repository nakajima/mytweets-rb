require 'open-uri'
require 'json'

begin
  require 'config.rb'
  raise ArgumentError unless defined?(USERNAME) and defined?(PASSWORD)
rescue LoadError, ArgumentError
  puts "You must define USERNAME and PASSWORD constants in config.rb"
  exit 1
end

class Retriever
  APIURL = 'http://twitter.com/statuses/user_timeline/'
  FORMAT = 'json'
  DEFAULT_TARGET = 'my-tweets.json'

  def initialize(target=DEFAULT_TARGET)
    @target_name = target
  end

  def retrieve
    page = 0

    if File.exist?(@target_name)
      results = JSON.parse(File.read(@target_name))
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
      body = open(uri, :http_basic_authentication => [USERNAME, PASSWORD]).read
    rescue OpenURI::HTTPError => e
      $stderr.puts("ERROR: #{e.message}", "Trying again in 1 minute.")
      sleep 60
      retry
    end

    tweets = JSON.parse(body)
    tweets.empty? ? false : tweets
  end

  def write(text)
    File.open(@target_name, 'w+') do |f|
      f.puts(text)
    end
  end
end

if ARGV.delete('--count') || ARGV.delete('-c')
  if ! File.exist?(Retriever::DEFAULT_TARGET)
    Retriever.new(*ARGV).retrieve
  end

  tweets = JSON.parse(File.read(Retriever::DEFAULT_TARGET))
  puts tweets.size
  exit 0
end

if ARGV.delete('--verbose') || ARGV.delete('-v')
  puts Retriever.new(*ARGV).retrieve
else
  Retriever.new(*ARGV).retrieve
end
