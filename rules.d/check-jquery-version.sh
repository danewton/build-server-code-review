#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" != "war" ]; then
 exit 0
fi

ERR_RSLT=$EXIT_ERROR

FAIL_DATE="20140611"
RULE_MSG="[This rule will go from a WARNING to a FAILED for builds on (and after) $FAIL_DATE.]"

isAfter $FAIL_DATE
if [ $? -eq 0 ]; then
  ERR_RSLT=$EXIT_WARN
fi
  
if [ $(grep -R 'jquery' $WEBDIR | grep -E '(script|link|href)' | grep -E '(.*[0-9]\.[0-9]\.[0-9].*)' | perl -i -pe 's/(.*?(\d\.\d\.\d).*)/\2:\1/g' | cut -d: -f1,2 | sort -u | grep -Ev '^(1\.7|1\.8|1\.9|2\.4)' | grep -Ev '^1\.6\.[3-9]' | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please upgrade your version of jquery.  JQuery versions 1.6.2 and older have been identified as having PCI vulnerabilities (see http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2011-4969). $RULE_MSG"
  grep -nR 'jquery' $WEBDIR | grep -E '(script|link|href)' | grep -E '(.*[0-9]\.[0-9]\.[0-9].*)' | perl -i -pe 's/(.*?(\d\.\d\.\d).*)/\2:\1/g' | cut -d: -f1,2 | sort -u | grep -Ev '^(1\.7|1\.8|1\.9|2\.4)' | grep -Ev '^1\.6\.[3-9]' | grep -v '.svn'
  exit $ERR_RSLT
fi  
    



