# Filtering by Regex

This is a quick [crossfilter](https://github.com/square/crossfilter) demo
showing how you can filter a dimension of your dataset (where the dimension
consists of string values) using a regular expression:

```
regex = /pattern/
dimension.filter (value) -> regex.test value
```


## Preliminaries

Used below for testing:

    {ok, eq, deepEqual} = require 'assert'
    isEqual = deepEqual

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

    presidents = require '../tutorial/presidents.json'

Alright, let's require `crossfilter` and initialize our dataset:

    crossfilter = require 'crossfilter'

    prez = crossfilter presidents

    ok prez.size() is 44


## Regex Matching

Alrighty, let's use the crossfilter force to filter our `prez` dataset with a
regular expression.  Our objective is to list all presidents whose last name begins with a "B":

    pattern = /B\w+$/
    matchingLastName = (value) -> pattern.test value

    byName = prez.dimension (p) -> p.president
    found = byName.filter(matchingLastName).top(Infinity)

    sortByNum = crossfilter.quicksort.by (d) -> d.number
    result = (p.president for p in sortByNum(found, lo=0, hi=found.length))

    expected = [ 
      'Martin Van Buren',
      'James Buchanan',
      'George H. W. Bush',
      'George W. Bush' 
    ]

   isEqual expected, result

