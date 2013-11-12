# Exploring Crossfilter

[Crossfilter](http://square.github.com/crossfilter/) provides fast n-dimensional filtering and grouping of records, enabling live histograms.  It's designed for exploring large multivariate datasets, where interactions consist of grouping by a dimension followed by incremental filtering and reducing along another dimension.

Have a look at the ...

* [Intro](http://square.github.io/crossfilter/)
* [API](https://github.com/square/crossfilter/wiki/API-Reference)
* [Examples](http://bl.ocks.org/phoebebright/raw/3822981/)
* [Custom filter functions](https://github.com/square/crossfilter/pull/36)

Note that there's a dimensional charting library based on D3 and Crossfilter
called [dc.js](http://nickqizhu.github.io/dc.js/). Looks convenient if
you're working on a web-based dashboard and cool with the predefined chart types.

If you're dealing with categorical data (e.g., surveys), try [catcorr.js](https://github.com/deanmalmgren/catcorrjs).

---

Currently [working through](tutorial/index.coffee.md) [this tutorial](http://eng.wealthfront.com/2012/09/explore-your-multivariate-data-with-crossfilter.html).
