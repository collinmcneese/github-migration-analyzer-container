#!/bin/bash

function log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $1"
}

log "Starting GitHub Migration Analyzer"

cd /log || (log "Could not cd to /log" && exit 1)

export NODE_PATH=/app/gh-migration-analyzer/node_modules

if [[ ${GHMA_SOURCETYPE^^} == 'GITHUB' ]] ;
then
  log "GHMA_SOURCETYPE is set to GITHUB"

  if [[ -n ${GHMA_ORGANIZATION} && -n ${GHMA_TOKEN} ]] ;
    then
      for org in ${GHMA_ORGANIZATION//\n/} ;
      do
        log "Scanning org ${org}"

        script_with_args="npx node /app/gh-migration-analyzer/src/index.js GH-org \
        -o '${org}' -t '${GHMA_TOKEN}'"
        if [[ -n ${GHMA_SERVER} ]] ;
        then
          log "Using custom GitHub Enterprise server ${GHMA_SERVER}"

          script_with_args+=" -s ${GHMA_SERVER}"
        fi
        eval "${script_with_args}"
      done
  else
    log "GHMA_ORGANIZATION and GHMA_TOKEN are not set"

    log "Exiting"

    exit 1
  fi
elif [[ ${GHMA_SOURCETYPE^^} == 'ADO' ]] ;
then
  log "GHMA_SOURCETYPE is set to ADO"

  # GHMA_TOKEN is required, GHMA_ORGANIZATION and GHMA_PROJECT are optional
  if [[ -n ${GHMA_TOKEN} ]] ;
  then
    script_with_args="npx node /app/gh-migration-analyzer/src/index.js ADO-org \
      -t ${GHMA_TOKEN}"

    if [[ -n ${GHMA_ORGANIZATION} ]] ;
    then
      for org in ${GHMA_ORGANIZATION//\n/} ;
      do
        log "Scanning org ${org}"
        script_with_args+=" -o ${org}"

        eval "${script_with_args}"
      done
    fi

    if [[ -n ${GHMA_PROJECT} ]] ;
    then
      for project in ${GHMA_PROJECT//\n/} ;
      do
        log "Scanning project ${project}"
        script_with_args+=" -p ${project}"

        eval "${script_with_args}"
      done
    fi
  else
    log "GHMA_TOKEN is not set"

    log "Exiting"

    exit 1
  fi
else
  log "${GHMA_SOURCETYPE} is not a valid source type. Please use 'GITHUB' or 'ADO'"

  exit 1
fi
