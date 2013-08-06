# RPM packaging for  VOMS Admin server 

## Usage

First clone the repo. Then run

```bash
make rpm
```

providing a checkout point for the repo. This will usually be either a tag for a release or a branch for a snapshot.

You can also provide the name of a settings file in https://github.com/italiangrid/build-settings

```bash
make tag=3.x mvn_settings=cnaf-mirros-settings.xml rpm
```

the file will be added to the sources tarball and rpm and passed to mvn at build time.
