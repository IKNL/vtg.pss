RPC_trimming <- function(df, trimming=FALSE) {

    # load dataset from previous set from the temporary volume
    vtg::log$debug("RPC_stata: Reading dataframe")
    temp_folder = Sys.getenv("TEMPORARY_FOLDER")
    temp_file = file.path(temp_folder, "df.R")
    df <- readRDS(temp_file)

    vtg::log$debug(glue::glue("trimming = {trimming}"))

    trimmed <- 0
    # legacy trimming
    if (trimming==TRUE){
        vtg::log$debug("BOOL")
        mask <- df$pr_score <= 0.1 | df$pr_score > 0.9
        trimmed <- sum(mask) #summarize amount of trimmed observations
        df = df[!(mask),]
    }

    # trimming of nonoverlap
    if ( is.numeric(trimming) == T && length(trimming) == 2 ) {
        vtg::log$debug("LIST")
        mask <- df$pr_score <= trimming[1] | df$pr_score > trimming[2]
        trimmed <- sum(mask )
        df = df[!(mask),]
    }

    # trimming of percentiles
    if ( is.numeric(trimming) == T && length(trimming) == 1 ){
        vtg::log$debug("VALUE")
        vtg::log$debug(glue::glue("percentile={trimming/100}"))
        mask <- df$pr_score <= (trimming/100) | df$pr_score > (1-trimming/100)
        trimmed <- sum(mask)
        df = df[!(mask),]
    }

    vtg::log$debug(glue::glue("Removed {trimmed} observations"))

    # write to temporary dataframe
    temp_folder = Sys.getenv("TEMPORARY_FOLDER")
    temp_file = file.path(temp_folder, "filtered_df.R")
    vtg::log$debug(glue::glue("Writing to {temp_file}"))
    saveRDS(df, file=temp_file)

    return(df$pr_score)

}