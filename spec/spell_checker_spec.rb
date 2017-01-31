require "spec_helper"
require 'benchmark'

describe SpellChecker do
  describe "by trie" do
    it "doesn't match" do
      dictionary_words = ["ab"]
      text_words       = ["ac"]
      result           = SpellChecker.by_trie(dictionary_words, text_words)

      expect(result).to eq(["ac"])
    end

    it "word is shorter than dictory's word" do
      dictionary_words = ["abc"]
      text_words       = ["ab"]
      result           = SpellChecker.by_trie(dictionary_words, text_words)

      expect(result).to eq(["ab"])
    end

    it "word is longer than dictory's word" do
      dictionary_words = ["abc"]
      text_words       = ["abcd"]
      result           = SpellChecker.by_trie(dictionary_words, text_words)

      expect(result).to eq(["abcd"])
    end
  end

  it "benchmark" do
    dictionary_words = File.read("spec/fixtures/dictionary.txt").split
    text_words       = File.read("spec/fixtures/texts/austen.txt").gsub(/_|\d/, " ").scan(/[\w']+/)

    Benchmark.bm(15) do |benchmark|
      benchmark.report(:brute_force)     { SpellChecker.brute_force(dictionary_words, text_words) }
      benchmark.report(:by_trie)         { SpellChecker.by_trie(dictionary_words, text_words) }
      benchmark.report(:by_hash_table)   { SpellChecker.by_hash_table(dictionary_words, text_words) }
      benchmark.report(:by_bloom_filter) { SpellChecker.by_bloom_filter(dictionary_words, text_words) }
    end

    # output:
    # SpellChecker
    # user     system      total        real
    # brute_force     162.660000   1.560000 164.220000 (168.961906)
    # by_trie           1.160000   0.100000   1.260000 (  1.305419)
    # by_hash_table     0.140000   0.000000   0.140000 (  0.145828)
    # by_bloom_filter   0.100000   0.010000   0.110000 (  0.108583)
  end
end
