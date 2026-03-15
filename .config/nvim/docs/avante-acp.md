# Avante ACP Integration

Avante.nvim is integrated with the [Agent Client Protocol (ACP)](https://agentclientprotocol.com/overview/introduction), enabling AI agents that run as CLI subprocesses to communicate with Neovim over stdio. This gives you the capabilities of claude code, gemini-cli, codex, goose, and Cursor CLI directly inside Neovim.

## ACP Providers Configured

The following ACP providers are configured in `lua/common/plugins/avante.lua`:

| Provider       | Command / Package                         | Env var(s)              |
|----------------|-------------------------------------------|--------------------------|
| claude-code    | `npx @zed-industries/claude-code-acp`     | `ANTHROPIC_API_KEY`      |
| gemini-cli     | `gemini --experimental-acp`               | `GEMINI_API_KEY`         |
| codex          | `npx @zed-industries/codex-acp`           | `OPENAI_API_KEY`         |
| goose          | `goose acp`                               | (Goose auth)             |
| kimi-cli       | `kimi acp`                                | (Kimi auth)              |
| cursor-agent   | `npx @blowmage/cursor-agent-acp`          | (Cursor CLI auth)        |

The default provider is `claude-code`. Change it in `avante.lua` by editing the `provider` field.

## Prerequisites

### Claude Code ACP

- `npm install -g @zed-industries/claude-code-acp` (or use `npx` as configured)
- Set `ANTHROPIC_API_KEY` in your environment

### Gemini CLI

- Install the [Gemini CLI](https://ai.google.dev/gemini-api/docs)
- Set `GEMINI_API_KEY` in your environment

### Codex ACP

- `npm install -g @zed-industries/codex-acp` (or use `npx` as configured)
- Set `OPENAI_API_KEY` in your environment

### Cursor ACP

- Install [Cursor CLI](https://cursor.com/docs/cli): `curl https://cursor.com/install -fsSL | bash`
- Run `cursor-agent login` to authenticate
- `npm install -g @blowmage/cursor-agent-acp` (or use `npx` as configured)

## Zen Mode

Zen Mode provides a CLI-like experience inside Neovim. Launch it via:

```lua
:lua require("avante.api").zen_mode()
```

Or add a shell alias to launch Neovim directly in Zen Mode:

```bash
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
```

Then run `avante` from your terminal.

## Slash Commands and @ Mentions

**Slash commands** (e.g. `/help`, `/clear`, `/model`, `/new`) are executed by Avante and are **not** sent to the AI. Type `/` to see completion; select a command and press Enter or your submit key to run it.

- `/model` – Opens the model selector (switch provider/model)
- `/help` – Shows help for slash commands
- `/clear` – Clears chat history
- `/new` – Starts a new chat

**@ mentions** (e.g. `@file`, `@codebase`) should be selected from the completion menu. Type `@` to see options; selecting `@file` opens the file selector. Do not type these manually and submit—use completion so they are executed correctly.

## Project Instructions

Add an `avante.md` file in your project root to give the AI project-specific instructions. Avante will automatically load it when you work in that project.
