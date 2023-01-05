# GitHub Migration Analyzer Container

[![CI](https://github.com/collinmcneese/github-migration-analyzer-container/actions/workflows/ci.yml/badge.svg)](https://github.com/collinmcneese/github-migration-analyzer-container/actions/workflows/ci.yml)
[![Create and publish a Docker image](https://github.com/collinmcneese/github-migration-analyzer-container/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/collinmcneese/github-migration-analyzer-container/actions/workflows/docker-publish.yml)

Example repository for building a container image to run [GitHub Migration Analyzer](https://github.com/github/gh-migration-analyzer)

The contents of this are meant as reference example and should be tested before running in a real environment.

- [GitHub Migration Analyzer Container](#github-migration-analyzer-container)
  - [References](#references)
  - [Container Image](#container-image)
    - [Using the Published Container Image](#using-the-published-container-image)
    - [Building & Using the Container Image Locally with Docker Compose](#building--using-the-container-image-locally-with-docker-compose)
  - [Examples](#examples)
    - [Analyzing Multiple GitHub Organizations](#analyzing-multiple-github-organizations)

## References

- [GitHub Migration Analyzer](https://github.com/github/gh-migration-analyzer)
- [Working with the GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## Container Image

Builds a [GitHub Migration Analyzer](https://github.com/github/gh-migration-analyzer) container :ship:.

This repository has a reference [docker](./docker) example which contains a `Dockerfile` for building an image along with a `docker-compose` configuration for local testing.

### Using the Published Container Image

The image configuration built from this example is published to [GitHub Packages](https://github.com/collinmcneese/github-migration-analyzer-container/pkgs/container/github-migration-analyzer) and can be pulled rather than performing a local build for quick testing.

- The [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/) is used in this example as the container registry source.
- Pull the image locally for usage:

  ```shell
  docker pull ghcr.io/collinmcneese/github-migration-analyzer
  ```

- Run the image with environment variables passed:

  ```shell
  docker run \
    -e GHMA_SOURCETYPE=GITHUB \
    -e GHMA_ORGANIZATION=my-orgname \
    -e GHMA_TOKEN='ghp_12345' \
    -e GHMA_SERVER='https://myGitHub-Enterprise-Server/api/graphql' \
    -v $(pwd):/log \
    ghcr.io/collinmcneese/github-migration-analyzer
  ```

### Building & Using the Container Image Locally with Docker Compose

- Create `docker/.env` file using the reference [docker/.env.example](docker/.env.example)

  ```shell
  # SOURCETYPE should be GITHUB or ADO
  GHMA_SOURCETYPE=
  # When using GITHUB, ORGANIZATION should be set
  #  When using ADO, either ORGANIZATION or PROJECT should be set
  GHMA_ORGANIZATION=
  GHMA_PROJECT=
  # Authentication token to use
  GHMA_TOKEN=
  GHMA_SERVER=https://GHES-FQDN/api/graphql
  ```

- Build the container image with Docker Compose

  ```shell
  docker-compose build
  ```

- Run the container image with Docker Compose

  ```shell
  docker-compose up
  ```

## Examples

### Analyzing Multiple GitHub Organizations

The `GHMA_ORGANIZATION` environment variable is able to accept a new-line-seperated list of names to scan multiple organizations at once.  This example using the [GitHub CLI](https://cli.github.com/) to fetch a listing of all available organizations from a GitHub Enterprise Server and then uses that output to run the container image:

```shell
orglist=$(GH_ENTERPRISE_TOKEN=ghp_mytoken123 GH_HOST=my-ghes-fqdn.domain gh api /organizations --paginate -q '.[].login')

docker run \
  -e GHMA_SOURCETYPE=GITHUB \
  -e GHMA_ORGANIZATION=${orglist} \
  -e GHMA_TOKEN='ghp_12345' \
  -e GHMA_SERVER='https://myGitHub-Enterprise-Server/api/graphql' \
  -v $(pwd):/log \
  collinmcneese/github-migration-analyzer
```

Example Output:

```plain
❯ docker run \
    -e GHMA_SOURCETYPE=GITHUB \
    -e GHMA_ORGANIZATION=my-org \
    -e GHMA_TOKEN='ghp_12345' \
    -e GHMA_SERVER='https://myGitHub-Enterprise-Server/api/graphql' \
    -v $(pwd):/log \
    github-migration-analyzer-container-ghma

[2022-10-11T15:59:31Z] Starting GitHub Migration Analyzer
[2022-10-11T15:59:31Z] GHMA_SOURCETYPE is set to GITHUB
[2022-10-11T15:59:31Z] Scanning org my-org
[2022-10-11T15:59:31Z] Using custom GitHub Enterprise server https://myGitHub-Enterprise-Server/api/graphql
- Authorizing with GitHub
✔ Authorized with GitHub

- (0/102) Fetching metrics for repo cataclysmic-psychotherapy
✔ (1/102) Fetching metrics for repo cataclysmic-psychotherapy
- (1/102) Fetching metrics for repo accomplished-cameo
✔ (2/102) Fetching metrics for repo accomplished-cameo
- (2/102) Fetching metrics for repo crystalline-mumble
... truncated ...
- (97/102) Fetching metrics for repo repo830.11834688148397421
✔ (98/102) Fetching metrics for repo repo830.11834688148397421
- (98/102) Fetching metrics for repo repo840.8609665216775823
✔ (99/102) Fetching metrics for repo repo840.8609665216775823
- (99/102) Fetching metrics for repo repo860.22865287616391772
✔ (100/102) Fetching metrics for repo repo860.22865287616391772
- (100/102) Fetching next 50 repos
✔ (100/102) Fetched next 100 repos
- (100/102) Fetching metrics for repo repo1
✔ (101/102) Fetching metrics for repo repo1
- (101/102) Fetching metrics for repo my-repo
✔ (102/102) Fetching metrics for repo my-repo

- Exporting...
✔ Exporting Completed: ./my-org-metrics/repo-metrics.csv
- Exporting...
✔ Exporting Completed: ./my-org-metrics/org-metrics.csv


❯ tree my-org-metrics
my-org-metrics
├── org-metrics.csv
└── repo-metrics.csv

0 directories, 2 files
```
