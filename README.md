# my-tweets

Fetches all of your tweets from Twitter, saving them to a json file.

## Usage

Create a file named `config.rb` in the same directory as `mytweets.rb` that
defines `USERNAME` and `PASSWORD` constants that contain your Twitter
credentials. Then run the script:

    $ ruby mytweets.rb

You can pass a file name if you want:

    $ ruby mytweets.rb other-tweets.json

You can also dump all of your tweets as JSON if you want:

    $ ruby mytweets.rb --verbose

## Extras

### Search your Tweetion (all your tweets)

    $ ruby searcher.rb something

or:

    $ irb
    >> require 'searcher'
    => true
    >> Tweet.search /hello/i

### See who you mention

    $ ruby mentions.rb

You can limit:

    $ ruby mentions.rb --limit 10

**Warning: You may be surprised at you talk to the most.**

Inspired by [github.com/simonw/mytweets](http://github.com/simonw/mytweets)