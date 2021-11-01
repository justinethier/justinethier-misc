Lots of great information here, should build a roadmap based on this: https://yetanotherdevblog.com/lsm/

We now understand how a basic LSM tree storage engine works:

- Writes are stored in an in-memory tree (also known as a memtable). Any supporting data structures (bloom filters and sparse index) are also updated if necessary.
- When this tree becomes too large it is flushed to disk with the keys in sorted order.
- When a read comes in we check the bloom filter. If the bloom filter indicates that the value is not present then we tell the client that the key could not be found. If the bloom filter indicates that the value is present then we begin iterating over our segment files from newest to oldest.
- For each segment file, we check a sparse index and scan the offsets where we expect the key to be found until we find the key. We'll return the value as soon as we find it in a segment file.

