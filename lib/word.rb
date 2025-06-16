class Word
  attr_accessor :word_list
  def initialize(word_list_location)
    @word_list = []
    File.open(word_list_location) do |f|
      f.readlines.each do |word|
        if word.include?("\n")
          word = word.gsub("\n", "")
        end
        @word_list.push(word) if word.size.between?(5, 12)
      end
    end
  end

  def get_word
    return word_list[Random.new.rand(word_list.length)]
  end

end

