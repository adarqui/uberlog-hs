{-# LANGUAGE OverloadedStrings #-}
import System.Environment

import Network.HTTP.Types.Header
import qualified Network.UberLog as Uber
import qualified Data.ByteString.Char8 as C

main :: IO ()
main = do
 argv <- getArgs
 case argv of
  (namespace:level:category:slug:headers:params:[]) -> do
   ulog <- Uber.new Uber.defaultUrl (p namespace) (p category) (p slug) [("key","value")]
   putStrLn "posting..."
   _ <- Uber.log (p level) (p params) (read headers :: RequestHeaders) ulog
   putStrLn "done."
  _ -> error "usage: ./post <namespace> <level> <category> <slug> <headers> <json-string>"
 return ()
 where
  p s = C.pack s
