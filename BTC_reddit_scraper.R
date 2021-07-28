#Bitcoin subreddit Dataminer

library(rvest)
library(sentimentr)

#read all links of threads with recent comments (last hour)
newlink <- "https://www.reddit.com/r/Bitcoin/comments/"
pageflag <- F
pagenow <- read_html(newlink)
links <- as.character()
raw_cur_page <- NULL

while (!pageflag){
  pagenow <- read_html(newlink)
  
  if (sum(grep("minute|now", pagenow %>%
    html_nodes("time.live-timestamp")%>%
    html_text()))== 0) {
      pageflag = T
      
    
            next
  }
    raw_cur_page <-pagenow %>%
        html_nodes("a.bylink")%>%
        html_attr("href")
    
    links<- append(links, raw_cur_page[seq(1,75,3)])
    newlink <- pagenow%>%
      html_nodes("span.next-button")%>%
      html_nodes("a")%>%
      html_attr("href")
      
}

#read comments in each link

comment_vec <- character()

for (i in links){
  curr_link <- read_html(i)
  
  comments_curr_link <- curr_link%>%
    html_nodes("div._1ump7uMrSA43cqok14tPrG")%>%
    html_nodes("p")%>%
    html_text()
  
  time_curr_link <- curr_link%>%
    html_nodes("div._1ump7uMrSA43cqok14tPrG")%>%
    html_nodes("div._3tw__eCCe7j-epNCKGXUKk")%>%
    html_nodes("a")%>%
    html_text()
  
  comm_lasthour <- comments_curr_link[grep("minute|now", time_curr_link)]
  
  comment_vec <- append(comment_vec, comm_lasthour)
  
}



# give sentiment score & save in local .csv
sentim<- (sentiment(comment_vec))

avrg_sentim <- sum(sentim[,4])/length(t(sentim[,4]))

senti_table <- read.csv("C:\\R-Daten\\data Scraping\\avrg_sentiment_table.csv")[,2:6]
senti_table[nrow(senti_table)+1,] <-c(avrg_sentim,as.character(Sys.time()),
                                      length(links), nrow(sentim), sd(sentim$sentiment))

write.csv(senti_table, file = "avrg_sentiment_table.csv"
            )
print(tail(senti_table))

