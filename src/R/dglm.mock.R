dglm.mock <- function(formula = num_awards ~ prog + math,family="poisson",tol= 1e-08,maxit=25, types=NULL) {
  
  datasets <- list(read.csv("./src/data/norway.csv"), read.csv("./src/data/netherlands.csv"))
  
  client <- vtg::MockClient$new(datasets, "vtg.glm")
  results <- vtg.glm::dglm(client, dstar=NULL, formula=formula, types = types, family=family, tol=tol)
}