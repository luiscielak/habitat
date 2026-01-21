# Lo-Fi Wireframe Legend — Design B (Radiant Focus)

## Symbol Reference

### Containers
```
+----------------+
|    content     |   Standard container
+----------------+

/================\
|    content     |   Elevated card (depth)
\================/

[~~~~~~~~~~~~~~~~]   Glass/blur container

((   content   ))    Floating element
```

### Interactive Elements
```
[Button: Label]      Primary button
<Button: Label>      Secondary button
{Button: Label}      Ghost button

(O)                  Unchecked checkbox
(●)                  Checked checkbox (gradient)
(◐)                  Partial/loading state

[*]                  Icon
[***]                Icon group
```

### Progress & Status
```
○───────○           Progress ring (empty)
●━━━━━━━○           Progress ring (partial)
●━━━━━━━●           Progress ring (complete)

[|||||||   ]        Progress bar
[A1] [A2] [A3]      Dot indicators
```

### Form Elements
```
[Input: Placeholder________]   Text input
[Time: HH:MM AM]              Time picker
[Select: Value ▼]             Dropdown
```

### Navigation
```
← → ↑ ↓              Directional arrows
[TAB: Label]         Tab bar item
[TAB: Label*]        Active tab
⌄                    Swipe down indicator
⟨ ⟩                  Swipe left/right
```

## Spacing Scale
```
XS = 4px
S  = 8px
M  = 12px
L  = 16px
XL = 24px
2XL = 32px
3XL = 48px
```

## Grid Guidance
- Screen margins: L (16px)
- Card padding: L (16px)
- Element spacing: M (12px)
- Section spacing: XL (24px)

## Annotations
- `[A1]`, `[A2]`... = Content/behavior notes
- `[S1]`, `[S2]`... = Section labels
- `→ Screen Name` = Navigation target
- `FR-X` = Related functional requirement

## Design B-Specific Conventions
- Gradient elements marked with `~~~`
- Celebration states marked with `✨`
- Focus mode indicated with thick borders `║`
- Swipe gestures indicated with `⟨ ⟩` or `⌄`
