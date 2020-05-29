# data-raw

Probably best to open up a copy to this repo. We then can set up automatization for the new repo. If everything works, we rename it to `data`. In the meantime, we manually update our current `data` repo.

### Daily data update

In this repo dir, run:

```r
library(trendecon)
proc_trendecon_ch()
```

Alternatively, this will only update one indicator, and take less time:

```r
proc_trendecon_ch()
```

`proc_trendecon_ch` does the same as deprecated `proc_all`, but is called from this repo's dir, instead of the dir above. It only operates on subdirs of this repo and does not affect other repos.
