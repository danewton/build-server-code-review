#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

rtn="0";

# if you pipe the find results into the while-loop, it will create a sub-shell, and not persist the changes to $rtn outside the loop
while read f; do
  GRP_RST=$(cat "$f" | perl -i -pe 's/\/\/.*$//g; s/^\s*$//g; s/^\s*}/}/mg; tr/\015//d; chomp; s/\s*{\s*}/{}/g; s/catch/\ncatch/g; s/}/}\n/g' | grep 'catch.*{}' | wc -l)
  if [[ "$GRP_RST" != "" && "$GRP_RST" -ge "1" ]]; then
    if [ "$rtn" -eq 0 ]; then
      echo "Some empty catch-blocks may make sense, like a NumberFormatExceptions or exceptions within utiity classes; however, empty catch-blocks within business logic are generally deemed as a bad idea, simply because when (not if) an issue arises within that flow of execution, there's little to no indication within the logs to help determine what happened.  Our recommendation is to review these findings, and if they are business logic, you are strongly encouraged to put some kind of logging statement in there - even if it's a one-liner with no stacktrace.";
      rtn="3";
    fi;
    echo "$GRP_RST empty catch blocks in $f"
  fi
done <<< "$(find src/main/java -type f -iname '*.java' -not -iwholename '*.svn*' -exec grep -l 'catch' {} \;)"

exit $rtn

