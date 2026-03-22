#!/usr/bin/env zsh

if pgrep -f supervisord > /dev/null; then
  echo "GUI already running"
  return 0
fi

echo "Starting GUI services..."

export DISPLAY=:99
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &

echo "GUI started"
