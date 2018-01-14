#!/bin/bash

cd /test/unit
for test in *; do
  bash $test
done
