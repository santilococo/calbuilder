# calbuilder
GitHub action to build a package, analyze it with `namcap`, and output the package file (signed or unsigned) and its `.SRCINFO`.

This action supports PKGBUILDs that have AUR dependencies.

## Table of contents
  - [Inputs and outputs <a name="inputs-and-outputs-"></a>](#inputs-and-outputs-)
  - [Usage <a name="usage"></a>](#usage-)
  - [Contributing <a name="contributing"></a>](#contributing-)
  - [License <a name="license"></a>](#license-)

## Inputs and outputs <a name="inputs-and-outputs-"></a>
### Inputs:
* `pkgDir`: relative path to the PKGBUILD directory.
* `gpgPublicKey`: GPG public key that will be used to sign packages.
* `gpgPrivateKey`: GPG private key.
* `gpgPassphrase`: GPG passphrase of `gpgPrivateKey`.

It is recommended to store `gpgPrivateKey` and `gpgPassphrase` as secrets (see [Usage](#usage-)).

None of these inputs are required. 

### Outputs:
* `srcInfo`: Generated `.SRCINFO`.
* `pkgFile`: Built package file.

## Usage <a name="usage"></a>
```yaml
name: CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - id: calbuilder
      uses: santilococo/calbuilder@master
        pkgDir: "libxft-bgra"
        gpgPublicKey: "C03E1F00B0461E7F"
        gpgPrivateKey: "${{ secrets.GPG_PRIVATE_KEY }}"
        gpgPassphrase: "${{ secrets.GPG_PASSPHRASE }}"
    - uses: actions/upload-artifact@v2
      with:
        path: |
          ${{ steps.calbuilder.outputs.srcInfo }}
          ${{ steps.calbuilder.outputs.pkgFile }}
```

For debugging purposes, you can run it directly with docker or podman as well. For example:

```
docker run -e "INPUT_PKGDIR=libxft-bgra" -e "INPUT_GPGPUBLICKEY=C03E1F00B0461E7F" -e "INPUT_GPGPRIVATEKEY=${GPG_PRIVATE_KEY}" -e "INPUT_GPGPASSPHRASE=${GPG_PASSPHRASE}" --workdir /github/workspace -v "$HOME/calpkgs:/github/workspace" -it --entrypoint /bin/bash slococo/calbuilder
```

Make sure to include both the `--workdir` and the `/github/workspace` mount.

## Contributing <a name="contributing"></a>
PRs are welcome.

## License <a name="license"></a>
[MIT](https://raw.githubusercontent.com/santilococo/calbuilder/master/LICENSE.md)
