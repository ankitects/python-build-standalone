# Pre-made builds for Anki

To build, run:

```
./build-linux.py --optimizations pgo --python cpython-3.9
./build-linux.py --python cpython-3.9 --target aarch64-unknown-linux-gnu
./prune-distribution.py dist/*.zst
```

The release files will be in dist/ - .zst for PyOxidizer, and
.tar.gz for Bazel.
