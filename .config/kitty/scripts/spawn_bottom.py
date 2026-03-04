# type: ignore
"""
Kitty kitten: spawn a new bottom (BTM_N) pane.
Uses only kitty Boss API (no subprocess / kitty executable).
See: https://sw.kovidgoyal.net/kitty/kittens/custom/#kitty-api-to-use-with-kittens
"""
import re

from kitty.boss import Boss
from kittens.tui.handler import result_handler


def _windows_in_active_tab(boss):
    """Yield (window_id, title) for windows in the active tab."""
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
        yield (wid, str(title))


def _next_bottom_title(boss):
    pattern = re.compile(r"^BTM_(\d+)$")
    max_idx = 0
    for _wid, title in _windows_in_active_tab(boss):
        m = pattern.match(title)
        if m:
            max_idx = max(max_idx, int(m.group(1)))
    return f"BTM_{max_idx + 1}"


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, data, target_window_id, boss: Boss):
    tab = boss.active_tab
    if tab is None:
        return

    title = _next_bottom_title(boss)
    boss.call_remote_control(
        boss.active_window,
        (
            "launch",
            "--type=window",
            "--location=hsplit",
            "--bias=25",
            "--title", title,
            "--cwd=current",
            "zsh",
        ),
    )
