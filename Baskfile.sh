task_default() {
  bask_log_error 'There is no default task!'
  return 1
}

js() {
  preamble=`awk -F:// '/^node_preamble/ { print $2; }' .packages`
  [ -f "$preamble/preamble.js" ] || \
    bask_log_error 'Cannot find node_preamble preamble.js'

  if [ "$1" == "release" ]; then
    preamble_js="$preamble/preamble.min.js"
    dart2js_flags=-m
  else
    preamble_js="$preamble/preamble.js"
    dart2js_flags=
  fi

  mkdir -p package/pH/build
  bask_run dart2js --trust-type-annotations $dart2js_flags -o package/pH/build/pH.js \
            lib/src/js/entrypoint.dart
  mv package/pH/build/pH.js package/pH/build/pH.0.js
  cat \
    <(echo 'if (typeof self === "undefined") {') \
    "$preamble_js" \
    <(echo '}') \
    package/pH/build/pH.0.js > package/pH/build/pH.js
  rm package/pH/build/pH.0.js
}

task_js() {
  js
}

task_js_release() {
  js release
}
