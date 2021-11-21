# import psycopg2
# import psycopg2.extras

#import uuid
# call it in any place of your program
# before working with UUID objects in PostgreSQL
#psycopg2.extras.register_uuid()

# host = 'localhost'
# dbname = 'TMDB'
# user = 'postgres'
# password = ''
# sslmode = 'allow'

# conn_string = 'host={} user={}  dbname={} password={} sslmode={}'.format(host,user,dbname,password,sslmode)
# conn = psycopg2.connect(conn_string)
# print('Connection~')

#cursor = conn.cursor()
#result = cursor.execute("INSERT INTO users (id,user_name ,email ,password) VALUES (%s,%s,%s,%s);",(uuid.uuid4(),"jackson" ,"B0729033@gmail.com","qwer1234"))
#conn.commit()
#cursor.close()

# conn.close()

import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer
import numpy as np
from ast import literal_eval

def df1():
    df1 = pd.read_csv(u'feature.csv')
    return df1
    # df1.head()

# df1 = df1()
import re
def sub(x):
    return (re.sub(r",", " ", x['feature']))

def cosine_sim(df1):
    # 將文件中的詞語轉換為詞頻矩陣
    cv = CountVectorizer()
    # 計算個詞語出現的次數
    cv_mx = cv.fit_transform(df1['feature'])
    # create cosine similarity matrix 餘弦相似度
    cosine_sim = cosine_similarity(cv_mx, cv_mx)
    return cosine_sim
    #print(cosine_sim)

# cosine_sim = cosine_sim(df1)

def indices(df1):
    indices = pd.Series(df1.index, index = df1['title'])
    return indices

# indices = indices(df1)

def user(df1):
    # create list of indices for later matching
    user = pd.read_csv(u'userlist.csv')
    df1.drop(['feature'],axis=1,inplace=True)
    user = pd.merge(user, df1, on='movieid')
    return user

# user = user(df1)

def userlist(user):
    new = user.title.to_list()
    return new
#user.head()
# for i in new:
#     print(i)
# userlist = userlist(user)

def recommend_movie(df1,indices,titles, n = 10, cosine_sim = cosine_sim):
    movies = []
    #for titles in userList
    for title in titles:
        # 檢索匹配的 movie_name index
        if title not in indices.index:
            print("Movie not in database.")
            return
        else:
            idx = indices[title]
        
        # 電影的餘弦相似度分數降序排列
        scores = pd.Series(cosine_sim[idx]).sort_values(ascending = False)
            
        # 前 n 個最相似的 movies indexes
        # 使用 1:n 因為 0 是輸入的同一部電影
        top_n_idx = list(scores.iloc[1:n].index)
                
        #return result
        #print(df1['movie_name'].iloc[top_n_idx])
        ans = df1.iloc[top_n_idx]
        movies.append(ans)
    df = pd.concat(movies)    
    return df

def genres_words(x):
    return ('' + ' '.join(x['genres']))

def cast_words(x):
    return (' ' + ' '.join(x['string_agg']))

def ans(df1,indices,userlist,cosine_sim):
    #first count
    ans = recommend_movie(df1,indices,userlist,7,cosine_sim)
    ans = ans.drop_duplicates(keep='first', inplace=False,subset=['title'])
    #清洗數據
    ans['genres'] = ans['genres'].apply(literal_eval)
    ans['string_agg'] = ans['string_agg'].apply(literal_eval)
    ans['cast1'] = ''
    ans['genres1'] = ''
    ans['genres1'] = ans.apply(genres_words, axis = 1)
    ans['cast1'] = ans.apply(cast_words, axis = 1)
    ans.drop(['genres','string_agg'],axis=1,inplace=True)
    return ans

# ans = ans(df1,indices,userlist,cosine_sim)

# ans.head()
def users(user):
    #清洗數據
    user['genres'] = user['genres'].apply(literal_eval)
    user['string_agg'] = user['string_agg'].apply(literal_eval)
    user['cast1'] = ''
    user['genres1'] = ''

    user['genres1'] = user.apply(genres_words, axis = 1)
    user['cast1'] = user.apply(cast_words, axis = 1)
    user.drop(['genres','string_agg'],axis=1,inplace=True)
    return user
    # ans.head()
# users = users(user)

def movie_vec(ans):
    #genres
    featureG = ans.genres1.str.split(',', expand=True).stack().str.get_dummies().sum(level=0)
    #cast
    featureC = ans.cast1.str.split(',', expand=True).stack().str.get_dummies().sum(level=0)
    movie_vec = featureG.merge(featureC, how='inner', left_index=True, right_index=True)
    #movie_vec = movie_vec.merge(featureC, how='inner', left_index=True, right_index=True)
    movie_vec = pd.concat([ans,movie_vec], axis=1)
    movie_vec.set_index('movieid',inplace=True)
    movie_vec.drop(['genres1','cast1','title'],axis=1,inplace=True)
    return movie_vec
    #final = ans.drop_duplicates(keep='first', inplace=False,subset=['movie_name'])
# movie_vec = movie_vec(ans)

def user_vec(users):
    #genres
    featureGU = users.genres1.str.split(',', expand=True).stack().str.get_dummies().sum(level=0)
    #cast
    featureCU = users.cast1.str.split(',', expand=True).stack().str.get_dummies().sum(level=0)
    user_vec = pd.DataFrame()
    user_vec = user_vec.reindex(columns =movie_vec.columns)
    user_vec = user_vec.merge(featureGU, how='outer')
    #user_vec = user_vec.merge(featureDU, how='outer')
    #user_vec = user_vec.merge(featureCU, how='outer')
    #user_vec = user_vec.merge(featureGU, how='inner', left_index=True, right_index=True)
    user_vec = user_vec.merge(featureCU, how='inner', left_index=True, right_index=True)
    user_vec = pd.concat([users, user_vec], axis=1)
    user_vec.drop(['genres1','cast1','movieid','title'],axis=1,inplace=True)
    user_vec = user_vec.fillna(0.0)
    user_vec = user_vec.groupby('userId').mean()
    user_vec = user_vec[movie_vec.columns]
    return user_vec
# user_vec = user_vec(users)

def user_movie_matrix(user_vec,movie_vec):
    #user movie similar matrix
    user_movie_matrix = cosine_similarity(user_vec.values,movie_vec.values)
    user_movie_matrix = 1- user_movie_matrix 
    user_movie_matrix = pd.DataFrame(user_movie_matrix, index=user_vec.index,columns=movie_vec.index)
    return user_movie_matrix

# user_movie_matrix = user_movie_matrix(user_vec,movie_vec)

def get_the_most_similar_movies(user_id, user_movie_matrix,num):
 user_vec = user_movie_matrix.loc[user_id].values 
 sorted_index = np.argsort(user_vec)[:num]
 return list(user_movie_matrix.columns[sorted_index])

# get_the_most_similar_movies = get_the_most_similar_movies(1, user_movie_matrix,4)


if __name__ == '__main__':
    import pandas as pd
    from sklearn.metrics.pairwise import cosine_similarity
    from sklearn.feature_extraction.text import CountVectorizer
    import numpy as np
    from ast import literal_eval
    import time
    start = time.time()
    df1 = df1()
    df1['feature'] = df1.apply(sub, axis = 1)
    cosine_sim = cosine_sim(df1)
    indices = indices(df1)
    user = user(df1)
    userlist = userlist(user)
    ans = ans(df1,indices,userlist,cosine_sim)
    users = users(user)
    movie_vec = movie_vec(ans)
    user_vec = user_vec(users)
    user_movie_matrix = user_movie_matrix(user_vec,movie_vec)

    get_the_most_similar_movies = get_the_most_similar_movies(1, user_movie_matrix,4)
    end = time.time()
    print(get_the_most_similar_movies)
    print(end - start)






