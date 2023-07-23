  $ cat > dune-project << EOF
  > (lang dune 2.4)
  > (package
  >  (name p))
  > EOF

  $ cat > dune << EOF
  > (rule (copy data.txt data2.txt))
  > 
  > (install
  >  (files data.txt data2.txt)
  >  (section share))
  > EOF

  $ echo contents > data.txt

If sendfile fails, we should fallback to the portable implementation.

  $ strace -e inject=sendfile:error=EINVAL -o /dev/null dune build @install
  Error: _build/default/data2.txt: Permission denied
  -> required by _build/default/data2.txt
  -> required by _build/install/default/share/p/data2.txt
  -> required by _build/default/p.install
  -> required by alias install
  [1]

#8210: data2.txt is copied from readonly-file data.txt (#3092), so it needs to
be adequately unlinked before starting the fallback.