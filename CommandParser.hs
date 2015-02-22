{-# LANGUAGE OverloadedStrings #-}

module CommandParser where
  import Data.Attoparsec.ByteString.Char8
  import Data.Attoparsec.Combinator
  import qualified Data.Text.Lazy as L
  import Data.Text.Encoding
  import Control.Applicative

  data Command = Retrieve | Delete | New deriving Show

  parseCommand :: Parser Command
  parseCommand = choice
    [ Retrieve <$ string "Retrieve"
    , Delete   <$ string "Delete"
    , New      <$ string "New"
    ]

  parseCommandAndArgument :: Parser (Command, Int)
  parseCommandAndArgument = do
    command <- parseCommand
    char ' '
    argument <- parseArgument
    return (command, argument)

  parseArgument :: Parser Int
  parseArgument = decimal

  parse :: L.Text -> Either String (Command, Int)
  parse s = parseOnly parseCommandAndArgument ((encodeUtf8 . L.toStrict) s)
