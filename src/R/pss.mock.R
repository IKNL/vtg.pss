pss.mock <- function(model, stratum, trimming) {
  
  datasets <- list(read.csv("./src/data/norway.csv"), read.csv("./src/data/netherlands.csv"))
  
  client <- vtg::MockClient$new(datasets, "vtg.pss")
  client$use.master.container = FALSE
  
  types=NULL
  model <- vtg.pss::dglm.mock(formula = country ~ age + educ + black + hispan + married + nodegree, family = "binomial", types=types)
  model <- vtg.pss::as.GLM(model)
  
  vtg::log$warn("PSS ---------------------------------------------")
  
  results <- vtg.pss::pss(client, model, stratum, trimming)
}

# glm_model <- ReadRDS("./src/data/model.model")
# model <- vtg.glm::dglm.mock(formula = country ~ age + educ + black + hispan + married + nodegree, family = "binomial")
# vtg.pss:pss.mock(glm_model, 3, FALSE)
