{ lib
, fetchFromGitHub
, python310Packages
, hyprlandSupport ? false
}:


let
  fs = lib.fileset;
  sourceFiles =
    fs.difference
      ./.
      (fs.unions [
        (fs.maybeMissing ./result)
        (fs.fileFilter (file: file.hasExt "nix") ./.)
      ]);
in

python310Packages.buildPythonApplication rec {
  pname = "nwg-shell";
  version = "0.5.32-3";

  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };


  nativeBuildInputs = [
  ];

  buildInputs = [
  ];

  propagatedBuildInputs = [
  ] ++ lib.optionals hyprlandSupport [
  ];

  postInstall = ''
    install -Dm444 LICENSE -t $out/share/licenses/nwg-shell
    install -Dm444 README.md -t $out/share/doc/nwg-shell
    install -Dm444 nwg-readme.desktop -t $out/share/applications
  '';

  # Upstream has no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/nwg-piotr/nwg-shell";
    description = "GTK3-based shell for sway Wayland compositor";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "nwg-shell";
  };
}
