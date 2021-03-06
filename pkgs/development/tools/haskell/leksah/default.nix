{ stdenv, ghcWithPackages, gtk3, makeWrapper }:

let
leksahEnv = ghcWithPackages (self: [ self.leksah-server self.leksah self.cabal-install ]);
in stdenv.mkDerivation {
  name = "leksah";

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${leksahEnv}/bin/leksah $out/bin/leksah \
      --prefix PATH : "${leksahEnv}/bin" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta.broken = true; # depends on broken leksah-server-0.15.2.0
}
