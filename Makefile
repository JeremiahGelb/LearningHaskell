# --- Variables ---
EXE_NAME = learning-haskell-exe
CABAL = cabal

# --- High Level Commands ---

.PHONY: build test run repl clean

# Build the library and executable
build:
	$(CABAL) build -j

# Run the test suite with full details
test:
	$(CABAL) test --test-show-details=always

# Run the application (defaults to n=10)
run:
	$(CABAL) run $(EXE_NAME) -- $(ARGS)

# Start the REPL for the library
repl:
	$(CABAL) repl lib:learning-haskell

# Clean build artifacts
clean:
	$(CABAL) clean
	rm -rf bin/