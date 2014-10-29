case "$OCAML_VERSION" in
3.12) ppa=avsm/ocaml312+opam12 ;;
4.00) ppa=avsm/ocaml40+opam12  ;;
4.01) ppa=avsm/ocaml41+opam12  ;;
4.02) ppa=avsm/ocaml42+opam12  ;;
*)    ppa=avsm/ocaml42+opam12  ;;
esac

sudo add-apt-repository "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe"
sudo add-apt-repository --yes ppa:${ppa}
sudo apt-get update -qq
sudo apt-get install -y ocaml-compiler-libs ocaml-interp ocaml-base-nox ocaml-base ocaml ocaml-nox ocaml-native-compilers camlp4 camlp4-extra opam

export OPAMYES=1

pkg=my-package

opam init -a
opam pin add ${pkg} . -n

export IFS='
'
depext=`opam list --required-by ${pkg} -e ubuntu -s`
if [ "$depext" != "" ]; then
  echo Ubuntu depexts: "${depext}"
  sudo apt-get install -qq ${depext}
fi
srcext=`opam list --required-by ${pkg} -e source,linux -s`
if [ "$srcext" != "" ]; then
  echo Ubuntu srcext: "${srcext}"
  curl -sL ${srcext} | bash
fi

opam install ${pkg} --deps-only --build-test