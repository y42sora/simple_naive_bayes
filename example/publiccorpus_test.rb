# -*- coding: utf-8 -*-

# test script for http://spamassassin.apache.org/publiccorpus/
require 'find'
require 'simple_naive_bayes'

train_spam_folder = "20021010/spam"
train_ham_folder = "20021010/easy_ham"
train_hard_ham_folder = "20021010/hard_ham"

test_spam_folder = "20030228/spam"
test_ham_folder = "20030228/easy_ham"
test_hard_ham_folder = "20030228/hard_ham"

@header_regxp = /[\w-]*: .*/
@nb_classifier = SimpleNaiveBayes::NaiveBayes.new


# delete all mail header
# chek line is not mail header and befor line is blank
# it expect like that header

# X-Original-Date: Wed, 4 Dec 2002 11:54:45 +0000
# Date: Wed, 4 Dec 2002 11:54:45 +0000
# 
# 
# Hi,
# I think you need to give us a little more detailed information.
# ...
def get_context_from_file(filepath)
  context = []

  end_header = false
  before_line = "before"

  open(filepath) {|f|
    f.each {|line|
      line = line.encode("UTF-16BE", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8")
      line = line.chomp

      if before_line.empty?  and not line.empty? and not @header_regxp.match(line)
        end_header = true
      end

      context << line if end_header

      before_line = line
    }
  }
  context.join(" ")
end

# divide context string to word list
# return like [word1, word2, word3]
# and delete stopword that word length smaller than 3
def get_word_from_context(context)
  words = []

  context.split(" ").each do |word|
    if word[-1] == "." or word[-1]  == "," or
        word[-1] == "?" or word[-1]  == "!" or
        word[-1]  == ":" 

        word = word[0..-2]
    end

    words << word unless word.size < 3
  end

  words
end

def train_data_from_file(category, filepath)
  context = get_context_from_file(filepath)
  words = get_word_from_context(context)

  @nb_classifier.training(category, words)
end

def train_data_from_folder(category, folder)
  all_num = 0
  t0 = Time.now
  Find.find(folder) do |filepath|
    if File::ftype(filepath) == "file"
      train_data_from_file(category, filepath)
      all_num += 1
    end
  end
  t1 = Time.now

  puts "training #{category} #{t1 - t0} sec and #{all_num} file"
end


# check correct rate
def check_data_from_folder(category, folder)
  correct_num = 0
  all_num = 0

  t0 = Time.now
  Find.find(folder) do |filepath|
    if File::ftype(filepath) == "file"
      context = get_context_from_file(filepath)
      words = get_word_from_context(context)
      correct_num += 1 if category == @nb_classifier.classify(words)
      all_num += 1
    end
  end
  t1 = Time.now

  puts "check #{category} #{t1 - t0} sec"
  [all_num, correct_num]
end


train_data_from_folder("spam", train_spam_folder)
train_data_from_folder("ham", train_ham_folder)
train_data_from_folder("hard", train_hard_ham_folder)

puts "----check spam----"

ans = check_data_from_folder("spam", test_spam_folder)
puts "spam rate is " + (ans[1].to_f / ans[0]).to_s
puts "all #{ans[0]} correct #{ans[1]}"

puts "----check ham----"

ans = check_data_from_folder("ham", test_ham_folder)
puts "ham rate is " + (ans[1].to_f / ans[0]).to_s
puts "all #{ans[0]} correct #{ans[1]}"

puts "----check hard_ham----"

ans = check_data_from_folder("hard", test_hard_ham_folder)
puts "hard ham rate is " + (ans[1].to_f / ans[0]).to_s
puts "all #{ans[0]} correct #{ans[1]}"

=begin
training spam 2.337407645 sec and 501 file
training ham 7.85665402 sec and 2551 file
training hard 6.014818518 sec and 250 file
----check spam----
check spam 4.681404607 sec
spam rate is 0.996
all 500 correct 498
----check ham----
check ham 11.444270327 sec
ham rate is 0.9988
all 2500 correct 2497
----check hard_ham----
check hard 8.78753183 sec
hard ham rate is 0.816
all 250 correct 204
=end

