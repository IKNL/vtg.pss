RPC_strata <- function(df, quantiles, stratum){

  x <- 1
  repeat {
    df$strata[df$pr_score >= quantiles[x] & df$pr_score < quantiles[x+1]] <- x
    x <- x+1
    if(x > stratum){
      break
    }
  }
  temp_folder = Sys.getenv("TEMPORARY_FOLDER")
  temp_file = file.path(temp_folder, "filtered_df.R")
  save(df, temp_file)

}


#create k strata
#done on a node
