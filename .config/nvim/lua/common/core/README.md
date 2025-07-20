# Smart Tab Configuration

This directory contains the smart tab functionality for Neovim, which provides intelligent tab behavior based on context.

## Features

### Smart Tab (`<Tab>` in insert mode)
The Tab key behaves intelligently based on the current context:

1. **Completion Menu Navigation**: When a completion menu (nvim-cmp or blink.cmp) is visible, Tab navigates to the next suggestion
2. **Snippet Expansion/Jumping**: When in a snippet context, Tab expands snippets or jumps to the next placeholder
3. **Intelligent Indentation**: When at the beginning of a line or in whitespace, Tab properly indents the line
4. **Completion Triggering**: When none of the above apply, Tab attempts to trigger completion or inserts a tab character

### Smart Shift-Tab (`<Shift-Tab>` in insert mode)
The Shift-Tab key provides reverse functionality:

1. **Completion Menu Navigation**: Navigate to the previous suggestion in completion menu
2. **Snippet Jumping**: Jump to the previous placeholder in snippets
3. **Unindentation**: Decrease indentation level

### Snippet Mode Support
Both Tab and Shift-Tab work in snippet mode (`s` mode) for:
- Jumping forward through snippet placeholders
- Jumping backward through snippet placeholders

## Compatibility

The smart tab system is designed to work with:
- **nvim-cmp**: Primary completion engine
- **blink.cmp**: Alternative completion engine (if available)
- **LuaSnip**: Snippet engine for expansion and navigation
- **Built-in indentation**: Fallback for basic tab functionality

## Implementation

The smart tab functionality is implemented in `smart-tab.lua` and automatically loads after all plugins are initialized to ensure proper integration with completion systems.

## Usage

Once configured, the smart tab functionality works automatically:

- Press `<Tab>` in insert mode for context-aware tab behavior
- Press `<Shift-Tab>` in insert mode for reverse tab behavior
- No additional configuration needed - it just works!

## Benefits

- **Improved Workflow**: Reduces the need to remember different key combinations for different contexts
- **Consistent Behavior**: Tab always does the "right thing" based on context
- **Plugin Integration**: Works seamlessly with existing completion and snippet plugins
- **Fallback Support**: Gracefully handles cases where plugins aren't available

