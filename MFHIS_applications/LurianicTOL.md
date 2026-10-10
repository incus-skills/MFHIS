Based on the structure of Lurianic Kabbalah, here is the complete Mermaid diagram representing the **Tree of Life of Partzufim**. This configuration maps the specific Sefirot into anthropomorphic "faces" (Partzufim), including **Keter** (which splits into two primary Partzufim) down to **Nukva**.

### Mermaid Diagram: Tree of Life of Partzufim

```mermaid
graph TD
    %% Styling
    classDef keter fill:#f9f9f9,stroke:#333,stroke-width:4px;
    classDef abba fill:#e3f2fd,stroke:#1565c0,stroke-width:2px;
    classDef imah fill:#fce4ec,stroke:#c2185b,stroke-width:2px;
    classDef zeir fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px;
    classDef nukva fill:#fff3e0,stroke:#ef6c00,stroke-width:2px;
    classDef hidden fill:#ffffff,stroke:#999,stroke-dasharray: 5 5;

    %% Top Level: Keter (Crown) splits into two Partzufim
    AK[("<b>Atik Yomin</b><br/>(The Ancient of Days)<br/>Inner Keter")]:::keter
    AA[("<b>Arich Anpin</b><br/>(The Long Face)<br/>Outer Keter")]:::keter
    
    %% Cognitive Level
    Abba[("<b>Abba</b><br/>(Father)<br/>Chokhmah/Wisdom")]:::abba
    Imah[("<b>Imah</b><br/>(Mother)<br/>Binah/Understanding")]:::imah
    
    %% Emotional Level
    ZA[("<b>Zeir Anpin</b><br/>(Small Face / Son)<br/>Chesed to Yesod")]:::zeir
    
    %% Behavioral Level
    Nukva[("<b>Nukva</b><br/>(Female / Daughter)<br/>Malchut/Kingship")]:::nukva

    %% Connections (Flow of Light/Influence)
    AK --> AA
    AA --> Abba
    AA --> Imah
    Abba --> ZA
    Imah --> ZA
    ZA --> Nukva

    %% Internal Structure Notes (Sub-sefirot within each Partzuf)
    note1["<i>Each Partzuf contains<br/>its own complete<br/>structure of 10 Sefirot</i>"]:::hidden
    note1 -.- AA
    note1 -.- Abba
    note1 -.- Imah
    note1 -.- ZA
    note1 -.- Nukva

    %% Layout adjustments for clarity
    linkStyle 0,1,2,3,4 stroke-width:2px,fill:none,stroke:#333;
```

### Structural Breakdown

The diagram illustrates the six primary Partzufim (configurations) that rectify the shattered vessels of the world of *Tohu*:

1.  **Keter Level (Crown)**:
    *   **Atik Yomin** (Ancient of Days): The inner, concealed aspect of Keter, associated with pure mercy and the resolution of all judgments.
    *   **Arich Anpin** (Long Face): The outer aspect of Keter, representing the divine will that extends patience to allow for creation. It serves as the source for the lower Partzufim.

2.  **Cognitive Level (Intellect)**:
    *   **Abba** (Father): Derived from *Chokhmah* (Wisdom). It represents the seminal flash of insight.
    *   **Imah** (Mother): Derived from *Binah* (Understanding). It represents the development and gestation of the insight.
    *   *Interaction*: Abba and Imah unite to conceive and birth the emotional attributes.

3.  **Emotional Level (Heart)**:
    *   **Zeir Anpin** (Small Face / Son): Composed of the six emotional Sefirot (*Chesed, Gevurah, Tiferet, Netzach, Hod, Yesod*). It represents the divine attributes as they interact with creation, often characterized by judgment balanced with mercy.

4.  **Behavioral/Physical Level (Action)**:
    *   **Nukva** (Female / Daughter / Rachel): Derived from *Malchut* (Kingship). She has no light of her own but receives from Zeir Anpin. She represents the indwelling divine presence (*Shekhinah*) and the vessel for divine manifestation in the physical world.




