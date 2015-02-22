{-# LANGUAGE OverloadedStrings #-}

module GreetRepository(store, delete, retrieve) where
  import Database.MySQL.Simple
  import Database.MySQL.Base.Types
  import Control.Monad
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

  deleteStatement :: Query
  deleteStatement = "DELETE FROM messages ORDER BY id DESC LIMIT ?"

  retrieveStatement :: Query
  retrieveStatement = "SELECT messages FROM messages ORDER BY id DESC LIMIT ?"

  retrieve :: Int -> IO [L.Text]
  retrieve n = do
    conn <- connect connectionInfo
    xs <- query conn retrieveStatement [n]
    forM xs $ \(Only message) -> return $ L.pack message

  store :: L.Text -> IO Word64
  store word = do
    conn <- connect connectionInfo
    let input = L.unpack word
    qString <- formatQuery conn updateStatement [input]
    print qString
    execute conn updateStatement [input]
    id <- insertID conn
    return id


  delete :: Int -> IO ()
  delete n = do
    conn <- connect connectionInfo
    qString <- formatQuery conn deleteStatement [n]
    print qString
    execute conn deleteStatement [n]
    return ()
