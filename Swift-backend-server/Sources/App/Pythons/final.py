# -*- coding: utf-8 -*-
"""final.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1K0yTxX9qsns69dQQ9xdE2zk6_gvR8V-f
"""
import json

def hello(data):
    temp = json.loads(data)
    print(temp["Genres"])

#import gzip
#import json
#import pandas as pd
#import requests
#from io import BytesIO
##抓取今年的file
#def make_category_id_url_suffix(category, extension='json'):
#    year = str(pd.datetime.today().year)
#    month = str(pd.datetime.today().month).zfill(2)
#    day = str(pd.datetime.today().day - 1).zfill(2)
#    return '_'.join([category, 'ids', month, day, year]) + '.' + extension
#
##Download ID list
#def download_id_list_as_csv(category):
#
#    print(f'Downloading list of ids for {category}')
#    id_list_name = make_category_id_url_suffix(category)
#    ID_LISTS_RAW_URL = 'http://files.tmdb.org/p/exports/{0}.gz'.format(id_list_name)
#    with gzip.open(BytesIO(requests.get(ID_LISTS_RAW_URL).content), 'r') as f_open:
#        id_list = f_open.readlines()
#    # original 'json' is malformed, is actually one dict per line
#    ids = pd.DataFrame([json.loads(x) for x in id_list])
#    # some entries in the movie id list appear to be collections rather than movies
#    if 'original_title' in ids.columns:
#        ids.original_title = ids.original_title.apply(str)
#        ids = ids[~ids.original_title.str.endswith(' Collection')].copy()
#    # You have to drop adult films if you want to post any new data to Kaggle.
#    if 'adult' in ids.columns:
#        ids = ids[~ids['adult']].copy()
#    ids.to_csv(category + '_ids.csv', index=False)
#
#download_id_list_as_csv('movie')
#
#import requests
#import pandas as pd
#import re
#import json
#import csv
#
##Read all tmdbID
#df = pd.read_csv('movie_ids.csv')
#
#with open("movie.csv",mode="w") as fi:
#    writer = csv.writer(fi, delimiter=',')
#    writer.writerow(['index','movie_id', 'movie_name', 'genres','overview','original_language'])
#    num = 1
#    #Write Data to csv
#    for value in df['id']:
#        #for i,value in enumerate(df['id'])
#        if num >500:
#            break
#        url = 'https://api.themoviedb.org/3/movie/'+str(value)+'?api_key=6dfbbbfc10aa0e69930a9f512c59b66d&language=zh-TW&append_to_response=credits,keywords'
#        r = requests.get(url)
#        response = r.text
#        data = json.loads(response)
#
#        #Select zh-TW Movie Data
#        if not '\u4e00' <= data['title'] <= '\u9fa5':
#            continue
#        else:
#            num = num +1
#            writer.writerow([num,data['id'], data['title'], data['genres'],re.sub('\s+','',data['overview']),data['original_language']])
#
#import requests
#import pandas as pd
#import re
#import json
#import csv
#df1 = pd.read_csv(u'movie.csv')
#df1
#
## Extract list of genres
#from ast import literal_eval
#
#df1['genres'] = df1['genres'].apply(literal_eval)
#df1['genres']
#
#from opencc import OpenCC
#
#def list_genres(x):
#    cc = OpenCC('s2tw')
#    l = [cc.convert(d['name']) for d in x]
#    return(l)
#df1['genres'] = df1['genres'].apply(list_genres)
#
#df1['genres']
#
#missing = df1.columns[df1.isnull().any()]
#df1[missing].isnull().sum().to_frame()
#
## Replace NaN from overview with an empty string
#df1['overview'] = df1['overview'].fillna('')
#
#import jieba
#import jieba.analyse
##split overview
##print(df1['overview'])
#overviews = []
#for d in df1['overview'].astype(str):
#    keywords = jieba.analyse.extract_tags(d, topK=10)
#    overviews.append(keywords)
#
#df1['keyword'] = overviews
#
#import re
#
#df1['feature'] = ''
#def bag_words(x):
#    return (''.join(re.sub('[^\u4e00-\u9fa5]+', '', x['movie_name'])) + ' ' + ' '.join(x['genres']) + ' ' +  ' '.join(x['keyword']))
#df1['feature'] = df1.apply(bag_words, axis = 1)
#
#df1['feature'].head()
#
#feature = df1[['movie_id','movie_name','feature']]
#feature.to_csv('feature.csv',index=False)
#
#import pandas as pd
#from sklearn.metrics.pairwise import cosine_similarity
#from sklearn.feature_extraction.text import CountVectorizer
## 將文件中的詞語轉換為詞頻矩陣
#cv = CountVectorizer()
## 計算個詞語出現的次數
#cv_mx = cv.fit_transform(df1['feature'])
#
## create cosine similarity matrix
#cosine_sim = cosine_similarity(cv_mx, cv_mx)
#print(cosine_sim)
#
## create list of indices for later matching
#indices = pd.Series(df1.index, index = df1['movie_name'])
#
#def recommend_movie(title, n = 10, cosine_sim = cosine_sim):
#    movies = []
#
#    # 檢索匹配的 movie_name index
#    if title not in indices.index:
#        print("Movie not in database.")
#        return
#    else:
#        idx = indices[title]
#
#    # 電影的餘弦相似度分數降序排列
#    scores = pd.Series(cosine_sim[idx]).sort_values(ascending = False)
#
#    # 前 n 個最相似的 movies indexes
#    # 使用 1:n 因為 0 是輸入的同一部電影
#    top_n_idx = list(scores.iloc[1:n].index)
#
#    #return result
#    print(df1['movie_name'].iloc[top_n_idx])
#    #ans = df1['movie_name'].iloc[top_n_idx]
#    #ans.to_csv('result.csv',index = False)
#
#recommend_movie('玩具總動員',5)
