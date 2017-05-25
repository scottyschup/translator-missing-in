# Translator Missing In
### Fun with Google Translate.
This project doesn't really have any purpose, other than to create nonsensical phrases from recognizable quotes. For funsies.

The Ruby program is written and currently I'm working on automating the process and connecting it to the newly minted @translate_lost Twitter account. Then you will be able to tweet a message @translate_lost and it will respond with some nonsense and the specific chain of languages that produced said nonsense.

Fun, right? I know.

At the moment it's just a Ruby module. It can be played with in an interactive Ruby terminal. I like `pry`.

## Usage
### Getting started with Google Translate
For now, to use this you need your own Google Translate API key. Here's how to get one:
* Go to the [Google Translate API part of the Google APIs console](https://console.developers.google.com/apis/api/translate/overview)
* Click the "Create Project" button. Twice apparently.
* Name your new project whatever. (Not literally "whatever", but just whatever you'd like to call it.)
* Click the "Enable" link next to the "Google Translate API" heading.
  * This will require you to put in billing info, but it's free for 2 months, I promise.
* Click on the "Credentials" tab on the left.
* Click the "Create Credentials" button and select "API key" from the dropdown list.
* Copy the generated API key.
* The API key will be used in creating a new instance of the `TranslatorMissingIn::Translator` like so:
```rb
translator = TranslatorMissingIn::Translator.new(api_key: 'yourCrazyLongApiKeyHere')
```
* Alternately, you can set an environment variable
```sh
export GTRANS_API_KEY="yourCrazyLongApiKeyHere"
```
Then whenever you instantiate a new `TranslatorMissingIn::Translator`, you don't need to pass in the API key. The program will use `GTRANS_API_KEY` by default. Put this in your `.*shrc` file if you don't want to have to retype it every time you start a new shell session.

### Translator Missing In setup
* Clone the repo.
* `cd` into the repo and open your interactive Ruby terminal.
* Require the `translator.rb` file (or load it if you're planning to make some changes of your own).
```rb
[1] pry(main)> require_relative 'translator'
```
or
```rb
[2] pry(main)> load 'translator.rb'
```
* Instantiate a new translator.
```rb
# don't forget the API key keyword arg if you didn't already set it as an env var
[3] pry(main)> translator = TranslatorMissingIn::Translator.new
```
By default, English is the base language (the language that the names of other languages are given in, and the expected input and output of language chains). This can be changed by instantiating the translator using the `base_lang_code` keyword arg and [an ISO-639-1 language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).

### Examples
* For a **simple translation**, the `TranslatorMissingIn::Translator#translate` method takes a required `text` argument, and `to` and `from` keyword arguments. `to` and `from` both accept ISO-639-1 language codes or `Google::Cloud::Translate::Language` objects, and if either `to` or `from` is omitted, the base language is used by default. So only one is required, but both may be specified.
```rb
[4] pry(main)> translator.translate('Lost in translation', to: 'es')
=> "Perdido en la traducción"
```
* For a **translation chain**, the `TranslatorMissingIn::Translator#translation_chain` method takes a required `text` argument (string), an optional `iterations` keyword arg (integer) that specifies the number of languages to cycle through (default: 10), and an optional `alternate_base` keyword arg (boolean) that indicates whether to translate back to the base language between each language pair (default: false).  
I.e. `alternate_base: false` could result in `English -> Spanish -> Zulu -> Armenian -> ... -> English`, whereas `alternate_base: true` would result in `English -> Spanish -> English -> Zulu -> English -> Armenian -> English -> ... -> English`. This is mostly for testing purposes and for seeing which languages introduce problems or errors into the chain.  
```rb
[5] pry(main)> translator.translation_chain 'this is a test', iterations: 5, alternate_base: true
Dutch
	This is a test
Bulgarian
	This is a test
Lithuanian
	Here test
Tajik
	Here test
Malay
	here exam
=> {:text=>"here exam",
 :path=>
  [["English", "this is a test"],
   ["Dutch", "dit is een test"],
   ["English", "This is a test"],
   ["Bulgarian", "Това е тест"],
   ["English", "This is a test"],
   ["Lithuanian", "Čia testas"],
   ["English", "Here test"],
   ["Tajik", "Дар ин ҷо санҷиши"],
   ["English", "Here test"],
   ["Malay", "di sini ujian"],
   ["English", "here exam"]]}
```
* You can get a list of all the available languages and their codes as an array of `Google::Cloud::Translate::Language` objects.
```rb
[6] pry(main)> translator.languages
=> [#<Google::Cloud::Translate::Language:0x007fe7ad1ce9a8 @code="af", @name="Afrikaans">,
 #<Google::Cloud::Translate::Language:0x007fe7ad1ce980 @code="sq", @name="Albanian">,
 #<Google::Cloud::Translate::Language:0x007fe7ad1ce958 @code="am", @name="Amharic">,
 #<Google::Cloud::Translate::Language:0x007fe7ad1ce908 @code="ar", @name="Arabic">,
 #<Google::Cloud::Translate::Language:0x007fe7ad1ce8e0 @code="hy", @name="Armenian">,
 ...]
```
* You can also get the `Google::Cloud::Translate::Language` object for a specific language if you know it's name or ISO-693-1 code.
```rb
[7] pry(main)> translator.language('Albanian')
=> #<Google::Cloud::Translate::Language:0x007fde00fbd278 @code="sq", @name="Albanian">
[8] pry(main)> translator.language('sq')
=> #<Google::Cloud::Translate::Language:0x007fde00fbd278 @code="sq", @name="Albanian">
```

## Fun Facts
The name, "Translator Missing In" came from running the phrase "Lost in Translation" through the program. But because the language chain used is randomized each time, the program is non-deterministic and the results of running the same phrase multiple times will usually be different. Your results may vary.

## Now You Try
If you can't think of sayings to run through the program, [here's a big list of popular sayings](http://www.curatedquotes.com/famous-quotes/).
