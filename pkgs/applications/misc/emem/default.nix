{ stdenv, fetchurl, jdk }:

stdenv.mkDerivation rec {
  pname = "emem";
  version = "0.2.29";
  name = "${pname}-${version}";

  inherit jdk;

  src = fetchurl {
    url = "https://github.com/ebzzry/${pname}/releases/download/v${version}/${pname}.jar";
    sha256 = "1282m4qwdn6phg5x71l470vs1kld8lfhv5k8yvhp9i7frm29b6w7";
  };

  buildInputs = [ ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
  '';

  installPhase = ''
    cp $src $out/share/java/${pname}.jar

    cat > $out/bin/${pname} <<EOF
#! $SHELL
$jdk/bin/java -jar $out/share/java/${pname}.jar "\$@"
EOF

    chmod +x $out/bin/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ebzzry/emem;
    description = "A trivial Markdown to HTML converter";
    license = licenses.epl10;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };
}
