require 'google/cloud/translate'

module TranslatorInMissing
  # TranslatorInMissing::Translator wraps parts of Google::Cloud::Translate
  # and adds some methods for fun with machine translation
  class Translator
    attr_accessor :base_language
    attr_reader :translator

    def initialize(base_language_code: 'en', api_key: ENV['GTRANS_API_KEY'])
      @translator = Google::Cloud::Translate.new(key: api_key)
      languages(names_language: base_language_code)
      @base_language = language(base_language_code)
    end

    def languages(names_language: 'en')
      @languages ||= translator.languages(names_language)
    end

    def language(code_or_name)
      search_type = code_or_name.length > 3 ? 'name' : 'code'
      case search_type
      when 'name'
        languages.find { |language| language.name == code_or_name }
      when 'code'
        languages.find { |language| language.code == code_or_name }
      end
    end

    def reset_base_language(language)

    end

    def translate(text, from: base_language, to: base_language)
      to, from = language_codes_for(to, from)
      text = translator.translate(text, from: from, to: to).text
      text.gsub(/&#39;|ʻ/, '\'') # Addresses common encoding error introduced
      # by languages with apostrophe-like characters used for glottal stops
    end

    def translation_chain(text, iterations: 10, alternate_base: false)
      # chain_jlanguages = languages # use this instead of the next line for deterministic experimentation
      chain_jlanguages = languages.delete_if do |language|
        language.code == base_language.code
      end.sample(iterations)
      path = [[base_language.name, text]]

      current = base_language
      chain_jlanguages.each do |language|
        next if language.code == base_language.code
        if alternate_base && current.code != base_language.code
          text = translate(text, from: current)
          current = base_language
          path << [base_language.name, text]
          puts "\t#{text}"
        end
        text = translate(text, to: language.code, from: current)
        current = language
        path << [language.name, text]
        puts language.name
      end
      text = translate(text, from: current.code)
      puts "\t#{text}"
      path << [base_language.name, text]

      { text: text, path: path }
    end

    private

    def language_codes_for(*languages_arr)
      languages_arr.map do |lang|
        lang.class == Google::Cloud::Translate::Language ? lang.code : lang
      end
    end
  end
end
