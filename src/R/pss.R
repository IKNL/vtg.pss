pss <- function(client, model, stratum, trimming, types){



  USE_VERBOSE_OUTPUT <- getOption('vtg.verbose_output', T)
  lgr::threshold("debug")

  image.name <- "harbor.vantage6.ai/vantage/vtg.pss"

  client$set.task.image(
    image.name,
    task.name <- "PSS"
  )

  # Run in a MASTER container
  if (client$use.master.container) {
    vtg::log$debug(glue::glue("Running `pss` in master container using image '{image.name}'"))
    # client$use.master.container = F
    # result <- vtg.pss::pss(client, model, stratum, trimming, types)
    result <- client$call("pss", model, stratum, trimming, types)
    return(result)
  }


  vtg::log$debug("Master: Pred")


  #calculate propensity scores and add to the existing dataframes
  pr_scores <- client$call("pred", model=model, types=types)

  # Apply trimming
  if (trimming ==  'nonoverlap') {

    mins = c()
    maxs = c()
    for (elem in pr_scores) {
      mins = c(mins, min(elem))
      maxs <- c(maxs, max(elem))
    }
    trimming <- c(max(mins), min(maxs))

  }
  pr_scores <- client$call("trimming", trimming)

  #calculate combined quantile values
  #done in a master container ~ so this would have to be master_q and would go on a file alone
  vtg::log$debug("Master: Computing quantiles...")
  # vtg::log$debug(typeof(pr_scores))

  prs = c()
  for (elem in pr_scores) {
    prs <- c(prs, elem)
  }
  q=quantile(prs, seq(0,1,by=1/stratum))
  print(q)
  vtg::log$debug("Master: Strata")
  out <- client$call("strata", quantiles=q, stratum=stratum, types=types)
  return(out)
}
