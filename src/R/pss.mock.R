pss.mock <- function(model, statum, trimming) {
  
  print("Hello")
  datasets <- list(read.csv("./src/data/data_user1.csv"), read.csv("./src/data/data_user2.csv"),read.csv("./src/data/data_user3.csv"))
  print("b")
  client <- vtg::MockClient$new(datasets, "v6glmr")
  results <- dglm(client, formula, family, tol)
}

# pss.mock(formula = num_awards ~ prog + math,family=poisson,tol= 1e-08,maxit=25)
