#!/bin/sh

LEAFMOD_STAMP_REV=1
LEAFMOD_DIR=/storage/leafmod
LEAFMOD_STAMP_FILE=$LEAFMOD_DIR/.leafmodstamp

rutorrent_dir=$LEAFMOD_DIR/rutorrent

yesorexit(){
  echo "(yes/no):"
  read yesorno
  if [ "$yesorno" = "yes" ]; then
  else
    echo you said $yesorno, aborted.
    exit 1
  fi
}

unpack_rutorrent(){
  mkdir -p $rutorrent_dir/www 
  tar xjf /usr/lib/rutorrent/default.tar.bz2 -C $rutorrent_dir/www
  PHP_CGI=$(whcih php-cgi)
  echo "Using php-cgi" $PHP_CGI
  cat > $rutorrent_dir/php-wrap <<EOF
#!/bin/sh
$PHP_CGI -c ${rutorrent_dir} $$@
EOF
  chmod +x $rutorrent_dir/php-wrap

  cat > $rutorrent_dir/httpd.conf <<EOF
H:${rutorrent_dir}/www
A:*                          # Allow address from all ip's
E404:/usr/www/error/404.html # /path/e404.html is the 404 (not found) error page
I:index.html                 # Show index.html when a directory is requested

*.php:${rutorrent_dir}/php-wrap
EOF
}


echo "This script will setup all leaf mode configurations"
echo "Make sure you have connected/mounted all your external devices"

echo -n "Are you sure to continue? "
yesorexit

. $LEAFMOD_STAMP_FILE
if [ $LEAFMOD_STAMP_REV -eq $LEAFMOD_STAMP_REV_S ]; then
echo "already setup, skip preparing files"
else
echo "setting up files"

unpack_rutorrent

setupdate=$(date +%Y%m%d_%H%M%S)
cat > $LEAFMOD_STAMP_FILE <<EOF
LEAFMOD_STAMP_REV_S=${LEAFMOD_STAMP_REV}
LEAFMOD_STAMP_DATE_S=${setupdate}
EOF

fi

echo "creating rtorrent.rc according to rutorrent config.php"
cat > /storage/.rtorrent.rc <<EOF

scgi_port  = 127.0.0.1:9999
directory = /storage/media/torrent/torrents
session = /storage/media/torrent/Session
schedule = watch_directory_1,10,10,"load_start=/storage/media/torrent/torrents/*.torrent"

EOF


echo "creating autostart.sh"

cat > /storage/.config/autostart.sh <<EOF
#!/bin/sh
start_rtorrent(){
	n=1
	prevpwd=$$(pwd)
	cd /storage
        sleep 5
	until pidof rtorrent > /dev/null; do
          sleep 5
  	  screen -dmS rtdmscr rtorrent 
	  sleep 5
	  n=$$((n+1))
          if [ $$n -gt 8 ];
              exit 0
              echo $$(date +%Y%m%d_%H%M%S) ":start rtorrent failed with $$n retires" >> /storage/rtorrent.autostart.log
          fi
	done
	cd $$prevpwd
}

start_rutorrent(){
	httpd -p 9689 -c ${rutorrent_dir}/httpd.conf
}

start_yaddns(){
	yaddns -D
}

(
   start_rtorrent;
   start_rutorrent;
   start_yaddns
)&

EOF

