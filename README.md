xyzzy 標準の関数とかへの修正詰め合わせ

こんなものを作ってる理由
========================
標準の関数に対する修正は http://xyzzy.s53.xrea.com/wiki/index.php?patch とかにあるんだけど、公開する拡張でそれらの修正が必要な時にエンドユーザに「patch 当てといてください」ってのもどーかなぁと思うので、まとめて netinstaller 経由で修正できるようにしたい。


含まれてる修正
==============
- (setf (symbol-function SYMBOL) FUNCTION) が SYMBOL を返す。 =>  FUNCTION を返すように。
- defstruct の :print-function に未定義な関数名（symbol）を指定するとエラー。 => 受け付けるように。
- typespec の (cons CAR-TYPE CDR-TYPE) が使えない。 => 使えるように。
- typespec の (eql X) を si:canonicalize-type すると (member (X)) という壊れた typespec になる。 => 削除。
- (type-of #<structure のインスタンス>) が、structure name のシンボルではなく lisp:structure を返す。 => structure name を返すように。
