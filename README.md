# step2stl
Example program of how to convert ISO 10303 STEP files (AP203 and AP 214) to STL using OpenCascade

## Dependencies

You need OpenCascade.

On Ubuntu you can try to install opencascade from apt-get. This might
work:

```
sudo apt-get install libopencascade-foundation-6.5.0 \
libopencascade-modeling-6.5.0 libopencascade-ocaf-6.5.0 \
libopencascade-ocaf-lite-6.5.0 libopencascade-visualization-6.5.0 \
opencascade-draw
```

But you can also compile from source:

```
git clone https://github.com/tpaviot/oce.git
cd oce
git checkout 13965711913c4590549de562e55c922fb0889d24
cd ..
mkdir oce_build
cd oce_build
cmake ../oce
sudo make install
```

Here we use a specific commit from the OpenCascade Community Edition,
but probably anyone after that would work, too (not tested).


## Compiling

You should be able to compile it on ubuntu or osx if you have
OpenCascade installed (Makefile included). The included Makefile
assumes the library paths as used by the source installation route. If
you install from apt, then you may need to remove `local/` from some
of the paths.

## Running

Once you have compiled it,
just use it as:

```
./step2stl STEPFILENAME STLFILENAME
```

