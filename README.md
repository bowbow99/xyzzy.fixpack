xyzzy 標準の関数とかへの修正詰め合わせ

こんなものを作ってる理由
========================
標準の関数に対する修正は http://xyzzy.s53.xrea.com/wiki/index.php?patch とかにあるんだけど、公開する拡張でそれらの修正が必要な時にエンドユーザに「patch 当てといてください」ってのもどーかなぁと思うので、まとめて netinstaller 経由で修正できるようにしたい。


fixpack で修正済みの bug
========================
- (setf (symbol-function SYMBOL) FUNCTION) が FUNCTION ではなく SYMBOL を返す。
- defstruct の :print-function に未定義の関数シンボルを指定できない
- (cons CAR-TYPE CDR-TYPE) という複合型が使えない
- (eql X) を si:canonicalize-type すると (member (X)) という壊れた typespec になる

