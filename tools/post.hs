{-# LANGUAGE OverloadedStrings #-}
import System.Environment
import Control.Monad

import qualified Network.UberLog as Uber
import qualified Data.ByteString.Char8 as C

main :: IO ()
main = do
 argv <- getArgs
 case argv of
  (level:category:slug:params:[]) -> do
   con <- Uber.new Uber.defaultUrl
   putStrLn "posting..."
   _ <- Uber.log (p level) (p category) (p slug) (p params) con
   putStrLn "done."
  otherwise -> error "usage: ./post <level> <category> <slug> <json-string>"
 return ()
 where
  p s = C.pack s
