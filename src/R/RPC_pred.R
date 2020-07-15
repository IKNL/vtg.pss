RPC_pred <- function(df, model, trimming=FALSE){

  #add pr_score
  pred <- predict(model, newdata=df, type = 'response')
  df$pr_score=pred

  #df with only pr_scores
  pr_scores <- pred
  
  trimmed <- 0
  if (trimming==TRUE){
    trimmed <- sum(pr_scores < 0.1 | pr_scores > 0.9) #summarize amount of trimmed observations
    pr_scores <- pr_scores[!(pr_scores <= 0.1 | pr_scores > 0.9)] #remove the observations
  }
  return(list(pr_scores, print(paste("Removed",trimmed,"observations"))))
}



