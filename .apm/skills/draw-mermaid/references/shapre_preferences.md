# Shape preferences

### Drawing humans

Use a stickman or person representation, not a generic block

#### Sequence diagram

##### positive example
```mermaid
sequenceDiagram
    actor User
    participant System
    User->>System: Request
```

##### negative example
```mermaid
sequenceDiagram
    participant User
    participant System
    User->>System: Request
```

#### C4 diagram

##### positive example
```mermaid
C4Context
    Person(user, "User", "User of the service")
    System(system, "System", "Delivers service")
    Rel(user, system, "Uses")
```

##### negative example
```mermaid
C4Context
    System(user, "User", "User of the service")
    System(system, "System", "Delivers service")
    Rel(user, system, "Uses")
```