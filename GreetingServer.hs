module GreetingServer where
 import GreetingService_Iface
 import GreetingService
 import Greet_Types
 import Thrift.Server
 import qualified Data.Text.Lazy as L

 message :: L.Text
 message = L.pack "blah"

 data GREET = GREET
 instance GreetingService_Iface GREET where
   greet GREET Message { message_msg = m } = return Message { message_msg = message }

 serve() = runBasicServer GREET process 7911
