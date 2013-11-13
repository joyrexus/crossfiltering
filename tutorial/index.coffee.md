# Exploring Crossfilter

Crossfilter enables you to define dimensions on your dataset, by which you can then filter, sort, group and reduce the dataset. Crossfilter creates indices for you, making this all very fast and efficient.

While you can certainly use crossfilter in a browser, I think its handy to
first experiment with it as a node module so you can focus on what it does
without the overhead required to visualize its effects. It's available as a
node package and you can install with `npm -g crossfilter`.  

Below, we'll be working through [this tutorial](http://eng.wealthfront.com/2012/09/explore-your-multivariate-data-with-crossfilter.html).


### Preliminaries

We're going to use D3's date-time methods for converting date strings into date
objects.  Since we're only using this one piece of D3, we've pulled out and
[rolled our own](http://bl.ocks.org/7393907) time component:

    d3 = require './lib/d3-time.js'

Used below for testing:

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

For our data records we're going to be working with a list of US Presidents:

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

    presidents = require './presidents.json'

To do date comparisons we're going to want to convert strings to date objects:

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


## First steps

Alrighty, let's use the crossfilter force! 

    crossfilter = require 'crossfilter'

    prez = crossfilter presidents

Check the size of our dataset:

    ok prez.size() is 44

Facet presidents by political party:

    byParty = prez.dimension (p) -> p.party

    parties = byParty.group()

If we group by this dimension we should have six parties total:

    ok parties.size() is 6

... viz.:

    partyList = (p.key for p in parties.top(Infinity))

    isEqual partyList, [ 
      'Republican',
      'Democratic',
      'Whig',
      'Democratic-Republican',
      'Federalist',
      'No Party' 
    ]

The `parties` grouping can be reduced in a variety of ways. Without an
explicit reduction, you get a count of each group by default. That is, each entry in the grouping consists of a key-value pair, where the key is a group name (a party) and the value is the number of items in the group (the number of presidents in that party).

Note how we use the `top` method, which lists the top *k* parties in our group.  If we pass `Infinity` as an argument, all items are returned.

    partyCount = toMap(parties.top Infinity)

    expected = 
      Republican: 18
      Democratic: 16
      Whig: 4
      'Democratic-Republican': 4
      Federalist: 1
      'No Party': 1

    isEqual partyCount, expected


## Filtering

Let's [filter](https://github.com/square/crossfilter/wiki/API-Reference#wiki-dimension_filter) our presidents by those who ran in the Whig party and display the resulting list of presidents [sorted](https://github.com/square/crossfilter/wiki/API-Reference#wiki-quicksort_by) by when they assumed office:

    whigs = byParty.filter("Whig").top(Infinity)
    sortByNum = crossfilter.quicksort.by (d) -> d.number

    result = (p.president for p in sortByNum(whigs, lo=0, hi=whigs.length))

    expected = [ 
      'William Henry Harrison',
      'John Tyler'
      'Zachary Taylor'
      'Millard Fillmore'
    ]

    isEqual result, expected

Note that we have to sort the resulting `whigs` list above since the only order on this dimension is by party, whereas we want the final list to be sorted by
presidential number.

OK, let's get all parties back:

    byParty.filterAll()


## Coordinated Views

We can of course add a second dimension to work in conjunction with the first.

Let's create a dimension for the year a president took office ...

    byDate = prez.dimension (p) -> p.took_office

... and filter out presidents starting before 1900:

    dateRange = [new Date(1900, 1, 1), Infinity]

    byDate.filter dateRange

We should find that there are 19 presidents that have taken office after 1900:

    modernPrez = byDate.bottom(Infinity)
    ok 19 is modernPrez.length

... the first being ...

    ok modernPrez[0].president is 'Theodore Roosevelt'

Note how our `byParty` dimension was also updated: 

    partyCount = toMap(parties.top Infinity)

    expected = 
      Republican: 11
      Democratic: 8
      Federalist: 0
      Whig: 0
      'No Party': 0
      'Democratic-Republican': 0

    isEqual partyCount, expected
