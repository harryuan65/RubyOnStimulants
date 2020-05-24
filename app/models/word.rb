# == Schema Information
#
# Table name: words
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Word < ApplicationRecord
  validates :name, presence: true
  has_many :definitions, dependent: :destroy
  has_many :examples, dependent: :destroy
  has_one :first_definition, ->{ order(id: :asc).limit(1) }, class_name: 'Definition'
  def self.document_word(word_to_query)
    begin
      word_to_query = word_to_query.strip.downcase
      return {success: false, error: "#{word_to_query} already exists"} unless !Word.exists?(name: word_to_query)
      doc = Nokogiri::HTML(
        RestClient.get("https://dictionary.cambridge.org/zht/%E8%A9%9E%E5%85%B8/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/#{word_to_query}",
        {:user_agent=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36"})
      )
      word_all_pos = []

      pos_all = doc.xpath("//div[@class='pr entry-body__el']")
      return {success: false, error: "Not found"} if pos_all.empty?
      pos_all.each do |pos|
        pos_and_first_tag = pos.search("div[@class='posgram dpos-g hdib lmr-5']")
        part_of_speech = pos_and_first_tag.search("span[@class='pos dpos']").text
        tag = pos_and_first_tag.search("span[@class='gram dgram']").text.gsub(/[^a-zA-Z\s]/,'')
        definitions = []
        def_blocks = pos.search("div[@class='def-block ddef_block ']")

        def_blocks.each do |def_block|
          separate_tag = def_block.search("span[@class='def-info ddef-info']").search("span[@class='gram dgram']").text.gsub(/[^a-zA-Z\s]/,'')
          tag = separate_tag if tag==""
          definition = def_block.search("div[@class='def ddef_d db']").text
          def_pack = {}
          def_pack['definition'] = definition
          def_pack['part_of_speech'] = part_of_speech
          def_pack['tag'] = tag
          #zh-tw translation and examples
          translation_and_examples = def_block.search("div[@class='def-body ddef_b']")
          zh_tw_translation = translation_and_examples.search("span[@class='trans dtrans dtrans-se ']").text
          def_pack['zh_tw_translation'] = zh_tw_translation
          def_pack['examples'] = []

          examples = translation_and_examples.search("div[@class='examp dexamp']")
          examples.each do |example|
            ex_pair = {}
            ex_pair['sentence'] = example.search("span[@class='eg deg']").text
            ex_pair['translation'] = example.search("span[@class='trans dtrans dtrans-se hdb']").text
            def_pack['examples'] << ex_pair
          end
          definitions.push(def_pack)
        end
        word_all_pos.push(definitions)
      end
      word_payload = word_all_pos.flatten # mix up different poses
      ActiveRecord::Base.transaction do
        new_word = Word.create!(name: word_to_query)
        word_payload.each do |definition|
          new_definition = new_word.definitions.create!(
            def_org: definition['definition'],
            part_of_speech: definition['part_of_speech'],
            zh_tw_translation: definition['zh_tw_translation'],
            tag: definition['tag']
          )
          examples = definition['examples']
          if examples.any?
            examples.each do |example|
              new_definition.examples.create!(
                word: new_word,
                sentence: example['sentence'],
                translation: example['translation']
              )
            end
          else
            new_definition.examples.create!(
              word: new_word,
              sentence: '沒有例句QQ',
              translation: '沒有例句QQ'
            )
          end
        end
        return {success: true, word: new_word}
      end
    rescue => exception
      return {
        success: false,
        error: exception.to_s
      }
    end
  end
end
