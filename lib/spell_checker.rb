require "spell_checker/version"
require 'bloomfilter-rb'

module SpellChecker
  A_ORD = 97

  class Trie < Struct.new(:node, :children, :is_end_of_word)
    def initialize(node, children = [], is_end_of_word = false)
      super
    end
  end

  class << self
    def brute_force(dictionary_words, text_words)
      misspelled_words = text_words.select do |word|
        ! dictionary_words.include? word
      end

      misspelled_words
    end

    def by_trie(dictionary_words, text_words)
      root = Trie.new(nil)
      misspelled_words = []

      # create trie
      dictionary_words.each do |word|
        trie = root
        word.each_char do |char|
          char_ord = char.ord - A_ORD
          char_ord = 26 if char_ord == -58 # for '

          trie.children[char_ord] ||= Trie.new(char)
          trie = trie.children[char_ord]
        end

        trie.is_end_of_word = true
      end

      # check words
      text_words.each do |word|
        trie = root
        i = 0

        downcase_word = word.downcase
        while i < downcase_word.length && trie
          chr  = downcase_word[i].chr
          chr_ord = chr.ord - A_ORD
          chr_ord = 26 if chr_ord == -58 # for '

          trie = trie.children[chr_ord]
          i += 1 if trie
        end

        # the word hasn't end or current trie is not a end of word 
        misspelled_words << word if i != downcase_word.length || !trie.is_end_of_word
      end

      misspelled_words
    end

    def by_hash_table(dictionary_words, text_words)
      dictionary = {}
      dictionary_words.each do |word|
        dictionary[word] = true
      end

      text_words.select do |word|
        downcase_word = word.downcase

        !dictionary[downcase_word]
      end
    end

    def by_bloom_filter(dictionary_words, text_words)
      dictionary = BloomFilter::Native.new(size: [dictionary_words.length * 6, 100].max, bucket: 4, raise: true, hashes: 4)

      dictionary_words.each do |word|
        dictionary.insert(word)
      end

      text_words.select do |word|
        downcase_word = word.downcase

        !dictionary.include? downcase_word
      end
    end
  end
end
