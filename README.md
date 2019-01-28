# Singularity on TSD: no exit code

When using a singularity container, SLURM does not return an exit code.
Consequently Nextflow waits forever.

## How to reproduce

* Deploy [nextflow](https://www.nextflow.io/) on TSD
* Ship the code in this repo and `run.sh` it

Note: adapt the path in the `singularity.config` and `run.sh` to the actual location.

## Behaviour

The pipeline runs twice.
The first time without Singularity, successfully
```
/cluster/projects/p193/OI/bug_exit_signal/work/e4/
```

The second time, with Singularity:
```
/cluster/projects/p193/OI/bug_exit_signal/work/af/
```
Here the out.txt is properly created from the singularity image, and written on the file system. However, SLURM does not return any exit code, and nextflow hangs for some mimutes, until it is killed.

## Error message

```
Caused by:
Process 'hello' terminated for an unknown reason -- Likely it has been terminated by the external system

Command executed:
echo "Hello world"  > out. txt

Command exit status:
-

Command output:
(empty)

Command error:
WARNING: Not mounting requested bind point (already mounted in container): /tsd

Work dir:
/net/p01-c2io-nfs/projects/p193/OI/bug_exit_signal/work/af/b9202390f62ea40b081213e137a7bf

Tip: when you have fixed the problem you can continue the execution appending to the nextflow command line the option - resume

- Check '.nextflow. log' file for details
```
