# SimpleNaiveBayes

This is a very simple naive bayes written in ruby.


## Installation

    $ gem install simple_naive_bayes

## Usage

```ruby
require 'simple_naive_bayes'
cl = SimpleNaiveBayes::NaiveBayes.new
cl.training("yes", ["Chinese", "Beijing", "Chinese"])
cl.training("yes", ["Chinese", "Chinese", "Shanghai"])
cl.training("yes", ["Chinese", "Macao"])
cl.training("no", ["Tokyo", "Japan", "Chinese"])

cl.classify(["Tokyo"])
```

show example.rb


## Supported Ruby Versions
Ruby 2.0.0

## Performance
To measure the performance of the filte, I tested.  
The datasource is publiccorpus (http://spamassassin.apache.org/publiccorpus/).  
This data is mail corpus, so I classify mails.  
Those mails have three type which is spam, easy_ham, hard_ham.  
The test script is publiccorpus_test.rb.  

### Data sources
#### Training Data
* http://spamassassin.apache.org/publiccorpus/20021010_easy_ham.tar.bz2
* http://spamassassin.apache.org/publiccorpus/20021010_hard_ham.tar.bz2
* http://spamassassin.apache.org/publiccorpus/20021010_spam.tar.bz2

#### Test Data
* http://spamassassin.apache.org/publiccorpus/20030228_easy_ham.tar.bz2
* http://spamassassin.apache.org/publiccorpus/20030228_hard_ham.tar.bz2
* http://spamassassin.apache.org/publiccorpus/20030228_spam.tar.bz2

### Result
* spam accuracy rate is 99.6% (498/500)
* easy ham accuracy rate is 99.8% (2497/2500)
* hard ham accuracy rate is 81.6% (204/250)

## License
MIT License

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
