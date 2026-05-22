# Language

Shared vocabulary for every suggestion this skill makes. Use these terms exactly — don't substitute "component," "service," "API," or "boundary." Consistent language is the whole point.

## Terms

**Module**
Anything with an interface and an implementation. Scale-agnostic — applies equally to a function, class, package, or slice.
_Avoid_: unit, component, service.

**Interface**
Everything a caller must know to use the module correctly: type signature, invariants, ordering constraints, error modes, required configuration, performance characteristics.
_Avoid_: API, signature (too narrow).

**Implementation**
What's inside a module — its body of code.

**Depth**
Leverage at the interface — the amount of behaviour a caller can exercise per unit of interface they have to learn. **Deep** = large behaviour behind a small interface. **Shallow** = interface nearly as complex as the implementation.

**Seam**
A place where you can alter behaviour without editing in that place. The location at which a module's interface lives.
_Avoid_: boundary (overloaded with DDD's bounded context).

**Adapter**
A concrete thing satisfying an interface at a seam. Describes role (what slot it fills), not substance (what's inside).

**Leverage**
What callers get from depth. More capability per unit of interface they have to learn.

**Locality**
What maintainers get from depth. Change, bugs, knowledge concentrate at one place rather than spreading across callers.

## Principles

- **Deletion test** — Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, the module was earning its keep.
- **The interface is the test surface** — Callers and tests cross the same seam. If you want to test past the interface, the module is the wrong shape.
- **One adapter = hypothetical seam. Two adapters = real seam** — Don't introduce a seam unless something actually varies across it.

## Relationships

- A **Module** has exactly one **Interface**.
- **Depth** is a property of a **Module**, measured against its **Interface**.
- A **Seam** is where a **Module**'s **Interface** lives.
- An **Adapter** sits at a **Seam** and satisfies the **Interface**.
- **Depth** produces **Leverage** for callers and **Locality** for maintainers.

## Never substitute

- "component," "service," "unit" for **module**
- "API," "signature" for **interface**
- "boundary" for **seam**
- "layer," "wrapper" for **module** (when you mean module)
