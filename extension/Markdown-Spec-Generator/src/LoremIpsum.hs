{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedLists            #-}
{-# LANGUAGE OverloadedStrings          #-}

module LoremIpsum
  ( LoremIpsum()
  ) where

import Data.Coerce
import Data.Data          (Data)
import Data.Foldable      hiding (toList)
import Data.List          (nub)
import Data.Text          (Text, unpack)
import Data.Typeable      (Typeable)
import Data.Vector        (Vector, (!))
import GHC.Exts
import GHC.Generics
import GHC.Ix

import BNF


newtype LoremIpsum = LI Int
  deriving newtype (Eq, Ord)
  deriving stock   (Data, Typeable, Generic)


instance Bounded LoremIpsum where

    maxBound = coerce terminus

    minBound = coerce (0 :: Int)


instance Enum LoremIpsum where

    toEnum   = coerce

    fromEnum = coerce

    enumFrom = flip enumFromTo maxBound

    enumFromTo x y =
      let start = coerce x :: Int
          stop  = coerce y :: Int
          vals  = [ start .. stop ] :: [Int]
      in  coerce <$> vals



instance Ix LoremIpsum where

    range = uncurry enumFromTo

    index r@(x,y) i
      | inRange r i = toEnum $ coerce i - coerce x
      | otherwise   = error $ unwords
          [ show i
          , "Is outside the range ("
          , show x
          , ", "
          , show y
          , ")"
          ]

    inRange (x,y) i = x <= i && i <= y

    rangeSize (x,y) = max 0 $ coerce x - coerce y


instance Show LoremIpsum where

    show x =
      let i = fromEnum x :: Int
          strs =
            [ "LoremIpsum@"
            , show i
            , "='"
            , unpack $ loremIpsum x
            , "'"
            ] :: [String]
      in  fold strs


instance HasNonTerminal LoremIpsum where

    nonTerminal = const "LOREMIPSUM"


instance HasProductions LoremIpsum where

    productionRule g x =
      let sym = nonTerminal x
      in  enumerableProductions g sym x


instance HasRuleByValue LoremIpsum where

    ruleOfValue = const $ ruleNadaDeps . fromList . pure . term . Terminal . Right . loremIpsum


instance HasSuffixSymbol LoremIpsum where

    suffix = nonTerminal


instance IsGrammar LoremIpsum where

    grammarBNF = enumerableGrammar


terminus :: Int
terminus = length corpus - 1


loremIpsum :: LoremIpsum -> Text
loremIpsum = (corpus !) . coerce


corpus :: Vector Text
corpus = fromList $ take 20 uniqueSet


uniqueSet :: [Text]
uniqueSet = nub
    [ "Lorem"
    , "ipsum"
    , "dolor"
    , "sit"
    , "amet,"
    , "consectetur"
    , "adipiscing"
    , "elit."
    , "Aliquam"
    , "mollis"
    , "velit"
    , "odio,"
    , "ac"
    , "accumsan"
    , "risus"
    , "euismod"
    , "at."
    , "Nunc"
    , "in"
    , "erat"
    , "sed"
    , "purus"
    , "gravida"
    , "scelerisque."
    , "Pellentesque"
    , "leo"
    , "lacus,"
    , "placerat"
    , "eu"
    , "dolor"
    , "ac,"
    , "pretium"
    , "vehicula"
    , "enim."
    , "Phasellus"
    , "varius"
    , "hendrerit"
    , "elit"
    , "id"
    , "tincidunt."
    , "Vivamus"
    , "bibendum"
    , "accumsan"
    , "quam"
    , "non"
    , "lobortis."
    , "Etiam"
    , "gravida,"
    , "tortor"
    , "vel"
    , "consectetur"
    , "rhoncus,"
    , "eros"
    , "felis"
    , "placerat"
    , "urna,"
    , "quis"
    , "maximus"
    , "mauris"
    , "leo"
    , "ut"
    , "erat."
    , "Sed"
    , "vel"
    , "dolor"
    , "a"
    , "lacus"
    , "suscipit"
    , "venenatis"
    , "in"
    , "eget"
    , "orci."
    , "Interdum"
    , "et"
    , "malesuada"
    , "fames"
    , "ac"
    , "ante"
    , "ipsum"
    , "primis"
    , "in"
    , "faucibus."
    , "Sed"
    , "nec"
    , "suscipit"
    , "nisl,"
    , "vel"
    , "iaculis"
    , "augue."
    , "Quisque"
    , "porttitor"
    , "faucibus"
    , "ligula,"
    , "ac"
    , "faucibus"
    , "purus."
    , "In"
    , "metus"
    , "velit,"
    , "pulvinar"
    , "id"
    , "gravida"
    , "eu,"
    , "malesuada"
    , "id"
    , "nisl."
    , "Nulla"
    , "tincidunt"
    , "finibus"
    , "rutrum."
    , "Vivamus"
    , "ultricies"
    , "lorem"
    , "lectus,"
    , "a"
    , "scelerisque"
    , "tellus"
    , "porta"
    , "id."
    , "Donec"
    , "lacinia"
    , "dui"
    , "turpis,"
    , "sed"
    , "sollicitudin"
    , "odio"
    , "sollicitudin"
    , "sed."
    , "Phasellus"
    , "velit"
    , "odio,"
    , "rhoncus"
    , "sed"
    , "lobortis"
    , "ac,"
    , "scelerisque"
    , "vitae"
    , "magna."
    , "Curabitur"
    , "lectus"
    , "ante,"
    , "egestas"
    , "in"
    , "varius"
    , "in,"
    , "vestibulum"
    , "sed"
    , "nulla."
    , "Maecenas"
    , "fermentum"
    , "tellus"
    , "non"
    , "diam"
    , "fermentum"
    , "maximus."
    , "Pellentesque"
    , "vulputate"
    , "id"
    , "nisl"
    , "fringilla"
    , "hendrerit."
    , "Quisque"
    , "et"
    , "sapien"
    , "augue."
    , "In"
    , "lobortis"
    , "interdum"
    , "sagittis."
    , "Suspendisse"
    , "imperdiet"
    , "quis"
    , "tellus"
    , "non"
    , "aliquet."
    , "Praesent"
    , "vestibulum"
    , "vehicula"
    , "est,"
    , "non"
    , "cursus"
    , "tellus"
    , "efficitur"
    , "id."
    , "Nunc"
    , "nec"
    , "interdum"
    , "diam."
    , "Etiam"
    , "vitae"
    , "congue"
    , "sapien."
    , "Proin"
    , "molestie"
    , "elementum"
    , "sem"
    , "ut"
    , "gravida."
    , "Vivamus"
    , "et"
    , "euismod"
    , "leo."
    , "In"
    , "nec"
    , "odio"
    , "orci."
    , "Integer"
    , "volutpat"
    , "sem"
    , "vel"
    , "ante"
    , "tincidunt"
    , "porta."
    , "Etiam"
    , "lobortis"
    , "facilisis"
    , "ligula,"
    , "consectetur"
    , "venenatis"
    , "nisi"
    , "sodales"
    , "sed."
    , "Duis"
    , "facilisis"
    , "arcu"
    , "ante,"
    , "vel"
    , "varius"
    , "magna"
    , "condimentum"
    , "in."
    , "Nunc"
    , "auctor"
    , "ligula"
    , "convallis"
    , "tristique"
    , "consectetur."
    , "Quisque"
    , "hendrerit"
    , "nisl"
    , "in"
    , "turpis"
    , "tempor,"
    , "a"
    , "cursus"
    , "magna"
    , "efficitur."
    , "Sed"
    , "augue"
    , "quam,"
    , "imperdiet"
    , "ut"
    , "est"
    , "in,"
    , "volutpat"
    , "consectetur"
    , "orci."
    , "Proin"
    , "velit"
    , "purus,"
    , "mattis"
    , "ut"
    , "justo"
    , "eu,"
    , "mattis"
    , "dictum"
    , "nisl."
    , "Pellentesque"
    , "aliquet"
    , "quam"
    , "ac"
    , "ex"
    , "laoreet"
    , "sodales."
    , "Nullam"
    , "pharetra,"
    , "mi"
    , "id"
    , "rhoncus"
    , "volutpat,"
    , "eros"
    , "orci"
    , "tempor"
    , "enim,"
    , "in"
    , "facilisis"
    , "nunc"
    , "lacus"
    , "non"
    , "dolor."
    , "Vestibulum"
    , "id"
    , "ante"
    , "eu"
    , "mauris"
    , "mollis"
    , "aliquet"
    , "sit"
    , "amet"
    , "ut"
    , "leo."
    , "In"
    , "at"
    , "eleifend"
    , "leo,"
    , "at"
    , "pulvinar"
    , "nisl."
    , "Fusce"
    , "id"
    , "aliquam"
    , "magna,"
    , "quis"
    , "accumsan"
    , "turpis."
    , "Nam"
    , "et"
    , "ligula"
    , "interdum,"
    , "commodo"
    , "metus"
    , "id,"
    , "malesuada"
    , "nisi."
    , "In"
    , "rhoncus"
    , "sed"
    , "nulla"
    , "in"
    , "suscipit."
    , "Suspendisse"
    , "eu"
    , "nibh"
    , "sit"
    , "amet"
    , "lectus"
    , "cursus"
    , "consequat"
    , "eget"
    , "nec"
    , "justo."
    , "Nullam"
    , "cursus,"
    , "eros"
    , "sed"
    , "lacinia"
    , "porta,"
    , "ipsum"
    , "ligula"
    , "molestie"
    , "nibh,"
    , "eget"
    , "sagittis"
    , "eros"
    , "libero"
    , "eu"
    , "quam."
    , "In"
    , "commodo"
    , "aliquam"
    , "tortor,"
    , "ut"
    , "tincidunt"
    , "erat"
    , "mattis"
    , "in."
    , "Quisque"
    , "venenatis"
    , "erat"
    , "vitae"
    , "urna"
    , "ultrices,"
    , "blandit"
    , "maximus"
    , "urna"
    , "ultricies."
    , "Ut"
    , "efficitur"
    , "maximus"
    , "gravida."
    , "Nulla"
    , "auctor"
    , "libero"
    , "a"
    , "odio"
    , "rhoncus"
    , "pretium."
    , "Donec"
    , "sodales"
    , "nunc"
    , "tempor"
    , "mattis"
    , "auctor."
    , "Integer"
    , "nec"
    , "interdum"
    , "turpis,"
    , "suscipit"
    , "maximus"
    , "orci."
    , "Duis"
    , "facilisis"
    , "sapien"
    , "sed"
    , "lacus"
    , "maximus"
    , "bibendum."
    , "Aenean"
    , "aliquam"
    , "risus"
    , "at"
    , "iaculis"
    , "consectetur."
    , "Nunc"
    , "in"
    , "ipsum"
    , "lacinia,"
    , "pellentesque"
    , "metus"
    , "ac,"
    , "rutrum"
    , "arcu."
    , "Duis"
    , "egestas"
    , "tortor"
    , "et"
    , "mauris"
    , "fringilla"
    , "dapibus"
    , "vel"
    , "sit"
    , "amet"
    , "dolor."
    , "Curabitur"
    , "libero"
    , "libero,"
    , "porta"
    , "id"
    , "diam"
    , "et,"
    , "varius"
    , "auctor"
    , "neque."
    , "Duis"
    , "erat"
    , "sapien,"
    , "eleifend"
    , "vel"
    , "semper"
    , "vitae,"
    , "feugiat"
    , "sed"
    , "purus."
    , "Vestibulum"
    , "vel"
    , "nibh"
    , "sit"
    , "amet"
    , "turpis"
    , "efficitur"
    , "luctus."
    , "Nulla"
    , "a"
    , "mattis"
    , "felis."
    , "Donec"
    , "nisl"
    , "quam,"
    , "rhoncus"
    , "non"
    , "justo"
    , "at,"
    , "congue"
    , "ultrices"
    , "massa."
    , "Lorem"
    , "ipsum"
    , "dolor"
    , "sit"
    , "amet,"
    , "consectetur"
    , "adipiscing"
    , "elit."
    , "Duis"
    , "sed"
    , "commodo"
    , "nibh,"
    , "id"
    , "condimentum"
    , "risus."
    , "Pellentesque"
    , "non"
    , "rhoncus"
    , "sapien,"
    , "in"
    , "congue"
    , "risus."
    , "Morbi"
    , "ullamcorper"
    , "laoreet"
    , "turpis"
    , "id"
    , "ultrices."
    , "Suspendisse"
    , "elementum"
    , "ex"
    , "nec"
    , "sem"
    , "dictum"
    , "dignissim."
    , "Donec"
    , "metus"
    , "purus,"
    , "iaculis"
    , "non"
    , "consequat"
    , "quis,"
    , "ornare"
    , "efficitur"
    , "ex."
    , "Nam"
    , "vulputate"
    , "in"
    , "quam"
    , "sit"
    , "amet"
    , "cursus."
    , "Maecenas"
    , "lacinia"
    , "aliquet"
    , "sem."
    , "Suspendisse"
    , "bibendum"
    , "gravida"
    , "neque"
    , "vel"
    , "imperdiet."
    , "Sed"
    , "rutrum"
    , "aliquam"
    , "dui,"
    , "ut"
    , "dictum"
    , "lorem"
    , "porttitor"
    , "ac."
    , "Fusce"
    , "a"
    , "gravida"
    , "ligula."
    , "Duis"
    , "vel"
    , "efficitur"
    , "turpis."
    , "Nullam"
    , "scelerisque,"
    , "nisi"
    , "vel"
    , "rutrum"
    , "ultrices,"
    , "diam"
    , "tortor"
    , "bibendum"
    , "nibh,"
    , "at"
    , "aliquet"
    , "enim"
    , "felis"
    , "eget"
    , "massa."
    , "Nullam"
    , "consectetur"
    , "egestas"
    , "leo,"
    , "et"
    , "sagittis"
    , "elit"
    , "feugiat"
    , "in."
    , "Nam"
    , "consequat"
    , "urna"
    , "eu"
    , "massa"
    , "feugiat,"
    , "non"
    , "cursus"
    , "diam"
    , "congue."
    , "Duis"
    , "quis"
    , "elit"
    , "nec"
    , "lectus"
    , "mollis"
    , "euismod"
    , "quis"
    , "eget"
    , "diam."
    , "Proin"
    , "vitae"
    , "ullamcorper"
    , "massa,"
    , "a"
    , "finibus"
    , "neque."
    , "Quisque"
    , "tristique,"
    , "nunc"
    , "at"
    , "facilisis"
    , "sollicitudin,"
    , "sem"
    , "nisl"
    , "dictum"
    , "erat,"
    , "a"
    , "volutpat"
    , "quam"
    , "nulla"
    , "sit"
    , "amet"
    , "diam."
    , "Maecenas"
    , "quis"
    , "lorem"
    , "erat."
    , "Vestibulum"
    , "ante"
    , "ipsum"
    , "primis"
    , "in"
    , "faucibus"
    , "orci"
    , "luctus"
    , "et"
    , "ultrices"
    , "posuere"
    , "cubilia"
    , "curae;"
    , "Etiam"
    , "sit"
    , "amet"
    , "tellus"
    , "sapien."
    , "Cras"
    , "sagittis,"
    , "mauris"
    , "eget"
    , "imperdiet"
    , "pretium,"
    , "mauris"
    , "mauris"
    , "interdum"
    , "ex,"
    , "ac"
    , "malesuada"
    , "nisi"
    , "nibh"
    , "vitae"
    , "lacus."
    , "Nam"
    , "imperdiet"
    , "eleifend"
    , "justo,"
    , "et"
    , "cursus"
    , "diam"
    , "porttitor"
    , "vel."
    , "Nullam"
    , "ultricies"
    , "nec"
    , "neque"
    , "eget"
    , "sodales."
    , "Sed"
    , "bibendum"
    , "condimentum"
    , "augue,"
    , "vitae"
    , "tincidunt"
    , "dolor"
    , "porttitor"
    , "a."
    , "Vivamus"
    , "elementum"
    , "dui"
    , "sed"
    , "accumsan"
    , "consequat."
    , "Nulla"
    , "mattis"
    , "ante"
    , "nec"
    , "turpis"
    , "tincidunt,"
    , "et"
    , "semper"
    , "nisl"
    , "iaculis."
    , "Morbi"
    , "vitae"
    , "ornare"
    , "lacus."
    , "Morbi"
    , "nisl"
    , "lectus,"
    , "interdum"
    , "eget"
    , "leo"
    , "sit"
    , "amet,"
    , "dignissim"
    , "euismod"
    , "lacus."
    , "Sed"
    , "sem"
    , "sem,"
    , "malesuada"
    , "eget"
    , "tristique"
    , "sit"
    , "amet,"
    , "volutpat"
    , "id"
    , "ex."
    , "Duis"
    , "sagittis"
    , "sem"
    , "quis"
    , "velit"
    , "dictum"
    , "porttitor."
    , "Ut"
    , "eu"
    , "erat"
    , "rhoncus,"
    , "mattis"
    , "leo"
    , "vel,"
    , "vehicula"
    , "lacus."
    , "In"
    , "imperdiet"
    , "leo"
    , "non"
    , "purus"
    , "tincidunt"
    , "pretium."
    , "Proin"
    , "fringilla,"
    , "massa"
    , "nec"
    , "ultrices"
    , "ornare,"
    , "nibh"
    , "purus"
    , "porttitor"
    , "quam,"
    , "congue"
    , "elementum"
    , "turpis"
    , "eros"
    , "in"
    , "lectus."
    , "Curabitur"
    , "sit"
    , "amet"
    , "nulla"
    , "vitae"
    , "justo"
    , "iaculis"
    , "scelerisque."
    , "Nunc"
    , "quis"
    , "quam"
    , "et"
    , "turpis"
    , "suscipit"
    , "sollicitudin"
    , "eu"
    , "ut"
    , "tellus."
    , "Phasellus"
    , "molestie"
    , "mauris"
    , "rutrum"
    , "finibus"
    , "tincidunt."
    , "Nam"
    , "ac"
    , "efficitur"
    , "neque."
    , "Maecenas"
    , "in"
    , "congue"
    , "neque,"
    , "a"
    , "volutpat"
    , "ante."
    , "Morbi"
    , "accumsan"
    , "porta"
    , "lectus."
    , "Donec"
    , "ut"
    , "fermentum"
    , "erat."
    , "Nam"
    , "et"
    , "semper"
    , "nisl."
    , "Integer"
    , "tempor"
    , "tincidunt"
    , "justo"
    , "ac"
    , "euismod."
    , "Morbi"
    , "ultrices"
    , "velit"
    , "ut"
    , "dui"
    , "venenatis"
    , "tempor."
    , "Nunc"
    , "pretium"
    , "augue"
    , "molestie"
    , "nunc"
    , "sollicitudin,"
    , "at"
    , "condimentum"
    , "enim"
    , "dictum."
    , "Morbi"
    , "in"
    , "urna"
    , "massa."
    , "Aliquam"
    , "quis"
    , "purus"
    , "euismod,"
    , "condimentum"
    , "eros"
    , "at,"
    , "elementum"
    , "orci."
    , "Nulla"
    , "facilisi."
    , "Aliquam"
    , "erat"
    , "volutpat."
    , "Nam"
    , "augue"
    , "justo,"
    , "iaculis"
    , "sed"
    , "iaculis"
    , "a,"
    , "porta"
    , "a"
    , "dolor."
    , "Phasellus"
    , "pretium"
    , "ultricies"
    , "posuere."
    , "Proin"
    , "vitae"
    , "rutrum"
    , "neque,"
    , "eu"
    , "imperdiet"
    , "eros."
    , "Ut"
    , "quis"
    , "elementum"
    , "nulla,"
    , "id"
    , "placerat"
    , "nulla."
    , "Duis"
    , "pharetra"
    , "eu"
    , "eros"
    , "vel"
    , "pulvinar."
    , "In"
    , "ut"
    , "hendrerit"
    , "orci,"
    , "id"
    , "lobortis"
    , "ex."
    , "Maecenas"
    , "non"
    , "congue"
    , "risus,"
    , "ac"
    , "iaculis"
    , "ex."
    , "Quisque"
    , "ac"
    , "libero"
    , "dui."
    , "Duis"
    , "sit"
    , "amet"
    , "dictum"
    , "quam."
    , "Nunc"
    , "vitae"
    , "ligula"
    , "dapibus,"
    , "tempus"
    , "urna"
    , "eu,"
    , "sollicitudin"
    , "odio."
    , "Donec"
    , "vitae"
    , "justo"
    , "eget"
    , "nunc"
    , "viverra"
    , "suscipit."
    , "Aliquam"
    , "erat"
    , "volutpat."
    , "Donec"
    , "nec"
    , "imperdiet"
    , "elit."
    , "Sed"
    , "elementum"
    , "nisi"
    , "lorem,"
    , "non"
    , "vulputate"
    , "lectus"
    , "tristique"
    , "vel."
    , "Suspendisse"
    , "sollicitudin,"
    , "velit"
    , "sed"
    , "semper"
    , "ultricies,"
    , "magna"
    , "lorem"
    , "accumsan"
    , "massa,"
    , "et"
    , "feugiat"
    , "ligula"
    , "libero"
    , "faucibus"
    , "dolor."
    , "Mauris"
    , "sed"
    , "urna"
    , "dictum"
    , "tellus"
    , "pharetra"
    , "efficitur."
    , "Sed"
    , "velit"
    , "justo,"
    , "ornare"
    , "sit"
    , "amet"
    , "arcu"
    , "sit"
    , "amet,"
    , "posuere"
    , "sollicitudin"
    , "tortor."
    , "Pellentesque"
    , "habitant"
    , "morbi"
    , "tristique"
    , "senectus"
    , "et"
    , "netus"
    , "et"
    , "malesuada"
    , "fames"
    , "ac"
    , "turpis"
    , "egestas."
    , "Donec"
    , "vel"
    , "sapien"
    , "ac"
    , "orci"
    , "bibendum"
    , "porttitor"
    , "eleifend"
    , "id"
    , "arcu."
    , "Sed"
    , "ac"
    , "est"
    , "purus."
    , "Nullam"
    , "maximus"
    , "ligula"
    , "dui,"
    , "vitae"
    , "ultrices"
    , "purus"
    , "varius"
    , "nec."
    , "Mauris"
    , "bibendum"
    , "semper"
    , "imperdiet."
    , "Etiam"
    , "ultrices,"
    , "mauris"
    , "elementum"
    , "placerat"
    , "consectetur."
    ]
