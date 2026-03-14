module Main where

import Listless (modifyList,toString)
import System.Environment (getArgs)
import System.IO (hFlush, stdout)
import Data.List (isPrefixOf)

-- The Loop: Handles I/O and recursion
mainLoop :: [String] -> IO ()
mainLoop items = do
    putStr "To-Do> "
    hFlush stdout           -- Ensures the prompt prints before we wait for input
    input <- getLine
    if input == "quit"
        then putStrLn "Goodbye!"
        else do
            let newItems = modifyList input items
            putStrLn $ toString newItems
            mainLoop newItems -- Recursive call with the UPDATED list

main :: IO ()
main = putStrLn "Commands: add <task>, del <item>" >> mainLoop []