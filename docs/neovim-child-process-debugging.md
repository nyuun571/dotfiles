# Debugging forked processes in Neovim

This is a **first step** toward child-process debugging, not a process-tree UI.

## Linux / WSL2 (GDB 14+)

The Neovim GDB DAP adapter now starts with:

- `set follow-fork-mode parent`: follow the parent when `fork()` returns
- `set detach-on-fork off`: retain the other inferior instead of detaching it
- `set follow-exec-mode new`: keep the old inferior when a followed process calls `exec()`

This lets GDB retain related processes, but **does not guarantee that nvim-dap can switch between inferiors through DAP**. GDB's native CLI supports `info inferiors` and `inferior N`; nvim-dap's REPL is a DAP evaluation console and is not guaranteed to accept native GDB inferior-selection commands.

### Reproducible smoke test

From the repository root, on Linux/WSL2:

```sh
cc -std=c11 -Wall -Wextra -g -O0 \
  -o /tmp/nvim-dap-fork-exec tests/dap/fork_exec.c
/tmp/nvim-dap-fork-exec
gdb --version
```

In Neovim, open `tests/dap/fork_exec.c`, place a breakpoint in `parent_work`, press `F5`, select `Launch (GDB)`, and enter `/tmp/nvim-dap-fork-exec`. Use `<leader>du` to show the debug UI, `F10` to step, and `<leader>dt` to terminate.

To verify GDB's *native* multi-inferior behavior independently of the DAP UI:

```sh
gdb -q /tmp/nvim-dap-fork-exec
```

In the GDB CLI:

```gdb
set follow-fork-mode parent
set detach-on-fork off
set follow-exec-mode new
break parent_work
break child_work
run
info inferiors
```

Note: `info inferiors` lists inferiors; selecting one with `inferior N` changes GDB's active inferior. The child may be stopped while the parent waits in `waitpid()`; use `info inferiors` and `inferior N` to inspect it. Expect `exec()` to replace the child's program image and possibly change the available source/symbols.

## macOS

CodeLLDB configuration is unchanged. Linux GDB `fork` settings do not apply to CodeLLDB, and complete parent+child simultaneous debugging on macOS is **not** claimed here. A separate investigation is needed.

## Follow-up

After verifying the actual DAP capabilities on Linux/WSL2, implement an optional process/inferior picker (possibly by switching sessions or attaching separately), with explicit macOS limitations. Avoid exposing a keymap that implies reliable inferior switching before that test passes.
