#!/bin/sh

# waiting for mixmod recipe
git clone -b v2.1.10 https://github.com/mixmod/mixmod.git --depth 1
curl -L https://github.com/mixmod/mixmod/pull/31.patch | patch -p1 -d mixmod
cmake -DCMAKE_PREFIX_PATH=${PREFIX} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_UNITY_BUILD=ON -S mixmod -B mixmod_build
make install -C mixmod_build -j${CPU_COUNT}

cmake \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DPython_FIND_STRATEGY=LOCATION \
  -DPython_ROOT_DIR=${PREFIX} \
  -DBUILD_DOC=OFF \
  .

make install -j${CPU_COUNT}
DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib ctest -R pyinstallcheck --output-on-failure -j${CPU_COUNT}

