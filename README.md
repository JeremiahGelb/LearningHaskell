# LearningHaskell

## Devcontainer Commands
See Makefile

## Docker

Build

```
docker build -t learning-haskell .
```

Run
```
# Calculates the 100th fib
docker run learning-haskell 100
```


Run Tests
```
docker build --progress=plain --target tester -t test_output .
```

