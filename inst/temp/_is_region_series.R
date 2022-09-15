time_d<-c()
for (i in seq_len(length(x))){
  time_d[i]<-length(time(x[i]))
}
if (length(unique(time_d))!=1){
  stop("the variables differ in the number of time steps")
}