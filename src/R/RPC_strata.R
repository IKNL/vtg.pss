RPC_strata <- function(df, quantiles, stratum){
  
  # load dataset from previous set from the temporary volume
  vtg::log$debug("RPC_stata: Reading dataframe")
  temp_folder = Sys.getenv("TEMPORARY_FOLDER")
  temp_file = file.path(temp_folder, "filtered_df.R")
  df <- readRDS(temp_file)

  vtg::log$debug("RPC_stata: Computing groups")
  df$strata = cut(df$pr_score, breaks = quantiles, labels = 1:stratum, include.lowest = TRUE)
  
  # write new dataframe (containing the new catergory column)
  vtg::log$debug("RPC_stata: Writing to temporary directory")
  temp_file = file.path(temp_folder, "filtered_df_local.R")
  saveRDS(df, file=temp_file)
  
  # Some (specific) analysis specific for Dave's master thesis
  vtg::log$debug("RPC_stata: Specific Dave analysis")
  res <- matrix(nrow = 5, ncol = 5)
  x <- 1
  repeat{
    res[x,1] = qualityindicator(df[df$strata == x,], variable = "eus6a") #ik pak telkens van de lijst out, de aparte dataframes
    res[x,2] = qualityindicator(df[df$strata == x,], variable = "eus6b")
    res[x,3] = qualityindicator(df[df$strata == x,], variable = "eus9a")
    res[x,4] = qualityindicator(df[df$strata == x,], variable = "eus9c")
    res[x,5] = qualityindicator(df[df$strata == x,], variable = "eus10a")
    x = x + 1
    if (x > 5) break
  }
  
  vtg::log$debug("RPC_stata: Reformatting results")
  print(res)
  rows = c("eus6a", "eus6b", "eus9a", "eus9c", "eus10a")
  res <- as.data.frame(res)
  colnames(res) <- rows
  row.names(res) <- c("1", "2", "3", "4", "5")
  print(res)
  #END RESULTS |  AVERAGE TREATMENT EFFECT
  vtg::log$debug("RPC_stata: Returning results")
  print(colMeans(res))
  return(colMeans(res))
  

}

qualityindicator <- function(data, variable){
  # (Numerator / Denominator) * 100
  outcome = (sum(data[[variable]] == "Yes") / (sum(data[[variable]] == "Yes") + sum(data[[variable]] == "No"))*100)
  return(outcome)
}
