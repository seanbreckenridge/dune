Test missing entries in the .install file

  $ . ./helpers.sh

  $ make_lockdir
  $ lockfile() {
  > cat >dune.lock/test.pkg <<EOF
  > (build
  >  (system "echo 'lib: [ \"$1\" ]' > test.install"))
  > EOF
  > }

This should give us a proper error that myfile wasn't generated

  $ lockfile "myfile"
  $ build_pkg test 2>&1 | sed 's#_build.*_private#$ROOT/_private#'
  Error:
  $ROOT/_private/default/.pkg/test/source/myfile:
  No such file or directory
  -> required by $ROOT/_private/default/.pkg/test/target/cookie

This on the other hand shouldn't error because myfile is optional

  $ lockfile "?myfile"
  $ build_pkg test
