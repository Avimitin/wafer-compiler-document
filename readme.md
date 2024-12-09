# Documents for WaferCompiler projec

## Frontend Design
Frontend Design required three files:
* The drawio file for diagram display and drawing [`./assets/frontend-design.drawio`](./assets/frontend-design.drawio)
* The drawio rendered image to embeded in document [`./assets/frontend-design.png`](./assets/frontend-design.png)
* The main typst file for document rendering [`./frontend-design.typ`](./frontend-design.typ)

To get a latest rendered PDF file, run the following commands:

```console
$ # optional
$ # nix develop
$ typst compile ./frontend-design.typ ./rendered/frontend-design.pdf
$ ls ./rendered
frontend-design.pdf
```

> Developers might need to install Noto Fonts CJK to get a better reading experience.
