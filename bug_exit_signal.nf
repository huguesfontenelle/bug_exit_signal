#!/usr/bin/env nextflow
process hello {
  publishDir "data/"
  output:
  file("out.txt")
  script:
"""
echo "Hello World" > out.txt
"""
}
