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

## Setup

After cloning the repo, install gems with `bundle install`.

## Running Benchmarks

Open an `irb` console with Bundler:

```
$ bundle exec irb
```

Load dependencies:

```
> Bundler.require
```

Load the file(s) with the benchmark(s) you wish to test:

```
> require './hash_test.rb'
```

Run the desired benchmarks(s):

```
> test_value_iteration
```