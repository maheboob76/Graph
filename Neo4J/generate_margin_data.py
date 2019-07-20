# -*- coding: utf-8 -*-
"""
Created on Sat Jul 20 11:54:39 2019

@author: Amaan
"""


for x in range(10):
  print (random.randint(1,100 ))



import random
import pandas as pd
import datetime

count_trades = 5000000
count_agreements = 100

def generate_trades(count_trades):
    columns = ['trade_id', 'trade_name', 'trade_created_date', 'trade_arr_status', 'agreement_id']
    lst = []
    
    for i in range(1, count_trades + 1):
        #print(i)
        d = { 'trade_id': i, 'trade_name': 'trade # {}'.format(i), 'trade_created_date': datetime.date(2019,7,1) , 'trade_arr_status': 'off', 'agreement_id': random.randint(1,100 )  }
        lst.append(d)
        
    return pd.DataFrame(lst, columns=columns)


def generate_agreements(count_agreements):
    columns = ['agreement_id', 'agreement_name', 'agreement_created_date']
    lst = []
    
    for i in range(1, count_agreements + 1):
        #print(i)
        d = { 'agreement_id': i, 'agreement_name': 'agreement # {}'.format(i), 'agreement_created_date': datetime.date(2019,7,1)   }
        lst.append(d)
        
    return pd.DataFrame(lst, columns=columns)




def generate_relationships(count_agreements, count_trades):
    columns = ['agreement_id', 'trade_id']
    lst = []
    
    for i in range(count_trades):
        #print(i)
        d = { 'agreement_id': random.randint(1,count_agreements ) , 'trade_id': random.randint(1,count_trades )   }
        lst.append(d)
        
    return pd.DataFrame(lst, columns=columns)



df = generate_trades(count_trades)
df.to_csv('margin_trades.csv' , index=False)

df = generate_agreements(count_agreements)
df.to_csv('margin_agreements.csv' , index=False)


df = generate_relationships(count_agreements, count_trades)
df.to_csv('trade_relationships.csv' , index=False)
