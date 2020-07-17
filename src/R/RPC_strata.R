RPC_strata <- function(df, quantiles, stratum){

  temp_folder = Sys.getenv("TEMPORARY_FOLDER")
  temp_file = file.path(temp_folder, "filtered_df.R")
  df <- readRDS(temp_file)

  print(quantiles)
  
  x <- 1
  repeat {
    df$strata[df$pr_score >= quantiles[x] & df$pr_score <= quantiles[x+1]] <- x
    x <- x+1
    if(x > stratum){
      break
    }
  }
  
  temp_folder = Sys.getenv("TEMPORARY_FOLDER")
  temp_file = file.path(temp_folder, "filtered_df_local.R")
  saveRDS(df, file=temp_file)

}
