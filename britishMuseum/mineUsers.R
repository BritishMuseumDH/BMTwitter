#' ----
#' title: " A script for getting all users on Twitter with @britishmuseum in their bio"
#' author: "Daniel Pett"
#' date: "09/06/2016"
#' output: csv_document
#' ----
  setwd("~/Documents/research/twitter/britishMuseum/") #MacOSX
  print(getwd())
  if(packageVersion("devtools") < 1.6) {
    install.packages("devtools")
  }
  devtools::install_github('mkearney/rtweet')
  library(rtweet)
  twitter_tokens <- c(
    create_token(
      app = '', #The app name
      consumer_key = '', # The consumer token
      consumer_secret = '' # The consumer secret
      )
    )
  home_directory <- normalizePath(getwd())
  file_name <- paste0(home_directory, '/', 'twitter_tokens')
  save(twitter_tokens, file = file_name)
  
  users <- search_users(q= 'britishmuseum', n = 100, token = twitter_tokens) 
  users <- as.data.frame(unique(users))
  head(users)
  users <- users[order(-users$followers_count),]
  count <- sum(users$followers_count) # Add follower counts
  head(count)
  #Now drop columns you don't need
  keeps <- c('name','screen_name','description', 'location', 'verified',
             'followers_count', 'statuses_count', 'created_at')
  raw <- users[,(names(users) %in% keeps)]
  save_as_csv(raw, 'cutdown')