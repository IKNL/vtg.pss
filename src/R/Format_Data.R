Format_Data=function(Data,types){
  column_names = names(types)
  for(i in 1:length(types)){
    column_name = column_names[i]
    specs = types[[i]]
    type_ = specs$type
    if (type_ == "numeric"){
      Data[[column_name]] = as.numeric(Data[[column_name]])
    }
    if (type_ == "factor"){
      Data[[column_name]] = factor(Data[[column_name]], levels=specs$levels)
    }
  }
  return(Data)}