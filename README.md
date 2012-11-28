# RPM packaging for VOMS command-line clients

Spec file and rpmbuild preparation and calls for building rpms out of the VOMS commmand-line clients code.

## Usage

First clone the repo. Then run

```bash
make checkout=master rpm
```

providing a checkout point for the repo. This will usually be either a tag for a release or a branch for a snapshot.

You can also provide the name of a settings file in https://github.com/italiangrid/build-settings

```bash
make checkout=master mvn_settings=cnaf-mirros-settings.xml rpm
```

the file will be added to the sources tarball and rpm and passed to mvn at build time.
