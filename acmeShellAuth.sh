#!/bin/bash
### VARIABLES
# Logfile
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null  && pwd )
LOGFILE="${SCRIPT_DIR}/acmeShellAuth.log"
# Source acmesh scripts
# --此处需要按你的实际目录修改
export ACME_FOLDER="/mnt/DATA/acmeScript/acme.sh"
export ACME_DNSAPI="${ACME_FOLDER}/dnsapi"
# --此处需要修改为域名服务商对应的名称，这里默认为阿里云
export PROVIDER="dns_ali"
source "${ACME_FOLDER}/acme.sh" > /dev/null 2>&1
source "${ACME_DNSAPI}/${PROVIDER}.sh" > /dev/null 2>&1
# Dns API authentication. See details for your provider  https://github.com/acmesh-official/acme.sh/wiki/dnsapi
# --下面两个地方需要修改
export Ali_Key="***********"
export Ali_Secret="************"
### FUNCTIONS
_log_output() {
        echo `date "+[%a %b %d %H:%M:%S %Z %Y]"`" $1" >> ${LOGFILE}
}
### MAIN
_log_output "INFO Script started."
# File/folder validation
if [ ! -d "${ACME_FOLDER}" ]; then
        _log_output "ERROR Invalid acme folder: ${ACME_FOLDER}"
        return 1
fi
if [ ! -f "${LOGFILE}" ]; then
        touch "${LOGFILE}"
        chmod 500 "${LOGFILE}"
fi
# Main
if [ "${1}" == "set" ]; then
        ${PROVIDER}_add "${3}" "${4}" >> ${LOGFILE} 2>/dev/null
elif [ "${1}" == "unset" ]; then
        ${PROVIDER}_rm "${3}" "${4}" >> ${LOGFILE} 2>/dev/null
fi
_log_output "INFO Script finished."
