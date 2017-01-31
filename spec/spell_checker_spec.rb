require "spec_helper"

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
end
