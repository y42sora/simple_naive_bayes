require "simple_naive_bayes/version"
require 'set'

module SimpleNaiveBayes
    class NaiveBayes
=begin

    P(cat|doc) = P(doc|cat) * P(cat) / P(doc)

    P(doc) is stable, so don't care.

    P(cat) = @categories_count[cat] / @all_category_num

    P(doc|cat) = P(word1|cat) * P(word2|cat)....
    P(word1|cat) = T(cat, word1) / (T(cat, word1) + T(cat, word2) + ...)
    T(cat, word1) = @categories_word[cat][word]
    (T(cat, word1) + T(cat, word2) + ...) = sum(T(cat, word))  = @categories_all_word_count[cat]

    Additive smoothing

    P(word1|cat) = (T(cat, word1) + a)  / sum(T(cat, word) + a))
    sum(T(cat, word) + a) =  sum(T(cat, word)) + @all_word_set.length() * @additive = @laplace_categories_all_word_count[cat] 


    arg max P(cat|doc)  =  arg max log(P(cat|doc))
    log(P(cat|doc)) = log(P(doc|cat)) + log( P(cat))

    log(P(cat)) =  log(@categories_count[cat]) - log(@all_category_num)

    log(P(doc|cat)) = log(P(word1|cat)) + log(P(word2|cat)) + ....
    log(P(word1|cat)) = log(T(cat, word1)) - log(sum(T(cat, word)))


    http://aidiary.hatenablog.com/entry/20100613/1276389337
=end

      def initialize()
        @all_category_num = 0
        @all_word_set = Set.new
        @categories_count = Hash.new(0)

        @categories_word = Hash.new
        @categories_all_word_count = Hash.new(0)
        @laplace_categories_all_word_count = Hash.new(0)
        @additive = 0.5
      end

      """
      doc = [word1, word2, word3...]
      """
      def training(category, doc)
        @categories_count[category] += 1
        @all_category_num += 1

        @categories_word[category] = Hash.new(0) unless @categories_word.key?(category) 
        doc.each do |word|
          @all_word_set.add(word)
          @categories_word[category][word] += 1
          @categories_all_word_count[category] += 1
        end

        # sum(T(cat, word) + 1))
        # Additive smoothing
        @laplace_categories_all_word_count[category] = @categories_all_word_count[category] + @all_word_set.length() * @additive
      end

      # classify and return best category
      def classify(doc)
        result = classify_with_all_result(doc)

        best = result.max_by { |classify_relust| classify_relust[1] }
        best[0]
      end

      # classify and return all category's probability
      # get all log(P(cat|doc))
      # return [ [category1, probability1], [category2, probability2]... ]
      def classify_with_all_result(doc)
        result = []

        @categories_count.keys().each do |category|
          # log(P(doc|cat))
          document_category = calc_document_category(doc, category)

          # log(P(cat)) =  log(@categories_count[cat]) - log( @all_category_num )
          category_probability = Math.log2(@categories_count[category]) - Math.log2(@all_category_num)

          # log(P(cat|doc)) = log(P(doc|cat)) + log(P(cat))
          category_document_probability = document_category + category_probability

          result << [category, category_document_probability]
        end
        result
      end

      # log(P(doc|cat)) = log(P(word1|cat)) + log(P(word2|cat)) + ....
      def calc_document_category(doc, category)
        probability = 0

        # log(P(word1|cat)) + log(P(word2|cat)) + ....
        doc.each do |word|
          # log(T(cat, word1)) 
          # Additive smoothing
          category_word = Math.log2(@categories_word[category][word] + @additive) 

          # sum(T(cat, word) + 1))
          all_category_word = Math.log2(@laplace_categories_all_word_count[category])

          # log(P(word1|cat)) = log(T(cat, word1) + 1) - log(sum(T(cat, word) + 1))
          prob = category_word - all_category_word
          probability += prob if prob.finite?
        end
        probability
      end
    end
end
