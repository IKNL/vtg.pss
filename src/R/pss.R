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
    result <- client$call("pss", model, stratum, trimming, types)
    return(result)
  }
  

  vtg::log$debug("Master: Pred")


  #calculate propensity scores and add to the existing dataframes
  pr_scores <- client$call("pred", model=model, trimming=trimming, types=types)

  # pred1 <- predict(as.GLM(M_2), newdata=df1, type="response") #federated, done on a node
  # df1$pr_score=pred1
  # pr_df1 <- as.data.frame(pred1)
  # names(pr_df1) <- "pr_score"

  # pred2 <- predict(as.GLM(M_2), newdata=df2, type="response") #federated, done on a node
  # pr_df2 <- as.data.frame(pred2)
  # names(pr_df2) <- "pr_score
  # df2$pr_score=pred2

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
