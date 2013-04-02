export BROADWAY_ROOT=$(pwd)/export
export LD_LIBRARY_PATH=$BROADWAY_ROOT/lib
export PATH=$BROADWAY_ROOT/bin:$PATH
export XDG_CONFIG_DIRS="$BROADWAY_ROOT/etc/xdg:/etc"
export XDG_DATA_DIRS="$BROADWAY_ROOT/share:/usr/share"
export GI_TYPELIB_PATH="$BROADWAY_ROOT/lib/girepository-1.0:/usr/lib/girepository-1.0"
export GTK_EXE_PREFIX="$BROADWAY_ROOT"
export GTK_DATA_PREFIX="$BROADWAY_ROOT"
export FONTCONFIG_PATH="$BROADWAY_ROOT/etc/fonts"
ln -sf $BROADWAY_ROOT /tmp/broadway
eval `dbus-launch`
