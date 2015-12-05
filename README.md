For controlled execution of meta*omics aligner tools on remote cluster with limited storage space
---

_driver_ contains the main entrypoint.

To run driver and dump to stdout and driver.log, use:
```
./go
```

_unit_tests_ contains some elementary unit tests, but is not comprehensive.

_remote_dispatch_ is the workhorse for arranging execution for a sample including _upload_fastq_ and cleanup of the data and workspace directories and _rsync_remote_ to bring everything back down.
