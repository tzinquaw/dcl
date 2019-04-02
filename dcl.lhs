~~ Lexer for Toki Pona ~~
Authors: Jesse Frohlich & Andrew Wilson
License: GPL3

> import Data.List.Split
> import Data.Char
> import Control.Monad

A rough classification of words in Toki Pona

> data Lexeme = Content String     -- Noun, verb, modifier
>             | Borrow String      -- (always modifiers)
>             | Preposition String -- e, tawa, kepeken, lon, poka, &c.
>             | Seperator String   -- ",":".":"pi":[]:li
>             | Nonsense String    -- to collect errors
>             deriving (Show)


Lexer based on the lex function. This splits the string into words and
punctuation, each as their own string. Note that lex is designed to parse
haskell source code; the fact that it works for us is luck, and if something
goes wrong, it may not be a bad idea to switch to lexer' below.

> lexer :: String -> [String]
> lexer [] = []
> lexer s  = n : lexer s'
>   where [(n,s')] = lex s


Before discovering the lex function in Data.Char, we developed the function
lexer':

> cutAt :: Char -> String -> [String]
> cutAt a s = splitOn [a] s
> 
> trimSeperator :: String -> [String]
> trimSeperator s = if not . isAlpha $ c
>                      then init s : [[c]]
>                      else [s]
>                        where c = last s
> 
> lexer' :: String -> [String]
> lexer' = join . (map trimSeperator) . (cutAt ' ')

Context Free Grammar sturcture. Should contain nonterminals, terminals,
production rules, and a start symbol.

> data Tree node leaf = Node node (Tree node leaf) (Tree node leaf)
>                     | Leaf leaf
>                     deriving (Eq,Show)
>
>{- > data Terminal =  -}

< data Nonterminal = ContentPhrase
<                  | Content                -- a single word
<                  | SubjectPhrase
<                  | Predicate
<                  | Preposition
<                  | VerbPhrase
<                  | PrepositionalCluster
<                  deriving (Show)
<               -- | Terminal String
<               -- | Missing: taso as a particle, la as a context delimiter
< data Terminal = Terminal String deriving (Show)
               
Production rules:

> data ProductionRule = Nonterminal String [(ProductionRule,ProductionRule)]
>                     | Terminal Lexeme
>                     deriving (Show)
  
< etc.

< data CFG = 

< parse :: ProductionRule -> [Lexeme] -> [[Bool]]
< parse r s = all@(p:ps)
<   where
<     -- a list replacing each Lexeme with (the existence of) a terminal
<     -- production rule
<     p = 

Playground:

< a :: Main.Lexeme
< a = Seperator ","

> s = "mi wile e ni: mi kama sona e jan pi lon ni."
> p = lexer s
>

> Nonterminal "start" [(Content "mi", Predicate)
>                   ,(Content "sina", Predicate)
>                   ,(SubjectPhrase, Predicate)
>                   ]
> Nonterminal "subjectPhrase" [(ContentPhrase, Seperator "li")]

< ContentPhrase -> Content
<               | [Content, ContentPhrase]
<               | [ContentPhrase, Termial "pi", ContentPhrase]

Playtesting a tree

> t :: Tree Int Bool
> t = Node 3 (Node 5 (Leaf True) (Leaf False)) (Leaf False)

