# my-tweets

Fetches all of your tweets from Twitter, saving them to a json file.

## Setup (or: oauth sucks)

* Create a file in this directory named `config.rb`
* Create an app for my-tweets at twitter.com/apps (lame, right?)
* In config.rb:
  * Set `CONSUMER_KEY` to your consumer key
  * Set `CONSUMER_SECRET` to your consumer secret
* Find your app id (http://twitter.com/oauth_clients/details/THIS-IS-YOUR-APPID)
* Visit `http://dev.twitter.com/apps/YOUR-APP-ID/my_token`
* In config.rb:
  * Set `TOKEN` to your access token
  * Set `TOKEN_SECRET` to your access token secret
* Finally, set `USERNAME` in config.rb to whatever username you want to get tweets for.

Sucks, right?

## Usage

Then run the script:

    $ ruby mytweets.rb

You can also dump all of your tweets to the terminal as JSON if you want:

    $ ruby mytweets.rb --verbose

## Extras

Make sure you've already run `ruby mytweets.rb` before you attempt these.

### Search your Tweetion (all your tweets)

    $ ruby searcher.rb something

or:

    $ irb
    >> require 'searcher'
    => true
    >> Tweetion.search /hello/i

### See who you mention

    $ ruby mentions.rb

You can limit:

    $ ruby mentions.rb --limit 10

**Warning: You may be surprised at you talk to the most.**

### See who you reply to

    $ ruby replies.rb

Again, you can limit:

    $ ruby replies.rb --limit 10

Inspired by [github.com/simonw/mytweets](http://github.com/simonw/mytweets)