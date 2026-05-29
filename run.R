#!/usr/bin/env Rscript

# Daily trendecon runner. Called once per country by the GitHub Actions matrix:
#
#   Rscript run.R ch   #  (or de / at)
#
# Updates every index for that country from Google Trends and writes the
# seasonally adjusted series into raw/<geo> and data/<geo>. Indices are
# processed independently (see trendecon::proc_trendecon): a failure in one
# index does not stop the others, and everything that succeeds is written to
# disk. The process exits non-zero only if *every* index for the country failed,
# so that partial results are still committed by the workflow.

args <- commandArgs(trailingOnly = TRUE)
geo <- if (length(args) >= 1L) tolower(args[[1L]]) else "ch"

# Optional one-off daily-gap backfill. Set TRENDECON_BACKFILL_FROM=YYYY-mm-dd
# (e.g. after an outage) to refill each keyword's daily series from that date
# before the regular update; leave unset for normal daily runs.
backfill_from <- Sys.getenv("TRENDECON_BACKFILL_FROM", unset = "")
backfill_from <- if (nzchar(backfill_from)) backfill_from else NULL

# raw/ and data/ live at the repository root
options(path_trendecon = ".")

# Pace queries to stay under Google's rate limiter. A backfill fires many more
# queries in a burst, so pace it more gently than a normal incremental run.
options(trendecon.query_pause = if (is.null(backfill_from)) 1 else 1.5)

suppressPackageStartupMessages({
  library(trendecon)
  library(prophet)
})

proc <- switch(
  geo,
  ch = trendecon::proc_trendecon_ch,
  de = trendecon::proc_trendecon_de,
  at = trendecon::proc_trendecon_at,
  stop("unknown geo '", geo, "', expected one of: ch, de, at")
)

message("==== trendecon daily run: ", toupper(geo), " (", Sys.time(), " UTC) ====")
if (!is.null(backfill_from)) {
  message("One-off daily backfill from ", backfill_from)
}

status <- proc(backfill_from = backfill_from)

message("\n==== summary [", toupper(geo), "] ====")
print(status)

failed <- status[!status$ok, , drop = FALSE]
if (nrow(failed) > 0L) {
  message("\n", nrow(failed), " index/indices failed:")
  for (i in seq_len(nrow(failed))) {
    message("  - ", failed$index[i], ": ", failed$error[i])
  }
}
