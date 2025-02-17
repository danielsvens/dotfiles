import subprocess
from pathlib import Path


EXCLUDED = [".git", "scripts"]
DIRS = [p.name for p in Path().iterdir() if p.is_dir()
        and p.name not in EXCLUDED]
COMMAND = "stow -v -R -t /home/daniel/.config/hypr hypr"


def stow():
    for dir in DIRS:
        print(f"Stowing app: {dir}")
        subprocess.run(
            build_command(dir),
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )


def build_command(arg) -> list:
    return f"stow -v -R -t /home/daniel/.config/{arg} {arg}".split(" ")


if __name__ == "__main__":
    print("Stowing apps..")
    stow()
