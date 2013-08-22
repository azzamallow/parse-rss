express    = require 'express'
FeedParser = require 'feedparser'
request    = require 'request'

# init
app = express()

# configure
app.use express.bodyParser()
app.use express.compress()
app.use express.logger()
app.use app.router
app.use (err, req, res, next) ->
  console.error err.stack
  res.send 500, 'Something broke!'

# connect
app.get '/', (req, res) ->
  res.send '' unless req.query.feed?

  feed = []
  request(req.query.feed)
    .pipe(new FeedParser())
    .on('readable', ->
      feed.push this.read()
    )
    .on('end', ->
      res.send [feed[0], feed[1], feed[2], feed[3], feed[4], feed[5]]
    )

# start
port = process.env.PORT || 5000
app.listen port
console.log "Listing on port #{port}"

# Example
#  http://localhost:5000/?feed=http://sports.yahoo.com/nba/rss.xml