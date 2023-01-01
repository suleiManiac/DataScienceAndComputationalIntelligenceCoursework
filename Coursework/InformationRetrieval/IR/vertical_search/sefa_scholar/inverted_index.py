import string

import pandas as pd
import numpy as np
import re
import sys
import nltk 
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
stemmer = PorterStemmer()
nltk.download('punkt')
nltk.download('stopwords')
from nltk.corpus import stopwords
stopword = stopwords.words('english')
import collections
from nltk.stem.porter import PorterStemmer


file_path = '/home/sy/Desktop/IR/vertical_search/sefa_scholar/authors.csv'

def create_inverted_index(file_path):
  df_crawled_info= pd.read_csv(file_path)
  df_titles=df_crawled_info["Title"]
  
  inverted_index={}

  doc_id = 0
  for x in df_titles:
    #print('review', doc_id)
    #no_dashes = [t.replace('-', ' ') for t in x]
    #a_string.translate(str.maketrans('', '', string.punctuation))
    token = word_tokenize(x)
    token = [t.translate(str.maketrans('', '', string.punctuation)) for t in token]
    token = [x for x in token if x]
    token_lower = [w.lower() for w in token]
    #no_dashes = [t.replace('-', ' ') for t in token_lower]
    removing_stopwords = [w for w in token_lower if w not in stopword]
    stemmed_title = [stemmer.stem(w) for w in removing_stopwords]

    for a in stemmed_title: 
      val = inverted_index.get(a)
      if val == None:
        temp_list = [1,[doc_id]]
        inverted_index[a] = temp_list
      else:
        temp_list =  inverted_index[a]
        if doc_id not in temp_list[1]:
          temp_list[1].append(doc_id)
          temp_list[0] += 1

    doc_id+=1   

  ordered_inverted_index = collections.OrderedDict(sorted(inverted_index.items()))
  return ordered_inverted_index

index_of_titles = create_inverted_index(file_path)

def processQuery(text):
  #token = word_tokenize(text)
  #token_lower = [w.lower() for w in token]
  #stemmed_title = [stemmer.stem(w) for w in token_lower]
    token = word_tokenize(text)
    token = [t.translate(str.maketrans('', '', string.punctuation)) for t in token]
    token = [x for x in token if x]
    token_lower = [w.lower() for w in token]
    removing_stopwords = [w for w in token_lower if w not in stopword]
    stemmed_query = [stemmer.stem(w) for w in removing_stopwords]

    return stemmed_query


def search(stemmed_query, index_of_titles):
    all_pl=[]
    for term in stemmed_query:
        pl = index_of_titles.get(term)
        if pl is not None:
            #print(s)
            #print(pl)
            all_pl.append(pl[1])
    
    return all_pl

def search_results(all_pl):
    df = pd.read_csv(file_path)
    result_ids = list(set.intersection(*map(set,all_pl)))
    #df_search = [df.columns[0:5]]
    #the_result = df.iloc[result_ids]
    the_result = df.iloc[result_ids].T.to_dict('dict')

    return the_result

