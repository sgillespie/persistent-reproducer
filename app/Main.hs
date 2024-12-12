{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
module Main where

import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Monad (void)


share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
  name String
  age Int Maybe default=0
  deriving Show
|]

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool "dbname=hacking" 1 $ liftSqlPersistMPool $ do
  runMigration migrateAll

  void $ insert (Person "John Doe" Nothing)
