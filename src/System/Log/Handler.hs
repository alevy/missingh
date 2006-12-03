{- arch-tag: Log handlers main definition
Copyright (C) 2004-2006 John Goerzen <jgoerzen@complete.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-}

{- |
   Module     : System.Log.Handler
   Copyright  : Copyright (C) 2004-2006 John Goerzen
   License    : GNU GPL, version 2 or above

   Maintainer : John Goerzen <jgoerzen@complete.org> 
   Stability  : provisional
   Portability: portable

Definition of log handler support

For some handlers, check out "System.Log.Handler.Simple" and
"System.Log.Handler.Syslog".

Please see "System.Log.Logger" for extensive documentation on the
logging system.

Written by John Goerzen, jgoerzen\@complete.org
-}

module System.Log.Handler(-- * Basic Types
                                LogHandler(..)
                               ) where
import System.Log
import IO

{- | All log handlers should adhere to this. -}

{- | This is the base class for the various log handlers.  They should
all adhere to this class. -}

class LogHandler a where
                   -- | Sets the log level.  'handle' will drop
                   -- items beneath this level.
                   setLevel :: a -> Priority -> a
                   -- | Gets the current level.
                   getLevel :: a -> Priority
                   -- | Logs an event if it meets the requirements
                   -- given by the most recent call to 'setLevel'.
                   handle :: a -> LogRecord -> String-> IO ()

                   handle h (pri, msg) logname = 
                       if pri >= (getLevel h)
                          then emit h (pri, msg) logname
                          else return ()
                   -- | Forces an event to be logged regardless of
                   -- the configured level.
                   emit :: a -> LogRecord -> String -> IO ()
                   -- | Closes the logging system, causing it to close
                   -- any open files, etc.
                   close :: a -> IO ()


