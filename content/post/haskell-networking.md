---
date: "2017-01-12"
title: "Haskell Networking"
---

I haven't done any Haskell in a while, so I decided to write a simple Echo service to grease the
rusty chain a little. I'll be working through the `network` library, as well as some concurrent
pieces of Haskell code.

I'll post the entirety of the code up front, and then walk through the sections one-by-one.

```haskell
module EchoServer (
    echoListen
) where

import qualified Data.ByteString.Lazy as LB

import Network as N
import Network.Socket as NS
import Network.Socket.ByteString.Lazy as NSB

import Control.Concurrent

-- | Listens on the socket forever, sending back all data received.
-- Loops until the client hangs up.
echoTCP :: Socket -> IO ()
echoTCP client = do c <- NSB.recv client 1024
                    if not (LB.null c)  -- Stop serving echoes when client hangs up
                        then NSB.sendAll client c >> echoTCP client
                        else return ()

-- | Listen on the provided port, echoing responses back to clients.
-- Listen indefinitely, spawning off a new green thread to serve each client.
echoListen :: (Integral a) => a -> IO ()
echoListen port = do sock <- listenOn $ PortNumber (fromIntegral port :: PortNumber)
                     chosenPort <- NS.socketPort sock
                     putStrLn $ "Listening on port " ++ show chosenPort
                     runServer sock
                  where
                    runServer s = do (client, addr) <- NS.accept s
                                     print $ "new client from " ++ (show addr)
                                     -- Fork off to serve new client
                                     forkIO $ do
                                        echoTCP client
                                        close client
                                     runServer s

```

Let's get into it!

## Setup

I'm using stack, which relies on the existing Cabal build system but keeps a repository separate
from Hackage called Stackage that contains releases of Hackage packages which are guaranteed to
all be compatible. This allows for very simple reproducible builds across platforms.

Haskell has no built-in networking APIs, meaning we need to pull in both the
[`network`](https://hackage.haskell.org/package/network) and
[`bytestring`](https://hackage.haskell.org/package/bytestring) packages, where the latter contains
some types exported by the `network` package that we wish to manipulate in our code.

I simply add a line to my `build-depends` in `echoserver.cabal` and the next time I run `stack
ghci` the dependency is downloaded and available for my code. I've reproduced part of my `.cabal`
file below, with some annotations.

```
name:                echoserver
cabal-version:       >=1.10
-- rest of this section elided
-- ...

library
  hs-source-dirs:      src
  exposed-modules:     Lib
  build-depends: base >= 4.7 && < 5
               , network >= 2.4
               , bytestring >= 0.10.8.1
  default-language:    Haskell2010

executable echoserver
  hs-source-dirs:      app
  main-is:             Main.hs
  ghc-options:         -threaded -rtsopts -with-rtsopts=-N
  build-depends:       base
                     , echoserver
  default-language:    Haskell2010
```

## Import Statements

Haskell is rather [infamous](https://twitter.com/GabrielG439/status/701871069607505921) for the
number of `import` statements it requires. In fact, there are often entire files dedicated to
re-exporting functions from submodules in the form of 100+ lines of `import` statements (I've
noticed that Rust libraries are starting to exhibit this property too).

Luckily, our example is simple enough to warrant only a few lines of imports:

```haskell
import qualified Data.ByteString.Lazy as LB

import Network as N
import Network.Socket as NS
import Network.Socket.ByteString.Lazy as NSB

import Control.Concurrent
```

It turns out that the modules `Network`, `Network.Socket` and `Network.Socket.ByteString.Lazy` all
provide overlapping functions that simply work over different types. `Network` is supposed to be a
high-level module for working with `Socket`s, `Network.Socket` is a bit lower level but exchanges
information using Haskell `String`s, while `Network.Socket.ByteString.Lazy` instead uses lazy
`ByteString`s for sending/recving, which are far more efficient than the basic `String`.

We also import `Control.Concurrent`, which is gives us access to the `forkIO` function which we'll
see again soon.


**Side Note**: There are (to my knowledge) three ways to do imports in Haskell, all of which are
put to use in this module.

1. `import Module.Name` : Imports all types exported by `Module.Name` into the name space using
   their exported name, or as `Module.Name.exportedName`.
2. `import qualified Module.Name as MN` : Imports all types from `Module.Name` into the name space,
   with their names of the form `MN.exportedName`.
3. `import Module.Name as MN` : Imports all types from `Module.Name` into the name space under
   their exported names, but they can also optionally be referred to usign `MN.exportedName`.

The first two are obvious, the third is so that we can use the nice terse syntax for referring to
imported types and functions when possible, but for collisions we can use the qualified name of the
type.

## Main Body

```haskell
echoListen :: (Integral a) => a -> IO ()
echoListen port = 
    do sock <- listenOn $ PortNumber (fromIntegral port :: PortNumber) -- (1) Allocate socket
       chosenPort <- NS.socketPort sock
       putStrLn $ "Listening on port " ++ show chosenPort
       runServer sock                                                  -- (2) Server loop
    where
        runServer s = do (client, addr) <- NS.accept s
                         print $ "new client from " ++ (show addr)
                         forkIO $ do                                   -- (3) Fork new green thread per-client
                            echoTCP client
                            close client
                         runServer s
```

This is basically just the main-body of the process, which does a few things

1. Allocate a socket to listen on for incoming clients
2. Begin main server loop, using Haskell tail-recursion instead of a `while`-loop as in other
   languages
3. Fork a new "green thread" for each incoming client connection.

Green threading is a user-land threading concept, that allows you to multiplex several logical
"threads" on top of a single operating system thread (also called "M:N threading"). Unlike OS
threads, green threads are cheap, and systems that use green threads can often have on the order of
thousands running simultaneously. `forkIO` is a function that takes an `IO` action and runs it in a
separate thread, in this case the action is to echo all input received over a socket back to the
sender, a very short piece of code we see in the next section.

## Echoing Logic

```haskell
echoTCP :: Socket -> IO ()
echoTCP client = do c <- NSB.recv client 1024
                    if not (LB.null c)  -- Stop serving echoes when client hangs up
                        then NSB.sendAll client c >> echoTCP client
                        else return ()
```

This is the function which implements the TCP echoing functionality (ideally I'll go back and add a
UDP version later, and can just swap out the use of `echoTCP` for `echoUDP`).

The server receives data in chunks of 1024 bytes from the client in the form of a lazy
`ByteString`. `Network.Socket.ByteString.Lazy` dictates that an empty `ByteString` being returned
from `recv` is the signal for the client having terminated the connection. We can see that as with
`runServer` above, we use the tail-recursive method of looping, here only recursing if the input
received is non-empty. If so, we send all bytes received back over to the client.

## Conclusion

While this example is short and simple, I hope some of the fundamentals of working on Haskell code
became a little clearer. I'm planning on working on a somewhat larger project utilizing Haskell
networking in the near future, stay tuned for updates on that front.

