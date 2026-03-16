import Fib (fib)
import Apply (apply)
import Listless (modifyList)
import qualified Eval 
import Control.Exception (assert)

-- A simple test helper
testF :: (Show a, Show b, Eq b) => [Char] -> (a -> b) -> a -> b -> IO ()
testF fname f input expected = do
    let result = f input
    if result == expected
        then putStrLn $ "Test Passed: " ++ fname ++ " " ++ show input ++ " == " ++ show expected
        else error $ "Test Failed! Expected " ++ show expected ++ " but got " ++ show result

main :: IO ()
main = do
    putStrLn "Running tests..."
    -- testF "fib" fib 0 0
    -- testF "fib" fib 1 1
    -- testF "fib" fib 5 5
    -- testF "fib" fib 10 55
    -- testF "Apply_TimesTwo_0_times" (apply 0 (*2)) 1 1
    -- testF "Apply_TimesTwo_1_times" (apply 1 (*2)) 1 2
    -- testF "Apply_TimesTwo_2_times" (apply 2 (*2)) 1 4
    -- testF "modifyList_add_milk"    (modifyList "add milk") ["bread"] ["bread", "milk"]
    -- testF "modifyList_clear"       (modifyList "clear")    ["bread"] []
    -- testF "modifyList_del_1"       (modifyList "del 1")    ["bread", "milk"] ["milk"]
    -- testF "modifyList_none"        (modifyList "unknown")  ["bread"] ["bread"]
    testF "eval" Eval.eval "1 + -2 * (3 + -(4 * 5 + 6)) - 7 * -8" 103
    testF "eval" Eval.eval "----5" 5
    testF "eval" Eval.eval "-1-1-1" (-3)
    testF "eval" Eval.eval "(1-1)-1" (-1)
    testF "eval" Eval.eval "1-(1-1)" 1
    putStrLn "All tests passed!"