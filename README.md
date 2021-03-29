# NonFirstAuthor
R Function for identifying non-first authors from Zotero JSON Libraries

A short R script that will take a JSON file exported from Zotero, and return a list of all non-first authors in the library. In doing so, there may be unfamiliar
names of authors who are involved in relevant work to your current reading.

The script will first install (if necessary) and load the needed libraries (jsonlite and tidyverse)

Then the main function will take the authors, split the file into first authors and non-first authors, count the frequency of any non-first authord and
then remove anyone who is also a first author from the list. An object called NonFirstAuthor will be added to your environment that details all these authors.

The function takes two arguments, the filepath and limit (T/F) that if T, only shows authors who appear more than once.

It takes authors as specified in Zotero, and cannot necessarily ascertain differences between J. Bloggs and Jo Bloggs, etc. etc.
