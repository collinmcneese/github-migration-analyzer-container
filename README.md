# GitHub Migration Analyzer Container

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

- The GitHub Container Registry requires authenticated login to pull images. See [Docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry) for details
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
    collinmcneese/github-migration-analyzer
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
