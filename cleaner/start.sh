#!/system/bin/sh

moddir=/data/adb/modules/cache_cleaner
if [ -n "$(magisk -v | grep lite)" ]; then
  moddir=/data/adb/lite_modules/cache_cleaner
fi

scripts_dir=/data/adb/cleaner

log_file=/data/adb/cleaner/run/cleaner.log
service_log=/data/adb/cleaner/run/service.log

if [ ! -d ${moddir} ] || [ ! -d ${scripts_dir} ]; then
  echo "Error: Directories not found" >&2
  exit 1
fi

if ! type inotifyd > /dev/null; then
  echo "Error: inotifyd command not found" >&2
  exit 1
fi

start_cleaner() {
  ${scripts_dir}/cleaner.service start > ${log_file} 2> ${service_log}
}

if [ ! -f ${scripts_dir}/manual ] ; then
  echo -n "" > ${log_file}
  if [ ! -f ${moddir}/disable ] ; then
    start_cleaner
  fi
  inotifyd ${scripts_dir}/cleaner.inotify ${moddir} &>> /dev/null &
fi