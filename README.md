# haangman

This is a console app implementation of hangman, made in Ruby. 

## Installation
1. Make a local copy of the repo
```bash
git clone git@github.com:lmaqungo/haangman.git
```
## Usage
1. Run the main program
```bash
ruby main.rb
```
2. After the completion of any round, you will be able to save the score. You will be given the option to load a particular game save when the program first loads. 

## FYI

- The score for a round is given by the number of remaining attempts after the secret word has been found. The game gives you 7 chances to make incorrect guesses. So if it took you 3 incorrect guesses to get the word, your score will be 4 points. 