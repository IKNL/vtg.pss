RPC_pred <- function(df, model, types=NULL){

  vtg::log$debug("RPC_pred")

  if(!is.null(types)){
    df=Format_Data(df,types)
  }

  #add pr_score
  pred <- predict(model, newdata=df, type = 'response')
  df$pr_score=pred

  #df with only pr_scores
  pr_scores=pred

  temp_folder = Sys.getenv("TEMPORARY_FOLDER")
  temp_file = file.path(temp_folder, "df.R")
  vtg::log$debug(glue::glue("Writing to {temp_file}"))
  saveRDS(df, file=temp_file)

  vtg::log$debug(paste("pr_scores=", toString(pr_scores)))

  return(pr_scores)
}
