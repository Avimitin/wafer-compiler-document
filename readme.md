Documents for WaferCompiler project
===================================

Frontend Design
---------------
Frontend Design required three files:
* The drawio file for diagram display (./frontend-design.drawio)
* The drawio rendered image to embeded in document (./imgs/compiler-dispatch-diagram.png)
* The main typst file for document rendering (./frontend-design.typ)

To get a latest rendered PDF file, run the following commands:

```console
$ typst compile ./frontend-design.typ
$ ls *.pdf
frontend-design.pdf
```

> Developers might need to install Noto Fonts CJK to get a better reading experience.
