# vtg.pss
Implementation of the federated Propensity Score Matching for the [vantage6](https://github.com/IKNL/VANTAGE6) federated infrastructure.

## Installation
Run the following in the R console to install the package and its dependencies:

```R
# This also installs the package vtg
devtools::install_github('iknl/vtg.dglm', subdir='src')
devtools::install_github('iknl/vtg.pss', subdir='src')
```

## Example use
```R
setup.client <- function() {
  # Define parameters
  username <- "username@example.com"
  password <- "password"
  host <- 'https://trolltunga.vantage6.ai'
  api_path <- ''

  # Create the client
  client <- vtg::Client$new(host, api_path=api_path)
  client$authenticate(username, password)

  return(client)
}

# Create a client
client <- setup.client()

# Get a list of available collaborations
print( client$getCollaborations() )

# Should output something like this:
#   id     name
# 1  1 ZEPPELIN
# 2  2 PIPELINE

# Select a collaboration
client$setCollaborationId(1)

# PSS algorithm only works with master container as it is making using of the local temporary volumes.
client$use.master.container = T

# Specify column types
types=list(diagyear=list(type='factor',levels=c("2017","2018")),
           grade=list(type='factor',levels=c(1:3,9)),
           hist=list(type='factor',levels=c("Ductal", "Lobulair", "Other")),
           pT=list(type='factor',levels=c(1:4, "Unknown", "X")),
           pN=list(type='factor',levels=c(0:3, "Unknown", "X")),
           her2=list(type='factor',levels=c("Negative", "Positive", "Unknown")),
           er=list(type='factor',levels=c("Negative", "Positive", "Unknown")),
           pr=list(type='factor',levels=c("Negative", "Positive", "Unknown")))
           

# vtg.dglm contains the function `dglm`.
model <- vtg.glm::dglm(client, formula = num_awards ~ prog + math, family="poisson",tol= 1e-08,maxit=25, types=types)
glm_model <- vtg.pss::as.GLM(model)


# PSS 
vtg.pss::pss(client, glm_model, 3, FALSE, types)

```