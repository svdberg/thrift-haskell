{-# LANGUAGE OverloadedStrings #-}

module GreetRepository(store) where
  import Database.MySQL.Simple
  import Database.MySQL.Base.Types
  import GHC.Word
  import qualified Data.Text.Lazy as L

  connectionInfo :: ConnectInfo
  connectionInfo = defaultConnectInfo {
    connectHost="127.0.0.1", --localhost doesnt work...
    connectDatabase="haskell", 
    connectUser="root",
    connectPort=3306,
    connectPassword="root123"
    }

  updateStatement :: Query
  updateStatement = "insert into messages (messages) values (?)"

  store :: L.Text -> IO Word64
  store word = do
    conn <- connect connectionInfo
    let input = L.unpack word
    qString <- formatQuery conn updateStatement [input]
    print qString
    execute conn updateStatement [input]
    id <- insertID conn
    return id
