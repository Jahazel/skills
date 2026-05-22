# Deepening

How to deepen a cluster of shallow modules safely, given its dependencies. Uses the vocabulary in [LANGUAGE.md](LANGUAGE.md).

## Dependency Categories

Classify each candidate's dependencies before proposing a solution. The category determines how the deepened module is tested across its seam.

### 1. In-process

Pure computation, in-memory state, no I/O. Always deepenable — merge the modules and test through the new interface directly. No adapter needed.

### 2. Local-substitutable

Dependencies with local test stand-ins (PGLite for Postgres, in-memory filesystem). Deepenable if the stand-in exists. Test with the stand-in running in the suite. The seam is internal; no port at the module's external interface.

### 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary (microservices, internal APIs). Define a **port** (interface) at the seam. The deep module owns the logic; the transport is injected as an **adapter**. Tests use an in-memory adapter. Production uses an HTTP/gRPC adapter.

_Recommendation shape_: "Define a port at the seam, implement an HTTP adapter for production and an in-memory adapter for testing, so the logic sits in one deep module even though it's deployed across a network."

### 4. True external (Mock)

Third-party services (Stripe, Twilio, etc.) you don't control. The deepened module takes the external dependency as an injected port; tests provide a mock adapter.

## Seam Discipline

- **One adapter = hypothetical seam. Two adapters = real seam.** Don't introduce a port unless at least two adapters are justified (typically production + test). A single-adapter seam is just indirection.
- **Internal seams vs external seams.** A deep module can have internal seams private to its implementation. Don't expose internal seams through the interface just because tests use them.

## Testing Strategy

- Old unit tests on shallow modules become waste once tests at the deepened module's interface exist — delete them.
- Write new tests at the deepened module's interface. **The interface is the test surface.**
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors — if a test changes when the implementation changes, it's testing past the interface.
