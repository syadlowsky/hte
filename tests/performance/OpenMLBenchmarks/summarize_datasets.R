options( java.parameters = "-Xmx1000g")
library("OpenML")
setOMLConfig(apikey = "6e7606dcedb2a6810d88dfaa550f7f07", arff.reader = "RWeka") # https://www.openml.org/u/3454#!api
#library("OpenML");setOMLConfig(apikey = "6e7606dcedb2a6810d88dfaa550f7f07", arff.reader = "farff") # https://www.openml.org/u/3454#!api

# ------------------------------------------------------------------------------
library(dplyr)

tasks = listOMLTasks(limit = 100000)
regression_tasks <-
  tasks[tasks$task.type == "Supervised Regression", ]
n_datasets <- nrow(regression_tasks)

data_folder_name <- "sim_data/"
if (!dir.exists(data_folder_name)) dir.create(data_folder_name)
filename <- paste0(data_folder_name, "openML_dataset_summary.csv")

if(file.exists(filename)){
  done_tasks <- unique(read.csv(filename)$data.id)
}else{
  done_tasks <- character()
}

for (i in 1:nrow(regression_tasks)) {
  # i <- 54

    print(paste0("      Starting with i = ",
                 i,
                 " of ",
                 n_datasets))
    
    clearOMLCache()
    gc(verbose = getOption("verbose"), reset=FALSE)
        OpenML::clearOMLCache()
    
  data.id <- regression_tasks[i, "data.id"]

  # the read function sometimes fails. In that case run the next data set
  data_set <- tryCatch({
    getOMLDataSet(data.id = data.id)
  },
  error = function(e) {
    print(e)
    NA
  })
  if (is.na(data_set)) next
  if (is.na(data_set$target.features[1])) next

  if(data.id %in% done_tasks){
    print("This data set target combination ran before. We will skip it.")
    next
  }
  done_tasks <- c(done_tasks, data.id)

  non_missing_rows <- apply(!is.na(data_set$data), 1, all) # only take rows which
  # which don't have missing values

  features <-
    data_set$data[non_missing_rows, colnames(data_set$data) != data_set$target.features]
  target <-
    data_set$data[non_missing_rows,  colnames(data_set$data) == data_set$target.features]

  # save the results
  ds_features <- data.frame(
    data.id = data.id,
    target_var = var(target),
    n_features = ncol(features),
    n_obs = nrow(features)
  )

  col.names <- !file.exists(filename)
  write.table(
    ds_features,
    file = filename,
    append = TRUE,
    col.names = col.names,
    row.names = FALSE,
    sep = ","
  )
    clearOMLCache()
    gc(verbose = getOption("verbose"), reset=FALSE)
    OpenML::clearOMLCache()
    print('.....................done.....................')

}
