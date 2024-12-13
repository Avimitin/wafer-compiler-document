# Documents for WaferCompiler projec

An rendered version can be found under [`./rendered`](./rendered).

## Requirement
1. Frontend Design
  * <https://draw.io>
  * All `*.drawio` file under [`./assets`](./assets)
2. Document
  * [typst](https://typst.app/)
  * [`./frontend-design.typ`](./frontend-design.typ)

## Build instruction
If you have [nix](https://nixos.org/) installed, use the nix tools to do the job:
```bash
nix run .
```

If you don't have nix, installed typst yourself and run:
```bash
typst compile ./frontend-design.typ ./rendered/frontend-design.pdf
```

> Developers might need to install Noto Fonts CJK to get a better reading experience.
