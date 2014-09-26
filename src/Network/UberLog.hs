{-# LANGUAGE OverloadedStrings, RecordWildCards #-}
module Network.UberLog (
 ULog,
 defaultUrl,
 new,
 log,
 debug,
 info,
 success,
 warning,
 error
) where

import Network.HTTP.Conduit
import Network.HTTP.Types
import System.Locale
import Data.Time.Format
import Data.Time.Clock
import Data.Time.ISO8601
import Data.List
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString as B
import Prelude hiding (log, error)

data ULog = ULog {
 _req :: Request,
 _level :: C.ByteString,
 _category :: C.ByteString,
 _slug :: C.ByteString
} deriving (Show)

(<>) = C.append

defaultUrl = "http://127.0.0.1:9876"

new url namespace category slug headers = do
 req' <- parseUrl url
 return ULog {
  _req = req' { method = "POST", requestHeaders = ("__namespace",namespace) : headers },
  _level = "info",
  _category = category,
  _slug = slug
 }

log :: C.ByteString -> B.ByteString -> RequestHeaders -> ULog -> IO (Response L.ByteString)
log level params headers ULog{..} = do
 t <- getFormattedTime
 let req = _req { requestHeaders = h ++ headers ++ [("__date",t)] }
 withManager $
  httpLbs req {
   path = "log/" <> (C.concat $ intersperse "/" [level, _category, _slug, ""]),
   requestBody = RequestBodyBS params
  }
 where
  h = requestHeaders _req

debug = log "debug"
info = log "info"
success = log "success"
warning = log "warning"
error = log "error"

getFormattedTime = do
 t <- getCurrentTime
 return $ C.pack $ formatISO8601Millis t
