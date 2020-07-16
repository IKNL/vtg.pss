pss.mock <- function(model, statum, trimming) {
  
  datasets <- list(read.csv("./src/data/data_user1.csv"), read.csv("./src/data/data_user2.csv"),read.csv("./src/data/data_user3.csv"))
  
  client <- vtg::MockClient$new(datasets, "vtg.pss")
  results <- pss(client, model, statum, trimming)
}

# pss.mock(formula = num_awards ~ prog + math,family=poisson,tol= 1e-08,maxit=25)
