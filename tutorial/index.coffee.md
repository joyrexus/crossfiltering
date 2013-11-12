# Exploring Crossfilter

Crossfilter enables you to define dimensions on your dataset, by which you can then filter, sort, group and reduce the dataset. Crossfilter creates indices for you, making this all very fast and efficient.

Below, we're working through [this tutorial](http://eng.wealthfront.com/2012/09/explore-your-multivariate-data-with-crossfilter.html).

We're going to use D3's date-time methods for converting date strings into date
objects.  Since we're only using this one piece of D3, we've pulled out and
[rolled our own](http://bl.ocks.org/7393907) time component:

    d3 = require 'lib/d3-time.js'

Use below for testing:

    {ok, eq, deepEqual} = require 'assert'
    isEqual = deepEqual

Convenience method to convert an array of key/value maps to a map (i.e.,
associative array) for easier testing and reading:

    toMap = (arr) ->
      obj = {}
      obj[d.key] = d.value for d in arr
      obj

    sample = [ { key: "apple", value: 1 }, { key: "orange", value: 2 } ]

    isEqual {apple: 1, orange: 2}, toMap(sample)

Let's say we have a list of US Presidents:

```
var presidents = [
  {
    "number":1,
    "president":"George Washington",
    "birth_year":1732,
    "death_year":1799,
    "took_office":"1789-04-30",
    "left_office":"1797-03-04",
    "party":"No Party"
  },{
  ...
  },{
    "number":44,
    "president":"Barack Obama",
    "birth_year":1961,
    "death_year":null,
    "took_office":"2009-01-20",
    "left_office":null,
    "party":"Democratic"
  }
];
```

    presidents = require 'presidents.json'

Convert strings to date objects.

    toDate = d3.time.format "%Y-%m-%d"
    presidents.forEach (p) -> 
      p.took_office = toDate.parse(p.took_office)
      p.left_office = if p?.left_office \
        then toDate.parse(p.left_office) 
        else null

    last = presidents.length - 1

    obama = 
      number: 44
      president: 'Barack Obama'
      birth_year: 1961
      death_year: null
      took_office: toDate.parse("2009-01-20")
      left_office: null
      party: 'Democratic'

    isEqual presidents[last], obama

Use the crossfilter force! 

    crossfilter = require 'crossfilter'

    prez = crossfilter presidents

Check the size of our dataset:

    ok prez.size() is 44

Facet presidents by political party:

    byParty = prez.dimension (p) -> p.party

    parties = byParty.group()

If we group by this dimension we should have six parties total:

    ok parties.size() is 6

    partyCount = toMap(parties.top Infinity)

    expected = 
      Republican: 18
      Democratic: 16
      Whig: 4
      'Democratic-Republican': 4
      Federalist: 1
      'No Party': 1

    isEqual partyCount, expected
