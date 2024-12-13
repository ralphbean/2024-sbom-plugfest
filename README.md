# cachi2 and konflux-ci 2024 SBOM harmonization plugfest submission

This is a submission of **build-time SBOMs** created by
[cachi2](https://github.com/containerbuildsystem/cachi2) (and with some ideas
borrowed from [konflux-ci](https://konflux-ci.dev)) for the [2024 SBOM
harmonization plugfest](https://resources.sei.cmu.edu/news-events/events/sbom/).

* `cachi2` is a CLI tool that pre-fetches your project's dependencies to aid in making your build process network-isolated.
* `konflux-ci` is a larger secure supply chain platform that uses cachi2 for its SBOM creation.
 
The focus is on accuracy. The builds are performed with network disabled so
that we can be sure that no components get pulled in that aren't explicitly
declared and handled by cachi2's pre-fetch.

# Output

The output is committed to the repo here, but you can also find it associated with the builds:

```
for project in httpie gin-gonic; do
    for artifact in $(oras discover --format json "quay.io/rbean/sbom/plugfest/${project}:latest" | jq -r '.manifests[].reference'); do
        oras pull "${artifact}"
        mv sbom.cyclonedx.json "sbom.${project}.cyclonedx.json"
    done
done
```
