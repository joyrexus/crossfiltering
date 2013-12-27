assert = require 'assert'
d3 = require './lib/d3-time.js'
toDate = d3.time.format "%Y-%m-%d"

obama = 
  number: 44
  president: 'Barack Obama'
  birth_year: 1961
  death_year: null
  took_office: toDate.parse("2009-01-20")
  left_office: null
  party: 'Democratic'

yearsPrez = (begin, end) ->
  end ?= new Date()
  time = end - begin
  secs = time / 1000
  mins = secs / 60
  hours = mins / 60
  days = hours / 24
  years = days / 365

years = yearsPrez(obama.took_office, obama.left_office)

assert.ok 4.9 < years < 8   # about 5 years as of 27-12-2013 
