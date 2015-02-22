module Main where
 import GreetingService_Iface
 import GreetingService
 import Greet_Types
 import Thrift.Server
 import qualified Data.Text.Lazy as L
 import Data.Text.Lazy.Encoding
 import GreetRepository
 import CommandParser

 data GREET = GREET
 instance GreetingService_Iface GREET where
   greet GREET Message { message_msg = m } = do
     return_msg <- processMessage m
     return Message { message_msg = return_msg }

 processMessage :: L.Text -> IO L.Text
 processMessage m = do
   message <- getMessage m
   return message

 getMessage :: L.Text -> IO L.Text
 getMessage m =
   case parse m of
       Right c ->
         case c of
           (Delete, n) -> do
             print "deleted"
             delete n
             return $ L.pack "Msg deleted"
           (Retrieve, n) -> do
             messages <- retrieve n
             return $ L.intercalate (L.pack ",") messages
           (New, n) -> return $ L.pack "New Msg"
       Left e -> do
          store m
          return $ L.append (L.pack "Received and stored: ") m

 main = runBasicServer GREET process 7911
