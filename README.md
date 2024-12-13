# cachi2 and konflux-ci plugfest sboms

This is a submission of **build-time SBOMs** created by
[cachi2](https://github.com/containerbuildsystem/cachi2) (and with some ideas
borrowed from [konflux-ci](https://konflux-ci.dev)) for the [2024 SBOM
harmonization plugfest](https://resources.sei.cmu.edu/news-events/events/sbom/)
using [these scripts](https://github.com/ralphbean/2024-sbom-plugfest).

* `cachi2` is an open-source CLI tool that pre-fetches your project's dependencies to enable network-isolated builds.
* `konflux-ci` is an open-source, cloud-native software factory focused on supply chain security. It uses cachi2 for its SBOM creation.

From the [plugfest participation page](https://resources.sei.cmu.edu/news-events/events/sbom/participate.cfm), the selected repos were:

* https://github.com/httpie/cli/commit/f4cf43ecdd6c5c52b5c4ba91086d5c6ccfebcd6d
* https://github.com/gin-gonic/gin/commit/f05f966a0824b1d302ee556183e2579c91954266

# Methodology
 
The builds are performed with network disabled so that we can be sure that no
components can be pulled in that aren't explicitly declared and handled by
cachi2's pre-fetch.

The sboms were created by running the [demo-httpie.sh](https://github.com/ralphbean/2024-sbom-plugfest/blob/main/demo-httpie.sh) and [demo-gin.sh](https://github.com/ralphbean/2024-sbom-plugfest/blob/main/demo-gin.sh) scripts.

Pre-requisites are `bash`, `git`, `buildah`, `podman`, `cachi2`, `pip-compile`, and optionally `oras`.

Note, in the case of `gin-gonic`, the idea of an independent build doesn't make much sense. As a web framework, you would only ever find gin-gonic as a dependency in a different build. Here, the container build step only serves to prove that the dependencies were correctly captured. The same method would apply more sensibly to the build of an end binary (say, a web application that uses gin-gonic).

# Output

The output is committed to the repo here, but you can also find it associated with the builds with the [oras](https://oras.land/) CLI tool:

```
for project in httpie gin-gonic; do
    for artifact in $(oras discover --format json "quay.io/rbean/sbom/plugfest/${project}:latest" | jq -r '.manifests[].reference'); do
        oras pull "${artifact}"
        mv sbom.cyclonedx.json "sbom.${project}.cyclonedx.json"
    done
done
```

# Future direction

Some notes about changes we intend to make soon:

* We currently export in the cyclonedx format but intend to change over to SPDX exclusively in future iterations of these tools.
* We currently only refer to the parent/builder images by reference, but we intend to embed the parent's SBOM in the output image's SBOM in future iterations of these tools.
