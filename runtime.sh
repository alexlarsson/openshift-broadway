export BROADWAY_ROOT=$OPENSHIFT_HOMEDIR/app-root/repo/export
export LD_LIBRARY_PATH=$BROADWAY_ROOT/lib
export PATH=$BROADWAY_ROOT/bin:$PATH
export XDG_CONFIG_DIRS="$BROADWAY_ROOT/etc/xdg:/etc"
export XDG_DATA_DIRS="$BROADWAY_ROOT/share:/usr/share"
export GI_TYPELIB_PATH="$BROADWAY_ROOT/lib/girepository-1.0:/usr/lib/girepository-1.0"
export GTK_EXE_PREFIX="$BROADWAY_ROOT"
export GTK_DATA_PREFIX="$BROADWAY_ROOT"
export FONTCONFIG_PATH="$BROADWAY_ROOT/etc/fonts"
export XDG_CONFIG_HOME=$OPENSHIFT_HOMEDIR/diy-0.1/config
ln -sf $BROADWAY_ROOT /tmp/broadway
rm -f /tmp/dbus-addr
dbus-daemon --config-file=$BROADWAY_ROOT/etc/dbus-1/session.conf --print-address=6 --fork 6<>/tmp/dbus-addr
export DBUS_SESSION_BUS_ADDRESS=`cat /tmp/dbus-addr`
