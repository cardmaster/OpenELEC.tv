#!/bin/sh

LEAFMOD_STAMP_REV=3
LEAFMOD_DIR=/storage/leafmod
LEAFMOD_STAMP_FILE=$LEAFMOD_DIR/.leafmodstamp

rutorrent_dir=$LEAFMOD_DIR/rutorrent

yesorexit(){
  echo "(yes/no):"
  read yesorno
  if [ "$yesorno" = "yes" ]; then
    echo $yesorno, "OK"
  else
    echo you said $yesorno, aborted.
    exit 1
  fi
}

unpack_rutorrent(){
  mkdir -p $rutorrent_dir/www 
  tar xjf /usr/lib/rutorrent/default.tar.bz2 -C $rutorrent_dir/www
  PHP_CGI=$(which php-cgi)
  echo "Using php-cgi" $PHP_CGI
  cat > $rutorrent_dir/php-wrap <<EOF
#!/bin/sh
$PHP_CGI -c ${rutorrent_dir} \$@
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


if [ ! -d $LEAFMOD_DIR ]; then
  mkdir -p $LEAFMOD_DIR
  mkdir -p $LEAFMOD_DIR/capath
elif [ -f $LEAFMOD_STAMP_FILE ]; then
  . $LEAFMOD_STAMP_FILE
fi

if [ "$LEAFMOD_STAMP_REV" -eq "$LEAFMOD_STAMP_REV_S" ]; then
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
PORTST=$((RANDOM % 20000 + 15000))
PORTED=$((PORTST + 20))
cat > /storage/.rtorrent.rc <<EOF

#log.open_file = "rtlog.log",(cat,/storage/media/torrent/rtorrent.log.,(system.pid))
#log.add_output = "info", "rtlog.log"

min_peers = 1
max_uploads = 5
#download_rate = 0
max_peers = 1024
#upload_rate = 900

scgi_port = 127.0.0.1:9999

directory = /storage/media/torrent/torrents
session = /storage/media/torrent/Session

schedule = watch_directory_1,10,10,"load_start=/storage/media/torrent/torrents/*.torrent"

#schedule = low_diskspace,5,60,close_low_diskspace=100M
#schedule = ratio,60,60,"stop_on_ratio=200,200M,2000" 

port_range = ${PORTST}-${PORTED}
port_random = yes 
dht = disable
dht_port = 6881   
peer_exchange = yes 

use_udp_trackers = yes
#encryption = allow_incoming,enable_retry,prefer_plaintext
#encryption = allow_incoming,try_outgoing,enable_retry
encryption = allow_incoming,enable_retry,prefer_plaintext
#throttle_up = low,10
#throttle_down = low,10
#throttle_up = med,20
#throttle_down = med,20

#send_buffer_size = 10M  
#receive_buffer_size = 20M 
encoding_list=UTF-8 

#http_capath = $LEAFMOD_DIR/capath

EOF

cp /etc/yaddns.conf.default /storage/yaddns.conf
#echo -n "Editing yaddns conf file now, ready?"
#yesorexit
#vi /storage/yaddns.conf

echo "creating autostart.sh"
AUTOSTART_MAIN=/storage/.config/autostart.sh

if [ -f $AUTOSTART_MAIN ]; then
echo "use existing"
else
cat > /storage/.config/autostart.sh <<EOF
source $LEAFMOD_DIR/autostart.sh

start_leafmod

EOF
fi

cat > $LEAFMOD_DIR/autostart.sh <<EOF
#!/bin/sh
start_rtorrent(){
	n=1
	prevpwd=\$(pwd)
	cd /storage
        sleep 5
	until pidof rtorrent > /dev/null; do
          sleep 5
  	  screen -dmS rtdmscr rtorrent 
	  sleep 5
	  n=\$((n+1))
          if [ \$n -gt 8 ]; then
              exit 0
              echo \$(date +%Y%m%d_%H%M%S) ":start rtorrent failed with \$n retires" >> /storage/rtorrent.autostart.log
          fi
	done
	cd \$prevpwd
}

start_rutorrent(){
	httpd -p 9689 -c ${rutorrent_dir}/httpd.conf
}

start_yaddns(){
	yaddns -D
}

start_leafmod() {
   start_rtorrent
   start_rutorrent
#   start_yaddns
}

EOF

chmod +x  /storage/.config/autostart.sh

