from __future__ import annotations

import os
import subprocess
from typing import Iterable

from kitty.boss import get_boss


def _build_lines() -> list[str]:
    opts = get_boss().options
    lines: list[str] = []
    for key in sorted(opts.keymap):
        for definition in opts.keymap[key]:
            action = str(getattr(definition, "action", ""))
            lines.append(f"{key}\t{action}")
    return lines


def _run_choose(lines: Iterable[str]) -> str | None:
    text = "\n".join(lines)
    if not text:
        return "No keybindings found."
    exe = os.environ.get("KITTY_EXE", "kitty")
    result = subprocess.run(
        [exe, "+kitten", "choose", "--prompt", "Keybinding> "],
        input=text,
        text=True,
        capture_output=True,
    )
    selection = result.stdout.strip()
    return selection or None


def main(args: list[str]) -> str | None:
    lines = _build_lines()
    if "--plain" in args:
        return "\n".join(lines) if lines else "No keybindings found."
    return _run_choose(lines)
