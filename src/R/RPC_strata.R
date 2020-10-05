RPC_strata <- function(df, quantiles, stratum){

  temp_folder = Sys.getenv("TEMPORARY_FOLDER")
  temp_file = file.path(temp_folder, "filtered_df.R")
  df <- readRDS(temp_file)

  print(quantiles)
  
  df$strata = cut(df$pr_score, breaks = quantiles, labels = 1:stratum, include.lowest = TRUE)
    
  temp_folder = Sys.getenv("TEMPORARY_FOLDER")
  temp_file = file.path(temp_folder, "filtered_df_local.R")
  saveRDS(df, file=temp_file)

}
