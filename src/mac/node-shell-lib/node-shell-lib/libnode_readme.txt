When adding a new version of libnode.dylib, the install path info in the .dylib file needs to be updated.

The path SHOULD be:
  @executable_path/../Resources/libnode.dylib
(or wherever the library gets placed relative to the executable inside the .app bundle)

But, by default it will be a hardcoded path to wherever it was built.

The path can be chaned with:
  install_name_tool -id @executable_path/../Resources/libnode.dylib libnode.dylib

The path chan be checked with:
  otool -L libnode.dylib

NOTE: This only needs to be done once, so it shouldn't be a build step. It needs to happen _before_ linking.