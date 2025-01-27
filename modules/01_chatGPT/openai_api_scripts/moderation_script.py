#!/usr/bin/env python3
# go to openai and make an API key
# save in this directory as OPENAI_API_KEY.txt
import os,sys
from openai import OpenAI


# this will fail if you haven't created your key
with open('OPENAI_API_KEY.txt') as api_key: os.environ['OPENAI_API_KEY'] = api_key.read()

client = OpenAI()

if True:
  if len(sys.argv) > 1:
      input = sys.argv[1]
  else:
      input = "you're a jolly roger!"

  response = client.moderations.create(
    model="omni-moderation-latest",
    input=input
    #input="...text to classify goes here...",
  )
else:
  url = 'https://images.radiox.co.uk/images/592512?crop=16_9&width=660&relax=1&format=webp&signature=kxP0Z47W3ewyQOSrgCVHpqXDmKU='
  #url = 'https://townsquare.media/site/366/files/2016/02/Metallica-Metal-Up-Your-Ass.jpg?w=780&q=75' # Metallica Metal Up Your Ass
  #url = 'https://www.udiscovermusic.com/wp-content/uploads/2017/08/Ice-Cube-Death-Certificate-Album-Cover-web-720.jpg' # Ice Cube Death certificate
  response = client.moderations.create(
      model="omni-moderation-latest",
      input=[{"type": "image_url",
            "image_url": {
                "url": url
                }
            }]
    )
  input = url

#print(response)
results = response.results[0]
cats = [cat for cat,decision in results.categories]
dogs = [decision for cat,decision in results.categories]
scores = [score for cat,score in results.category_scores]


print("Query: %s" % input)
for category,score,decision in zip(cats,scores,dogs):
    print("%.4f" % score, category, decision, sep="\t")
