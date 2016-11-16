AB = Artificial.Babel
AM = Artificial.Mirage
LOI = LandsOfIllusions

# Command represents the words in a user command. Note that words in this context are semantic strings
# that can be made out of multiple lexical words (for example, 'look' and 'look at' both count as a word).
class LOI.Adventure.Parser.Command
  constructor: (@command) ->
    # Make lowercase and normalize (deburr) to basic latin letter.
    @normalizedCommand = _.toLower _.deburr @command
    @commandWords = @normalizedCommand.match /[-\w]+/g

    # We generate all possible multiple-word phrases as well.
    phrases = []
    wordsCount = @commandWords.length

    # Limit the longest phrases to 3 words.
    maxWordsInPhrase = Math.min 3, wordsCount

    for wordsInPhraseCount in [2..maxWordsInPhrase] by 1
      for i in [0..wordsCount-wordsInPhraseCount]
        wordsInPhrase = @commandWords[i..i+wordsInPhraseCount-1]
        phrase = wordsInPhrase.join ' '
        phrases.push phrase

    @commandWords = @commandWords.concat phrases

    console.log "Command has possible words", @commandWords if LOI.debug

  # Does this command include any of the words?
  has: (words) ->
    # If a single word is sent in, wrap it into an array.
    words = [words] if _.isString words

    for word in words
      # Make lowercase and normalize (deburr) to basic latin letter.
      word = _.toLower _.deburr word

      # We have the word if it is found somewhere in the command.
      return true if word in @commandWords

    # We didn't find the word.
    false
