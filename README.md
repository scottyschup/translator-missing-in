# Translator Missing In
### Fun with Google Translate.
This project doesn't really have any purpose, other than to create nonsensical phrases from recognizable quotes. For funsies.

Eventually, I hope to automate it and connect it to the newly minted @translate_lost Twitter account. Then you can tweet a message @translate_lost and it will respond with some nonsense and the specific chain of languages that produced said nonsense.

Fun, right? I know.

For now, it's just a Ruby module. It can be played with in an interactive Ruby terminal. I like `pry`.

## Usage
### Getting started with Google Translate
For now, to use this you need your own Google Translate API key. Here's how to get one:
* Go to the [Google Translate API part of the Google APIs console](https://console.developers.google.com/apis/api/translate/overview)
* Click the "Create Project" button. Twice apparently.
* Name your new project whatever. (Not literally "whatever", but just whatever you'd like to call it.)
* Click the "Enable" link next to the "Google Translate API" heading.
  * This will require you to put in billing info, but it's free for 2 months, I promise. After that, I'm not sure what happens. I'll let you know in mid-January when I find out.
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
require_relative 'translator'
or
load 'translator.rb'
```
* Instantiate a new translator.
```rb
# don't forget the API key keyword arg if you didn't already set it as an env var
translator = TranslatorMissingIn::Translator.new
```
By default, English is the base language (the language that the names of other languages are given in, and the expected input and output of language chains). This can be changed with the `base_lang_code` keyword and [an ISO-639-1 language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
### Examples
* For a **simple translation**, the `TranslatorMissingIn::Translator#translate` method takes a required `text` argument, and `to` and `from` keyword arguments. `to` and `from` both accept ISO-639-1 language codes or `Google::Cloud::Translate::Language` objects, and if either  is omitted, the base language is used by default. So only one is required, but both may be specified.
```rb
translator.translate('Lost in translation', to: 'es')
=> "Perdido en la traducción"
```
* For a **translation chain**, the `TranslatorMissingIn::Translator#translation_chain` method takes a required `text` argument (string), an optional `iterations` keyword arg (integer) that specifies the number of languages to cycle through (default: 20), and an optional `alternate_base` keyword arg (boolean) that indicates whether to translate back to the base language between each language pair (default: false).  
I.e. `alternate_base: false` could result in `English -> Spanish -> Zulu -> Armenian -> ... -> English`, whereas `alternate_base: true` would result in `English -> Spanish -> English -> Zulu -> English -> Armenian -> English -> ... -> English`. This is mostly for testing purposes and for seeing which languages introduce problems or errors in the chain.  
```rb
pry(main)> translator.translation_chain 'this is a test', iterations: 5, alternate_base: true
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
* You can get a list of all the available languages and their codes
```rb
translator.languages
```

## Fun Facts
The name, "Translator Missing In" came from running the phrase "Lost in Translation" through the program. But because the language chain used is randomized each time, the program is non-deterministic and the results of running the same phrase multiple times will usually be different. Your results may vary.

## Now You Try
If you can't think of sayings to run through the program, [here's a big list of popular sayings](http://www.curatedquotes.com/famous-quotes/).
