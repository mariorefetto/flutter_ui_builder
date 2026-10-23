Contributing
============

The project follows gitflow. Bug reports and ideas are welcome in the
[issues](https://github.com/mariorefetto/flutter_ui_builder/issues).

Branches
--------

| Branch       | Purpose                                        | Starts from | Merges into        |
| ------------ | ---------------------------------------------- | ----------- | ------------------ |
| `main`       | Released versions only; every release is a tag | -           | -                  |
| `develop`    | The next release, where work comes together    | `main`      | -                  |
| `feature/*`  | One change                                     | `develop`   | `develop`          |
| `release/*`  | Getting a version ready: version number, notes | `develop`   | `main` and `develop` |
| `hotfix/*`   | A fix to a released version                    | `main`      | `main` and `develop` |

Open pull requests against `develop`. Before opening one, run:

```
dart format .
flutter analyze
flutter test
```

Releasing
---------

1. Branch `release/0.1.0` from `develop`. Set the version in `pubspec.yaml` and
   in `lib/core/app_info.dart` (a test checks that they match).
2. Merge it into `main` with a merge commit, and into `develop`.
3. Tag the commit on `main`: `git tag -a v0.1.0 -m "Flutter UI Builder 0.1.0"`
   and push the tag.

The release workflow checks that the tag is on `main` and matches
`pubspec.yaml`, builds the macOS, Windows and Linux versions, and publishes
them. A tag with a suffix, such as `v0.1.0-beta.1`, is published as a
pre-release.

License
-------

By contributing you agree that your contribution is under the
[PolyForm Noncommercial License 1.0.0](LICENSE), and that the author may also
license the project, with your contribution, in other ways, including for
commercial use.
