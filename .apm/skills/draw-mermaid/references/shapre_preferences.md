# Shape preferences

### Drawing humans

Use a stickman, not a block

#### positive example
```mermaid
sequenceDiagram
    actor User
    participant System
    User->>System: Request
```

#### negative example
```mermaid
sequenceDiagram
    participant User
    participant System
    User->>System: Request
```