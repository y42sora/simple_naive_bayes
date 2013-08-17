require 'simple_naive_bayes'

cl = SimpleNaiveBayes::NaiveBayes.new

data = [
  ["yes", ["Chinese", "Beijing", "Chinese"]],
  ["yes", ["Chinese", "Chinese", "Shanghai"]],
  ["yes", ["Chinese", "Macao"]],
  ["no", ["Tokyo", "Japan", "Chinese"]]
]

data.each do |cat, doc|
  cl.training(cat, doc)
end

test = ["Chinese", "Chinese", "Chinese", "Tokyo", "Japan"]

p cl.classify(test)
p cl.classify_with_all_result(test)