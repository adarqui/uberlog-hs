Uberlog-Hs
==========

UberLog Haskell Client.


Example
=======

```
make
for i in `seq 1 100`; do ./.cabal-sandbox/bin/post namespace level category slug "[(\"counter\",\"$i\")]" "{\"i\":\"$i\"}"; done
```
