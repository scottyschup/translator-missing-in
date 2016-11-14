require 'google/cloud/translate'

module TranslatorInMissing
  # TranslatorInMissing::Translator wraps parts of Google::Cloud::Translate
  # and adds some methods for fun with machine translation
  class Translator
    attr_accessor :base_lang
    attr_reader :translator

    def initialize(base_lang_code: 'en', api_key: ENV['GTRANS_API_KEY'])
      @translator = Google::Cloud::Translate.new(key: api_key)
      languages(names_lang: base_lang_code)
      @base_lang = language(base_lang_code)
    end

    def languages(names_lang: 'en')
      @languages ||= translator.languages(names_lang)
    end

    def language(lang_code)
      languages.find { |lang| lang.code == lang_code }
    end

    def translate(text, from: base_lang, to: base_lang)
      from = from.code if from.class == Google::Cloud::Translate::Language
      to = to.code if to.class == Google::Cloud::Translate::Language
      text = translator.translate(text, from: from, to: to).text
      text.gsub(/&#39;|ʻ/, '\'') #
    end

    def translation_chain(text, iterations: 10, alternate_base: true)
      # langs = languages.delete_if { |l| l.code == 'en' }.sample(iterations)
      langs = languages # use this for deterministic experimentation
      path = [[base_lang.name, text]]

      current = base_lang
      langs.each do |lang|
        next if lang.code == base_lang.code
        if alternate_base && current.code != base_lang.code
          text = translate(text, from: current)
          current = base_lang
          path << [base_lang.name, text]
          puts "\t#{text}"
        end
        text = translate(text, to: lang.code, from: current)
        current = lang
        path << [lang.name, text]
        puts lang.name
      end
      text = translate(text, from: current.code)
      puts "\t#{text}"
      path << [base_lang.name, text]

      { text: text, path: path }
    end
  end
end
