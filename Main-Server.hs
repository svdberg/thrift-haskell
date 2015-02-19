module Main where
 import GreetingService_Iface
 import GreetingService
 import Greet_Types
 import Thrift.Server
 import qualified Data.Text.Lazy as L
 import GreetRepository

 message :: L.Text
 message = L.pack "blah"

 data GREET = GREET
 instance GreetingService_Iface GREET where
   greet GREET Message { message_msg = m } = do
     store(m)
     return Message { message_msg = m }

 main = runBasicServer GREET process 7911
