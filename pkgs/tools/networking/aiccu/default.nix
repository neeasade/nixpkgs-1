{ stdenv, fetchurl, gnutls, iproute, makeWrapper }:

stdenv.mkDerivation rec {

  name = "aiccu-${version}";
  version = "20070115";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/a/aiccu/aiccu_20070115.orig.tar.gz";
    sha256 = "1k73vw7i25qzmnbvmsp3ci4pm6h8q70w70vnr512517s2q5gag6j";
  };

  buildInputs = [ gnutls iproute makeWrapper ];

  patches = [
    (fetchurl {
      url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk/gnutls-3.4.0.patch?h=packages/aiccu&id=cc6decc4e734420e4c5d0cd28652077f6bd88d84";
      sha256 = "1ni3lhwy3r54js124p7fhm1my82a703chvh07vrhslb4v4b71g5s";
      name = "gnutls-3.4.0.patch";
    })
  ];

  configureFlags = "--prefix=$out";
  installPhase = ''
    install -D -m 755 unix-console/aiccu $out/bin/aiccu
    install -D -m 644 doc/aiccu.sgml $out/doc/aiccu.sgml
    install -D -m 644 doc/aiccu.1 $out/share/man/man1/aiccu.1
    wrapProgram "$out/bin/aiccu" \
      --prefix PATH : "${iproute}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Automatic IPv6 Connectivity Configuration Utility";
    homepage = "https://www.sixxs.net/tools/aiccu/";
    longDescription = ''
      A TIC+ heartbeart client for the public dynamic-IPv4 IPv6 tunnel beta test from the SixXS tunnel service provider.
    '';
    maintainers = with maintainers; [ edwtjo ];
    license = "SixXS";
    platforms = with platforms; linux;
  };

}
