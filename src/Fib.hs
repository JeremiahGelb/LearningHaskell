module Fib (fib) where

-- We keep the internal list 'fibs' private to the module
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- | Returns the nth Fibonacci number (0-indexed)
fib :: Int -> Integer
fib n | n < 0     = error "Negative index not allowed"
      | otherwise = fibs !! n