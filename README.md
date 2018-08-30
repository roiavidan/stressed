<p align="center"><img src="https://user-images.githubusercontent.com/763896/44878495-5bf66800-acea-11e8-9be5-ce17a9a623c5.png" /></p>

**Stressed!** - a simple app for stress-testing. It is based on [Mobbage](https://github.com/redfin/mobbage).

#### How it works

**Stressed!** is using a Python script called Mobbage which is similar to other free tools like [Apache Benchmark](https://httpd.apache.org/docs/2.4/programs/ab.html) and [Siege](https://www.joedog.org/siege-home/).

It performs stress testing for a Web server by executing a predefined number of concurrent HTTP calls, based on a list of Jobs. Each job is defined by a URL, method and request parameters. It then gathers and returns statistics about the executed test.

**Stressed!** takes these numbers and using [jq](https://stedolan.github.io/jq/) transforms them into metric data which is then written into *CloudWatch*.

This data can later be processed and graphed (out of scope here).

### Usage

To use **Stressed!** please follow the following steps:

- Create a *JSON* file with the list of URLs that should be stress-tested. The file's format is described in detail  [here](https://github.com/redfin/mobbage#example-file-format) and is similar to the following:
```json
[
  { "url": "http://www.foo.com", "header": ["host:www.bar.com"], "method": "GET" }
]
```
There are more examples in the `/examples` directory of this repository.

- Create the following `build_scripts/bin/stressed.sh` script in your project directory for calling **Stressed!** via your CI pipeline:
```bash
#!/bin/bash -e
docker run --rm \
    -v `pwd`/my_project_urls.json:/data/urls.json \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -e AWS_REGION=ap-southeast-2 \
    -e STRESSED_CW_METRIC_NAMESPACE=my_project \
    -e STRESSED_CONCURRENCY=10 \
    -e STRESSED_TIMES=1000 \
    stressed
```

- Add a new step to your pipeline after deployment(s) to TEST and/or PROD. For example (in Buildkite):
```yaml
  - name: ":scream_cat: Run stress tests"
    command: "build_scripts/bin/stressed.sh"
    agents:
      queue: non-prod-corp:default
```
