pss <- function(client, model, stratum, trimming){

  USE_VERBOSE_OUTPUT <- getOption('vtg.verbose_output', T)
  lgr::threshold("debug")
  
  image.name <- "harbor.vantage6.ai/vantage/vtg.pss"

  client$set.task.image(
    image.name,
    task.name <- "PSS"
  )

  vtg::log$debug("Pred")


  #calculate propensity scores and add to the existing dataframes
  pr_scores <- client$call("pred", model=model)

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
  vtg::log$debug("Computing quantiles")
  # vtg::log$debug(typeof(pr_scores))
  
  prs = c()
  for (elem in pr_scores) {
    prs <- c(prs, elem[[1]])
  }
  
  q=quantile(rbind(prs), seq(0,1,by=1/stratum))
  vtg::log$debug(q)
  vtg::log$debug("Strata")
  client$call("strata", quantiles=q, stratum=stratum)
}
