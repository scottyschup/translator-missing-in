## Translator Missing In
Fun with Google Translate.

## Basic Info
This project doesn't really have any purpose, other than to create nonsensical phrases from recognizable quotes. For funsies.

Eventually, I hope to automate it and connect it to the newly minted @translate_lost Twitter account. Then you can tweet a message @translate_lost and it will respond with some nonsense and the specific chain of languages that produced said nonsense.

Fun, right? I know.

For now, it's just a Ruby module. It can be played with in an interactive Ruby terminal. I like `pry`.

## Getting Started
For now, to use this you need your own Google Translate API key. Here's how to get one:
* First, go to the [Google Translate API part of the Google APIs console](https://console.developers.google.com/apis/api/translate/overview)
* Next, click the "Create Project" button. Twice apparently. Call your new project whatever.
* Now click the "Enable" link next to the "Google Translate API" heading. This will require you to put in billing info, but it's free for 2 months.
* Once you've enabled the Translate API, click on the Credentials tab on the left.
* Click the "Create Credentials" button and select "API key" from the dropdown list.
* Copy the API key. In your interactive Ruby terminal, create a new instance of the translator like so:
```rb
translator = TranslatorMissingIn::Translator.new(api_key: 'yourCrazyLongApiKeyHere')
```
* Alternately, you can set an environment variable
```sh
export GTRANS_API_KEY=yourCrazyLongApiKeyHere
```
Then whenever you instantiate a new translator, you don't need to pass in the API key. The program will use `GTRANS_API_KEY` by default. Put this in your `.*shrc` file if you don't want to have to retype it every time you start a new shell session.

## Usage
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
* For a **simple translation**, the `TranslatorMissingIn::Translator#translate` method takes a `text` argument, and `to` and `from` keyword arguments. `to` and `from` both accept ISO-639-1 language codes or `Google::Cloud::Translate::Language` objects, and if either  is omitted, the base language is used by default. So usually only one is necessary.
```rb
translator.translate('Lost in translation', to: 'es')
=> "Perdido en la traducción"
```
* For a **translation chain**, the `TranslatorMissingIn::Translator#translation_chain` method takes a `text` argument (string), an `iterations` keyword arg (integer) that specifies the number of languages to cycle through (default: 20), and an `alternate_base` keyword arg (boolean) that indicates whether to translate back to the base language between each language pair (default: false).  
I.e. `alternate_base: false` could result in `English -> Spanish -> Zulu -> Armenian -> ... -> English`, whereas `alternate_base: true` would result in `English -> Spanish -> English -> Zulu -> English -> Armenian -> English -> ... -> English`. This is mostly for testing purposes and for seeing which languages introduce problems or errors in the chain.

## Fun Facts
The name, "Translator Missing In" came from running the phrase "Lost in Translation" through the program. But because the language chain used is randomized each time, the program is non-deterministic and the results of running the same phrase multiple times will usually be different. Your results may vary.

## Now You Try
If you can't think of sayings to run through the program, [here's a big list of popular sayings](http://www.curatedquotes.com/famous-quotes/).
