# ASCII Wireframe Legend

## Symbol Reference

### Containers & Structure
- `+------+` - Container border (top/bottom)
- `|      |` - Container border (sides)
- `+------+` - Container border (bottom)
- `[S1]`, `[S2]` - Section labels
- `[A1]`, `[A2]` - Annotation references

### UI Elements
- `[x]` - Checkbox (checked)
- `[ ]` - Checkbox (unchecked)
- `[*]` - Icon/SF Symbol
- `(O)` - Avatar/Circular element
- `[IMG:w×h]` - Image placeholder (width × height)
- `[Button: Label]` - Button with label
- `[Input: Placeholder]` - Text input field
- `[Select: Value]` - Dropdown/select field
- `✓` - Checkmark (completed)
- `·` - Dot (incomplete/empty)

### Navigation
- `←` - Back/Previous button
- `→` - Next/Forward button
- `[Tab: Name]` - Tab bar item

### Content
- `Text content` - Regular text
- `"Quoted text"` - Example content or placeholder
- `# Header` - Section header
- `---` - Divider/separator

## Spacing Guidelines

- **XS (4pt)**: Minimal spacing between tightly related elements
- **S (8pt)**: Standard spacing between related elements
- **M (16pt)**: Medium spacing between sections
- **L (24pt)**: Large spacing between major sections
- **XL (32pt)**: Extra large spacing for screen-level separation

## Grid & Layout

- Mobile viewport: 375×812px (iPhone standard)
- Content margins: 20pt (left/right)
- Touch targets: Minimum 44pt height
- Section padding: 16pt (internal)

## Navigation Conventions

- Tab bar at bottom (Home, Daily, Weekly)
- Navigation arrows for date navigation
- "Today" button to jump to current date
- Tap on grid cells to navigate to Daily View

## State Indicators

- Empty state: Show placeholder content
- Loading state: `[Loading...]`
- Error state: `[Error: message]`
- Success state: `[Success]` or visual indicator

## Annotations Format

Each annotation follows this pattern:
```
A1: Description of element or behavior
A2: Interaction details or state information
```

## Flow Hooks

- `→ Screen Name` - Navigate to next screen
- `← Screen Name` - Navigate to previous screen
- `↑ Action` - User action that triggers navigation
