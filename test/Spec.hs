import Fib (fib)
import Control.Exception (assert)

-- A simple test helper
testFib :: Int -> Integer -> IO ()
testFib input expected = do
    let result = fib input
    if result == expected
        then putStrLn $ "Test Passed: fib " ++ show input ++ " == " ++ show expected
        else error $ "Test Failed! Expected " ++ show expected ++ " but got " ++ show result

main :: IO ()
main = do
    putStrLn "Running tests..."
    testFib 0 0
    testFib 1 1
    testFib 5 5
    testFib 10 55
    -- testFib 10 99  -- Uncomment this to see a test failure
    putStrLn "All tests passed!"