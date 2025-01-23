#!/usr/bin/env python3
# go to openai and make an API key
# save in this directory as OPENAI_API_KEY.txt
import os,sys
from openai import OpenAI


# this will fail if you haven't created your key
with open('OPENAI_API_KEY.txt') as api_key: os.environ['OPENAI_API_KEY'] = api_key.read()

client = OpenAI()

if len(sys.argv) > 1:
    input = sys.argv[1]
else:
    input = "you're a jolly roger!"

response = client.moderations.create(
  model="omni-moderation-latest",
  input=input
  #input="...text to classify goes here...",
)

#print(response)
results = response.results[0]
cats = [cat for cat,decision in results.categories]
dogs = [decision for cat,decision in results.categories]
scores = [score for cat,score in results.category_scores]


print("Text: %s" % input)
for category,score,decision in zip(cats,scores,dogs):
    print("%.4f" % score, category, decision, sep="\t")
