Dune should gracefully error when packages introduce circular dependenices

  $ . ./helpers.sh

  $ cat >dune-project <<EOF
  > (lang dune 3.11)
  > EOF

  $ make_lockdir
  $ cat >dune.lock/a.pkg <<EOF
  > (deps c)
  > EOF
  $ cat >dune.lock/b.pkg <<EOF
  > (deps a)
  > EOF
  $ cat >dune.lock/c.pkg <<EOF
  > (deps a)
  > EOF

  $ build_pkg c
  Error: Dependency cycle between:
     - package a
  -> - package c
  -> - package a
  [1]
