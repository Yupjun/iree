# IREE Benchmark Suites Tool

This directory contains the tools to run IREE benchmark suites and generate
reports. More information about benchmark suites can be found [here](/benchmarks/README.md).

## Benchmark Tools

Currently we have `run_benchmarks_on_android.py` and
`run_benchmarks_on_linux.py` scripts to run benchmark suites on Android devices
(with `adb`) and Linux machines.

The available arguments can be shown with `--help`. Some common usages are
listed below. Here we assume:

```sh
IREE_BUILD_DIR="/path/to/IREE build root dir". It should contain the "benchmark_suites" directory built with the target "iree-benchmark-suites".

IREE_NORMAL_TOOL_DIR="/path/to/IREE tool dir". It is usually "$IREE_BUILD_DIR/tools".

IREE_TRACED_TOOL_DIR="/path/to/IREE tool dir built with IREE_ENABLE_RUNTIME_TRACING=ON".
```

See details about `IREE_ENABLE_RUNTIME_TRACING` [here](/docs/developers/developing_iree/profiling_with_tracy.md).

**Run all benchmarks**
```sh
./run_benchmarks_on_linux.py \
  --normal_benchmark_tool_dir=$IREE_NORMAL_TOOL_DIR \
  --output=results.json $IREE_BUILD_DIR
```

**Run all benchmarks and perform the Tracy captures**
```sh
./run_benchmarks_on_linux.py \
  --normal_benchmark_tool_dir=$IREE_NORMAL_TOOL_DIR \
  --traced_benchmark_tool_dir=$IREE_TRACED_TOOL_DIR \
  --trace_capture_tool=/path/to/iree-tracy-capture \
  --capture_tarball=captured_tracy_files.tar.gz
  --output=results.json $IREE_BUILD_DIR
```

**Run selected benchmarks with the filters**
```sh
./run_benchmarks_on_linux.py \
  --normal_benchmark_tool_dir=$IREE_NORMAL_TOOL_DIR \
  --model_name_regex="MobileBertSquad" \
  --driver_filter_regex="local-task" \
  --mode_regex="4-threads" \
  --output=results.json $IREE_BUILD_DIR
```

## Generating Benchmark Report

The tools here are mainly designed for benchmark automation pipelines.
The `post_benchmarks_as_pr_comment.py` and `upload_benchmarks_to_dashboard.py`
scripts are used to upload and post reports to pull requests or the
[dashboard](https://perf.iree.dev/).

If you want to generate a comparison report locally, you can use
`diff_local_benchmarks.py` script to compare two result json files and generate
the report. For example:

```sh
./diff_local_benchmarks.py --base before.json --target after.json > report.md
```
