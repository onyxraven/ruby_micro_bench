# Ruby Micro-benchmarks

Compare like-behavior methods to determine the fastest method

## Goals

* Uses assertions at the end to ensure exact same behavior
* attempt to test for GC/object cost
* attempt to test for input/value variation
* use IPS, BigO, make pretty graphs
* Try to make collaborative
* Try on various ruby platforms to compare (travis!)
* add test for like-behavior from gems (activesupport, etc)

## Setup (for now)


After cloning the repo, install gems with `bundle install`.

## Running Benchmarks

Whole benchmark files can be run as follows:

```
$ bundle exec rspec spec/hash_spec.rb
```

To run a single example by name, use the following example:

```
$ bundle exec rspec spec/hash_test.rb -e 'iterate all values'
```

## Inspirations, References

* https://github.com/davy/benchmarking-ruby
* https://pragprog.com/book/adrpo/ruby-performance-optimization http://www.slideshare.net/adymo/adymo-rubyconfperformance-42024868
* https://rubybench.org/contributing (but for method comparson)
* http://greyblake.com/blog/2012/09/02/ruby-perfomance-tricks/
* http://dev.paperlesspost.com/blog/2015/02/19/different-methods-of-merging-ruby-hashes/

