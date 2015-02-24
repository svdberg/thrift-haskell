module Main where
 import Network
 import Greet_Types
 import GreetingService_Client
 import Thrift.Transport.Handle
 import Thrift.Protocol.Binary
 import qualified Data.Text.Lazy as L

 main = do 
   putStrLn "Please enter your message"
   messageText <- getLine
   handle <- hOpen("localhost", PortNumber 7911)
   let m = Message {message_msg = L.pack messageText }
   result <- greet (BinaryProtocol handle, BinaryProtocol handle) m
   print result
   putStrLn "Continue? (y/n)?"
   con <- getLine
   continue <- case con of
     "y" -> return True
     "n" -> return False
     _   -> error "B0RK"
   if continue then main else return ()
