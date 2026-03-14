module Listless (modifyList, toString) where

import Text.Read (readMaybe)
import Data.List (intercalate)

modifyList :: String -> [String] -> [String]

modifyList ('a':'d':'d':' ':input) list = list ++ [input]

modifyList "clear" _ = []

modifyList ('d':'e':'l':' ':input) list = 
    case readMaybe input of
        Just x  -> take (x-1) list ++ drop x list
        Nothing -> list

-- base case. Does nothing
modifyList _ list = list

toString :: [String] -> String
toString [] = "[]"
toString taskList = "[\n" ++ indentedItems ++ "\n]"
  where
    formatLine (task, idx) = "  \"" ++ show idx ++ "\": " ++ show task
    indentedItems = intercalate ",\n" (map formatLine (zip taskList [1..]))

