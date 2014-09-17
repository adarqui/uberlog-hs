{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
import Data.Aeson
import GHC.Generics
import System.Environment
import Control.Monad

import qualified Network.UberLog as Uber
import qualified Data.ByteString.Lazy as L

data Packet = Packet { _argv :: [String] } deriving (Show, Read, Generic)

instance ToJSON Packet
instance FromJSON Packet

main :: IO ()
main = do
 argv <- getArgs
 main' argv

main' argv = do
 con <- Uber.new Uber.defaultUrl
 putStrLn "posting..."
 forM_
  [Uber.debug, Uber.info, Uber.success, Uber.warning, Uber.error]
  (\fn -> fn "category" "slug" s con)
 putStrLn "done."
 where
  p = Packet { _argv = argv }
  s = L.toStrict (encode p)
