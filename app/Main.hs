module Main where

import Fib (fib)
import System.Environment (getArgs)

main :: IO ()
main = do
    args <- getArgs
    let n = case args of
              (x:_) -> read x :: Int
              []    -> 10
    putStrLn $ "Result: " ++ show (fib n)