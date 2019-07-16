# DTW.jl
A naive implementation of Dynamic Time Warping in Julia

After some decent time searching, I was unable to find a Dynamic Time Warping
implementation in Julia that was either actively maintained or functional. As
a result, I decided to write my own.

Currently this is a naive implementation of DTW --- so it has the pesky O(n^2)
complexity. I plan on implementating FastDTW at some point, but I'm new to
re-implementing things from academic papers.

## Side notes
Please note that I am a beginner to Julia, so if I've missed any common paradigms
or patterns please let me know by either raising an issue or
sending an email :).

# TODO
- FastDTW implementation
- Documentation
- Place in module
