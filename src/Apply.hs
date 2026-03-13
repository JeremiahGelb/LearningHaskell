module Apply (apply) where

-- recursively applies func f on arg a n times
apply :: Integral n => n -> (a -> a) -> a -> a
apply n f a | n < 0 = error "Can't apply a function a negative amount of times"
            | n == 0 = a -- applying a function 0 times gives back the input arg
            | otherwise = f(apply (n-1) f a)
