## MERMAID DIAGRAM: Hermes Memory Plugin Integration

```mermaid
flowchart TB
    subgraph Hermes_Agent["Hermes Agent System"]
        direction TB
        H_Input[("Input: User Query")]
        H_Think["<think> Reasoning Block<br/>(Interpret → Plan)"]
        H_ToolCall["<tool_call> Action<br/>(Act)"]
        H_Response["<tool_response> Result<br/>(Constrain)"]
        H_Reorient["<think> Reorientation<br/>(Reorient → Investigate)"]
        H_Output[("Output: Final Response<br/>(Synthesize → Report)")]

        H_Input --> H_Think
        H_Think --> H_ToolCall
        H_ToolCall --> H_Response
        H_Response -->|Failure| H_Reorient
        H_Reorient -->|Loop| H_ToolCall
        H_Response -->|Success| H_Output
    end

    subgraph Memory_Plugin["Hermes Memory Plugin (Kernel)"]
        direction TB
        MP_API["API Surface:
        • store_memory()
        • retrieve_memory()
        • update_memory()
        • delete_memory()"]

        MP_Store["Storage Engine
        • JSON persistence
        • Versioned entries
        • Soft delete"]

        MP_Retrieval["Retrieval Model
        • Semantic (if available)
        • Tag overlap
        • Recency decay
        • Confidence weighting"]

        MP_Schema["Data Model
        • id (immutable)
        • timestamp
        • content
        • tags (flat)
        • source (user/agent/system)
        • confidence (0-1)
        • version (monotonic)
        • links (associative)"]

        MP_Contract["Hard Boundaries:
        ❌ No inference
        ❌ No reasoning
        ❌ No state
        ❌ No temporal reconstruction
        ❌ No narrative generation"]

        MP_API --> MP_Store
        MP_API --> MP_Retrieval
        MP_Store --> MP_Schema
        MP_Retrieval --> MP_Schema
        MP_Contract -.-> MP_API
    end

    subgraph Integration_Points["Integration Points"]
        IP_Store["store_memory()
        ↓
        Called after each <think>
        or successful <tool_response>"]

        IP_Retrieve["retrieve_memory()
        ↓
        Called during <think>
        to get relevant context"]

        IP_Update["update_memory()
        ↓
        Called when <tool_response>
        modifies existing knowledge"]

        IP_Link["links field
        ↓
        Explicit associative references
        (No semantic inference)"]
    end

    %% Connections
    H_Think -->|"Retrieves relevant context"| IP_Retrieve
    IP_Retrieve -->|"Returns memory entries"| H_Think

    H_ToolCall -->|"Stores action/outcome"| IP_Store
    H_Response -->|"Stores result"| IP_Store
    H_Reorient -->|"Updates understanding"| IP_Update

    H_Output -->|"Stores final synthesis"| IP_Store

    IP_Store -->|"Calls"| MP_API
    IP_Retrieve -->|"Calls"| MP_API
    IP_Update -->|"Calls"| MP_API
    IP_Link -->|"Uses"| MP_Schema

    %% Styling
    classDef hermes fill:#e1f5fe,stroke:#01579b,color:#000
    classDef plugin fill:#e8f5e9,stroke:#1b5e20,color:#000
    classDef integration fill:#fff3e0,stroke:#e65100,color:#000

    class H_Input,H_Think,H_ToolCall,H_Response,H_Reorient,H_Output hermes
    class MP_API,MP_Store,MP_Retrieval,MP_Schema,MP_Contract plugin
    class IP_Store,IP_Retrieve,IP_Update,IP_Link integration
```

---

## DIAGRAM EXPLANATION

### 1. Hermes Agent System (Blue)

The agent's natural cognitive loop:

- **Input** → User query triggers the cycle
- **Think** → Reasoning and planning (Interpret → Plan)
- **Tool Call** → Action execution (Act)
- **Response** → Result from tool (Constrain)
- **Reorient** → Failure handling and investigation (Reorient → Investigate)
- **Output** → Final synthesis and report (Synthesize → Report)

### 2. Memory Plugin (Green)

The minimal kernel system:

- **API Surface**: Four core operations (store, retrieve, update, delete)
- **Storage Engine**: JSON persistence with versioning
- **Retrieval Model**: Multi-signal ranking (semantic + tags + recency + confidence)
- **Data Model**: Canonical memory entry schema
- **Hard Boundaries**: Strict non-inference contract

### 3. Integration Points (Orange)

Where Hermes calls the memory plugin:

- **store_memory()**: Called after each think block or successful tool response
- **retrieve_memory()**: Called during think blocks to get relevant context
- **update_memory()**: Called when tool responses modify existing knowledge
- **links field**: Explicit associative references (no inference)

### Key Separation

The memory plugin is **stateless storage**—it does not:

- Interpret stored memory
- Evaluate truth
- Reconcile contradictions
- Build knowledge graphs
- Infer agent intent

Hermes provides all cognition; the memory plugin provides only persistence and associative retrieval.

---
