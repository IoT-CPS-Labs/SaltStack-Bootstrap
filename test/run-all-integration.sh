#!/bin/bash

cd /test/integration
for test in *; do
  bash $test
done
