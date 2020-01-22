This folder contains GC latency data collected using the Cyclone Scheme compiler.

The following system was used to run these tests:
Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz

Data is a series of samples of:
- Total elapsed time since program start (in microseconds)
- Elapsed minor GC time (in microseconds) 

collected using the `-DCYC_HIGH_RES_TIMERS` compilation flag.
