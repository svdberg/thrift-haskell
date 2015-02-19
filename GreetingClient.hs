module GreetingClient where
 import Network
 import Greet_Types
 import GreetingService_Client
 import Thrift.Transport.Handle
 import Thrift.Protocol.Binary
 import qualified Data.Text.Lazy as L

 runclient() = do 
   handle <- hOpen("localhost", PortNumber 7911)
   let m = Message {message_msg = L.empty }
   result <- greet (BinaryProtocol handle, BinaryProtocol handle) m
   print result
