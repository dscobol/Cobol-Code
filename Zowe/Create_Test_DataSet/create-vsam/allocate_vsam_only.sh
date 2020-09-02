#!/bin/sh
################################################################
# Allocate a VSAM file.
#
# This will only submit the JCL to delete the old VSAM file and 
# create a new blank one. This version will not repro any data.
# 
# run with ./allocate_vsam_only.sh
#
################################################################

FILES_CMD="zos-files" # files
JOBS_CMD="zos-jobs" # zos-jobs


echo "Zowe, submit the JCL to create the VSAM dataset."
zowe ${JOBS_CMD} submit local-file vsam_only.jcl
