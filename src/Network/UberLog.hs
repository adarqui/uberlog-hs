{-# LANGUAGE OverloadedStrings #-}
module Network.UberLog (
 new,
 defaultUrl,
 log,
 debug,
 info,
 success,
 warning,
 error
) where

import Data.List
import Network.HTTP.Conduit
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as L
import Prelude hiding (log, error)

(<>) = C.append

defaultUrl = "http://127.0.0.1:9876"

new url = do
 parseUrl url

log :: C.ByteString -> C.ByteString -> C.ByteString -> C.ByteString -> Request -> IO (Response L.ByteString)
log level category slug params req = do
 withManager $
  httpLbs req
   { method = "POST"
   , path = "log/" <> (C.concat $ intersperse "/" [level, category, slug, ""])
   , queryString = params
   }

debug = log "debug"
info = log "info"
success = log "success"
warning = log "warning"
error = log "error"
