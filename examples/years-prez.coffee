assert = require 'assert'
d3 = require '../lib/d3-time.js'
toDate = d3.time.format "%Y-%m-%d"

# Find difference in years between two dates
years = (begin, end) ->
  end ?= new Date()
  time = end - begin
  secs = time / 1000
  mins = secs / 60
  hours = mins / 60
  days = hours / 24
  years = days / 365

from = toDate.parse("2009-01-20")
to = toDate.parse("2011-08-20")

assert.ok 2 < years(from, to) < 3
