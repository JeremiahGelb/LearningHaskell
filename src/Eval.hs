module Eval (eval,lexTokens) where

import Text.Read (readMaybe)
import Data.List (intercalate)
import Data.Char (isDigit,isSpace)

eval :: String -> Integer
eval s = evalExpr(parse(lexTokens s))

data Token = 
    Lparen 
    | RparenToken 
    | PlusToken 
    | TimesToken 
    | DivToken 
    | MinusToken 
    | NegToken 
    | ValToken Integer deriving (Show)

lexTokens :: String -> [Token]
lexTokens s = disambiguate(tokenize $ filter (not . isSpace) s)

-- Turns a string with no whitespace into a list of tokens, but thinks all - are MinusToken
tokenize :: String -> [Token]
tokenize "" = []
tokenize ('+':rest) = PlusToken : tokenize rest
tokenize ('(':rest) = Lparen : tokenize rest
tokenize (')':rest) = RparenToken : tokenize rest
tokenize ('*':rest) = TimesToken : tokenize rest
tokenize ('/':rest) = DivToken : tokenize rest
tokenize ('-':rest) = MinusToken : tokenize rest
tokenize (c:cs) 
    | isDigit c = let (l, r) = span isDigit (c:cs)
                  in ValToken (read l) : tokenize r
    | otherwise = error $ "Lexer found an invalid character: " ++ [c]

-- discards unary plusses, and replaces MinusToken with NegToken as needed
disambiguate :: [Token] -> [Token]
disambiguate tokens = go True tokens
  where
    -- the bool argument to go represents if we are currently expecting a ValToken (so a minus would be unary negation)
    go _ [] = []

    go True  (PlusToken : ts) = go True ts 
    go False (PlusToken : ts) = PlusToken : go True ts

    go True  (MinusToken : ts) = NegToken : go True ts
    go False (MinusToken : ts) = MinusToken : go True ts

    go _ (Lparen : ts)    = Lparen : go True ts    -- After '(', unary is allowed
    go _ (ValToken n : ts)   = ValToken n : go False ts  -- After a number, must be binary
    go _ (RparenToken : ts)    = RparenToken : go False ts   -- After ')', must be binary
    go _ (TimesToken : ts) = TimesToken : go True ts -- After '*', unary is allowed
    go _ (DivToken : ts) = DivToken : go True ts

data Expr = Val Integer
          | Plus Expr Expr
          | Times Expr Expr
          | Div Expr Expr
          | Minus Expr Expr
          | Neg Expr
          deriving (Show)

parse :: [Token] -> Expr
parse ts = case parse1 ts of
    (e, []) -> e
    (_, leftover) -> error $ "Leftover tokens: " ++ show leftover


parse1 :: [Token] -> (Expr, [Token])
parse1 ts = 
    let (e, ts') = parse2 ts
    in process e ts' 
    where
        process larg (PlusToken : ts) = 
            let (rarg, ts') = parse2 ts
            in process (Plus larg rarg) ts'

        process larg (MinusToken : ts) = 
            let (rarg, ts') = parse2 ts
            in process (Minus larg rarg) ts'

        process e ts = (e, ts)

parse2 :: [Token] -> (Expr, [Token])
parse2 ts = 
    let (e, ts') = parse3 ts
    in process e ts'
    where
        process larg (TimesToken : ts) = 
            let (rarg, ts') = parse3 ts
            in process (Times larg rarg) ts'
        
        process larg (DivToken : ts) = 
            let (rarg, ts') = parse3 ts
            in process (Div larg rarg) ts'

        process e ts = (e, ts)

parse3 :: [Token] -> (Expr, [Token])
parse3 (ValToken v : ts) = (Val v, ts)
parse3 (NegToken : ts) = (Neg e, ts')
    where (e, ts') = parse3 ts

parse3 (Lparen:ts) = (e, ts') 
    where (e, RparenToken:ts') = parse1 ts

parse3 ts = error $ "Unexpected tokens: " ++ show ts

evalExpr :: Expr -> Integer
evalExpr (Val v) = v
evalExpr (Plus le re) = evalExpr le + evalExpr re
evalExpr (Minus le re) = evalExpr le - evalExpr re
evalExpr (Times le re) = evalExpr le * evalExpr re
evalExpr (Div le re) = (evalExpr le) `div` (evalExpr re)
evalExpr (Neg ue) = -(evalExpr ue)
