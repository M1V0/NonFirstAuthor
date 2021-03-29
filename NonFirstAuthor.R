#This install function() will install and load the jsonlite and tidyverse library
install <- function() {
  #The below three lines checks if jsonlite and tidyverse are installed, and install if necessary
  list.of.packages <- c("jsonlite", "tidyverse") #jsonlite needed to import JSON files, tidyverse for df manipulating
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  
  #Once installed, then load the libraries
  lapply(list.of.packages, require, character.only = T)
}

#This function will take a Zotero-exported JSON file of papers and provide an output object called `NotFirstAuthor` 
#containing the names of authors who are not first authors. If needed it will install jsonlite and tidyverse which
#are needed for it to work. If limit is set to True (default) you will only get an object of authors who appear more
#than once in the JSON, if set to False, then you get a return of all authors who are not first authors.
#
#It is anticipated this function may be of use to anyone who is currently doing a literature review and may not be aware
#of some of the non-first authors who are potentially working in very similar fields as to the first authors.

ExtractOtherAuthor <- function(JSON, limit = T) { 
  #Two arguments, filepath and whether you want to limit the results to those who appear more than once or not

  Authors <- JSON$author #Select the author column from JSON file
  
  #Both for later use...
  OtherAuthor <- NULL
  firstAuthor <- NULL
  

  for (i in 1:length(Authors)) { #loop through all papers in JSON file
    
    ##Deal with first authors now
    UnlistedAuthorForLoop1 <- unlist(Authors[[i]][1,]) #split into vector values and then combine into readable format
    Author_i1 <- paste(UnlistedAuthorForLoop1[2], UnlistedAuthorForLoop1[1], sep = " ") 
    
    firstAuthor <- append(firstAuthor, Author_i1) #append to the vector

    #Now look at non-first authors
     for (n in 2:nrow(as.data.frame(Authors[i]))) { #for all other authors that are not first...
       
       if(length(2:nrow(as.data.frame(Authors[i]))) !=2) { # only if it is not a single-authored paper
       
       UnlistedAuthorForLoop <- unlist(Authors[[i]][n,]) #same process as above but append to otherauthor
       
       Author_i <- paste(UnlistedAuthorForLoop[2], UnlistedAuthorForLoop[1], sep = " ")
       
       OtherAuthor <- append(OtherAuthor, Author_i)
     }
     }
    
  }
  #manipulate first authors into a df and remove any duplicates
    firstAuthor <- as.data.frame(firstAuthor)
    firstAuthor <- unique(firstAuthor)
    
    #manipulate non-first authors into df and get a count of reccurence
    OtherAuthor <- as.data.frame(OtherAuthor)
    OtherAuthor <- group_by(OtherAuthor, OtherAuthor) %>% count(OtherAuthor) %>% arrange(desc(n)) #arrange descending
    
    #Then use anti-join to remove any first authors present in the non-first author df
    NotFirstAuthor <- OtherAuthor[!(OtherAuthor$OtherAuthor %in% firstAuthor$firstAuthor),] %>% as.data.frame()
    
    if (limit == F) { #if limit false, save all non-first authors
      NotFirstAuthor <<- NotFirstAuthor
    }
    else { # only save to output those authors who appear more than once in the search
      NotFirstAuthor <<- filter(NotFirstAuthor, n != 1)
    }

}

install() #install and load libraries

fromJSON("~/Documents/PhD/Library.json") %>%  # Specify the JSON filepath, pipe for STYLE
ExtractOtherAuthor() #run function
