# type: ignore
"""
Kitty kitten: toggle right (CURSOR_CLI) pane collapse/expand.
Uses only kitty Boss API (no subprocess / kitty executable).
See: https://sw.kovidgoyal.net/kitty/kittens/custom/#kitty-api-to-use-with-kittens
"""
from pathlib import Path

from kitty.boss import Boss
from kittens.tui.handler import result_handler

STATE_FILE = Path.home() / ".config/kitty/scripts/.state/pane_state.json"


def _read_state():
    if not STATE_FILE.exists():
        return {}
    try:
        return __import__("json").loads(STATE_FILE.read_text())
    except Exception:
        return {}


def _write_state(data):
    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
    STATE_FILE.write_text(__import__("json").dumps(data))


def _windows_in_active_tab(boss):
    """Yield (window_id, title, num_rows, num_cols) for windows in the active tab."""
    tab = boss.active_tab
    if tab is None:
        return
    wmap = getattr(boss, "window_id_map", {}) or {}
    tab_id = getattr(tab, "id", None)
    for wid, w in wmap.items():
        wtab = getattr(w, "tab", None)
        if wtab is not None and getattr(wtab, "id", None) != tab_id:
            continue
        if tab_id is None and getattr(w, "tabref", None) is not None:
            if getattr(w.tabref(), "id", None) != getattr(tab, "id", None):
                continue
        title = getattr(w, "title", None) or getattr(w, "window_title", "") or ""
        screen = getattr(w, "screen", None)
        if screen is None:
            continue
        rows = getattr(screen, "lines", 0) or 0
        cols = getattr(screen, "columns", 0) or 0
        yield (wid, str(title), int(rows), int(cols))


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, data, target_window_id, boss: Boss):
    tab = boss.active_tab
    if tab is None:
        return

    target = None
    for wid, title, rows, cols in _windows_in_active_tab(boss):
        if title == "CURSOR_CLI":
            target = (wid, rows, cols)
            break
    if target is None:
        return

    wid, rows, cols = target
    if cols <= 0:
        return

    state = _read_state()
    key = f"right_cols:{wid}"
    collapsed = cols <= 8

    if not collapsed:
        state[key] = cols
        _write_state(state)
        increment = -(cols - 1)
    else:
        restore_to = int(state.get(key, 45))
        increment = max(restore_to - cols, 1)

    if increment != 0:
        target_win = getattr(boss, "window_id_map", {}).get(wid)
        if target_win is not None:
            boss.call_remote_control(
                target_win,
                (
                    "resize-window",
                    "--match", f"id:{wid}",
                    "--axis", "horizontal",
                    "--increment", str(increment),
                ),
            )
