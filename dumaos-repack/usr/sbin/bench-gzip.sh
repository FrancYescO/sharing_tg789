#!/bin/sh
# The benchmark app only reads test details from <time>.txt.gz
# (get_file_data gunzips on read) and its own post-test gzip never runs
# here because options.save=true takes the upload_test_data branch, which
# also deletes the history files (the netduma cloud is dead on TCH).
# Compress finished test files so the history detail page keeps working.
for f in /tmp/benchmark/history/1*.txt; do
  [ -f "$f" ] || continue
  m=$(stat -c %Y "$f"); n=$(date +%s)
  [ $((n-m)) -gt 120 ] && gzip -f "$f"
done
