#!/usr/bin/env python3
import os,sys
from openai import OpenAI

with open('OPENAI_API_KEY.txt') as api_key: os.environ['OPENAI_API_KEY'] = api_key.read()
client = OpenAI()

if len(sys.argv) > 1:
    content = sys.argv[1]
else:
    content = "Write a haiku about recursion in programming."

print("sending completion...")
completion = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "developer", "content": "You are a helpful assistant."},
        {
            "role": "user",
            "content": content
        }
    ]
)
print(f"Prompt: {content}")
print(completion.choices[0].message.content)
