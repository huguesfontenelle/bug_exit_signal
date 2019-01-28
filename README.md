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

## How do I know that nextflow is waiting for a valid exit signal?

The followin file is submitted to SLURM with `sbatch`:
```
/net/p01-c2io-nfs/projects/p193/OI/bug_exit_signal/work/af/b9202390f62ea40b081213e137a7bf/.command.run
```

Here is a paste of the bottom of a similar one:
```
set +e
ctmp=$(set +u; nxf_mktemp /dev/shm 2>/dev/null || nxf_mktemp $TMPDIR)
cout=$ctmp/.command.out; mkfifo $cout
cerr=$ctmp/.command.err; mkfifo $cerr
tee .command.out < $cout &
tee1=$!
tee .command.err < $cerr >&2 &
tee2=$!
(
set +u; env - PATH="$PATH" SINGULARITYENV_TMP="$TMP" SINGULARITYENV_TMPDIR="$TMPDIR" SINGULARITYENV_NXF_DEBUG=${NXF_DEBUG:=0} singularity exec -B /ngs-pipeline -B "$PWD" /ngs-pipeline/./containers/oi-pipe-dev.simg /bin/bash -c "cd $PWD; eval $(nxf_taskenv); /bin/bash /ngs-pipeline/work/2a/cf1393be6f6a39236dc8fce85dfd2a/.command.stub"
) >$cout 2>$cerr &
pid=$!
wait $pid || ret=$?
wait $tee1 $tee2
# user `afterScript`
echo "Done"
```

`wait` waits for the return signal given by `singularity exec`.
Note: For the proper file, have a look in the folder. I don't have export rights.
