---
title: On LLM reproducibility
author: Aritra Biswas
date: '2025-03-09'
slug: on-llm-reproducibility
categories:
  - programming
tags:
  - LLM
  - GenAI
subtitle: ''
summary: ''
authors: []
lastmod: '2025-03-09T12:46:59+05:30'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

One of the major issue with LLM output is its consistency and reproducibility. Here is kind of a hacky work around to make output from a LLM consistent (kind of). Also, a few observation regarding the same. Here I am following a MSFT article linked in the reference. Need to use the a GPT 4o model with version `2024-05-13` for this. Also note here using AOAI API version `2024-10-21`.

### Setting up two instances of LLM with different configs

```txt
Deployment info
Name: gpt-4o
Model name: gpt-4o
Model version: 2024-05-13
Azure OAI API version: 2024-10-21
```

```env
AZURE_OPENAI_API_KEY=<AZURE_OPENAI_API_KEY>
AZURE_OPENAI_ENDPOINT=<AZURE_OPENAI_ENDPOINT>
AZURE_OPENAI_API_VERSION="2024-10-21"
AZURE_OPENAI_GPT4O_MODEL_NAME="gpt-4o"
AZURE_OPENAI_GPT4O_DEPLOYMENT_NAME="gpt-4o"
```

```python
from langchain_openai import AzureChatOpenAI
import pandas as pd
from dotenv import load_dotenv
import time
load_dotenv()
consistent_llm = AzureChatOpenAI(
    api_key=AZURE_OPENAI_API_KEY,
    azure_endpoint=AZURE_OPENAI_ENDPOINT,
    azure_deployment=AZURE_OPENAI_GPT4O_DEPLOYMENT_NAME,
    api_version=AZURE_OPENAI_API_VERSION,
    temperature=0,
    seed=42,
    max_tokens=50
)
less_consistent_llm = AzureChatOpenAI(
    api_key = AZURE_OPENAI_API_KEY,
    azure_endpoint = AZURE_OPENAI_ENDPOINT,
    azure_deployment=AZURE_OPENAI_GPT4O_DEPLOYMENT_NAME,
    api_version=AZURE_OPENAI_API_VERSION,
)
```

### Generation without any context

In this experiment generating 50 samples where the generation is not grounded on context. In way it is more free to choose the next word.

```python
consistent_arr_res = []
less_consistent_arr_res = []
messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {
        "role": "user",
        "content": "Tell me a story about how the universe began? in 15 words",
    },
]

for idx in range(50):
    print(f"Story Version {idx + 1}\n---")
    consistent_res = consistent_llm.invoke(input=messages)
    less_consistent_res = less_consistent_llm.invoke(input=messages)
    less_consistent_arr_res.append(less_consistent_res.content)
    consistent_arr_res.append(consistent_res.content)
    print("---\n")
    del consistent_res
    del less_consistent_res

consistent_df = pd.DataFrame(consistent_arr_res, columns = ['res'])
less_consistent_df = pd.DataFrame(less_consistent_arr_res, columns = ['res'])
```

Observation in 50 generation with consistent LLM (with seed 42, max_token 50 and temperature 0) it has generated the below table.

#### Consistent dataframe 1

```python
print(consistent_df.value_counts().to_frame().to_markdown())
```

|                                                                                                                    |   count |
|:-------------------------------------------------------------------------------------------------------------------|--------:|
| ('In a cosmic explosion, the universe expanded, stars formed, and life eventually emerged.',)                      |      19 |
| ("In a vast void, a singularity exploded, birthing stars, galaxies, and the universe's endless wonders.",)         |      15 |
| ('In a cosmic explosion, energy and matter formed stars, galaxies, and life, creating our universe.',)             |       6 |
| ('The universe began with a massive explosion, expanding rapidly, forming stars, galaxies, and cosmic wonders.',)  |       3 |
| ('The universe began with a massive explosion, expanding rapidly, forming stars, galaxies, and everything else.',) |       3 |
| ('The universe began with a massive explosion, expanding rapidly, forming stars, galaxies, and life.',)            |       3 |
| ("In a vast void, a singularity exploded, birthing stars, galaxies, and the universe's wonders.",)                 |       1 |

#### Less Consistent dataframe 1

Observation in 50 generation with inconsistent LLM it has generated the below table.

```python
print(less_consistent_df.value_counts().to_frame()/head(5).to_markdown())
```

|                                                                                                                         |   count |
|:------------------------------------------------------------------------------------------------------------------------|--------:|
| ('A cosmic explosion birthed stars, planets, and galaxies, igniting the endless dance of creation.',)                   |       1 |
| ('Stars ignited, galaxies whirled; from cosmic dawn, life sprung, evolving endlessly in infinite wonder.',)             |       1 |
| ('In the beginning, a Big Bang created stars, galaxies, and everything we know today.',)                                |       1 |
| ('In the beginning, a cosmic explosion birthed stars, planets, and galaxies, igniting infinite possibilities.',)        |       1 |
| ('In the beginning, a massive explosion unleashed energy, forming stars, planets, and endless possibilities.',)         |       1 |

Here showing just to 5 sample. But all 50 generation are unqiue.

### Generation with context

Now, we will ground generation using some context. Here is a short summary of short stories from wikipedia.

```python
text = """A short story is a piece of prose fiction. It can typically be read in a single sitting and focuses on a self-contained incident or series of linked incidents, with the intent of evoking a single effect or mood. The short story is one of the oldest types of literature and has existed in the form of legends, mythic tales, folk tales, fairy tales, tall tales, fables, and anecdotes in various ancient communities around the world. The modern short story developed in the early 19th century.[1]
Definition
The short story is a crafted form in its own right. Short stories make use of plot, resonance and other dynamic components as in a novel, but typically to a lesser degree. While the short story is largely distinct from the novel or novella/short novel, authors generally draw from a common pool of literary techniques.[citation needed] The short story is sometimes referred to as a genre.[2]
Determining what exactly defines a short story remains problematic.[3] A classic definition of a short story is that one should be able to read it in one sitting, a point most notably made in Edgar Allan Poe's essay "The Philosophy of Composition" (1846).[4] H. G. Wells described the purpose of the short story as "The jolly art, of making something very bright and moving; it may be horrible or pathetic or funny or profoundly illuminating, having only this essential, that it should take from fifteen to fifty minutes to read aloud."[5] According to William Faulkner, a short story is character-driven and a writer's job is to "...trot along behind him with a paper and pencil trying to keep up long enough to put down what he says and does."[6]
Some authors have argued that a short story must have a strict form. Somerset Maugham thought that the short story "must have a definite design, which includes a point of departure, a climax and a point of test; in other words, it must have a plot".[5] Hugh Walpole had a similar view: "A story should be a story; a record of things happening full of incidents, swift movements, unexpected development, leading through suspense to a climax and a satisfying denouement."[5]
This view of the short story as a finished product of art is however opposed by Anton Chekhov, who thought that a story should have neither a beginning nor an end. It should just be a "slice of life", presented suggestively. In his stories, Chekhov does not round off the end but leaves it to the readers to draw their own conclusions.[5]
Sukumar Azhikode defined a short story as "a brief prose narrative with an intense episodic or anecdotal effect".[3] Flannery O'Connor emphasized the need to consider what is exactly meant by the descriptor short.[7] Short story writers may define their works as part of the artistic and personal expression of the form. They may also attempt to resist categorization by genre and fixed formation.[5]
William Boyd, a British author and short story writer, has said:
[a short story] seem[s] to answer something very deep in our nature as if, for the duration of its telling, something special has been created, some essence of our experience extrapolated, some temporary sense has been made of our common, turbulent journey towards the grave and oblivion.[8]
In the 1880s, the term "short story" acquired its modern meaning – having initially referred to children's tales.[9] During the early to mid-20th century, the short story underwent expansive experimentation which further hindered attempts to comprehensively provide a definition.[3] Longer stories that cannot be called novels are sometimes considered "novellas" or novelettes and, like short stories, may be collected into the more marketable form of "collections". Around the world, the modern short story is comparable to lyrics, dramas, novels and essays – although examination of it as a major literary form remains diminished.[3][10]"""
```

Now, asking LLMs to generate a summary using the given context.

```python
consistent_arr_res_summary = []
less_consistent_arr_res_summary = []
messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": f"summarize this text in 15 words: {text}"},
]
for i in range(50):
    print(f"Story Version {i + 1}\n---")
    consistent_res_summary = consistent_llm.invoke(input=messages)
    less_consistent_res_summary = less_consistent_llm.invoke(input=messages)
    less_consistent_arr_res_summary.append(less_consistent_res_summary.content)
    consistent_arr_res_summary.append(consistent_res_summary.content)
    print("---\n")
    del consistent_res_summary
    del less_consistent_res_summary
    time.sleep(1)
```

#### Consistent dataframe 2

Observation in 50 generation with consistent LLM (with seed 42, max_token 50 and temperature 0) it has generated the below table. As you can see it is way more consistent. 46 time it has generated same output and 4 times the output is different but the main different in these two is of a single charecter. 

```python
print(consistent_df_summary.value_counts().to_frame().to_markdown())
```

|                                                                                                   |   count |
|:--------------------------------------------------------------------------------------------------|--------:|
| ('A short story is a brief, self-contained prose fiction, read in one sitting, evoking a mood.',) |      46 |
| ('A short story is a brief, self-contained prose fiction, read in one sitting, evoking mood.',)   |       4 |

#### Less Consistent dataframe 2

Observation in 50 generation with inconsistent LLM it has generated the below table.

```python
print(less_consistent_df_summary.value_counts()head(5).to_frame().to_markdown())
```

|                                                                                                                               |   count |
|:------------------------------------------------------------------------------------------------------------------------------|--------:|
| ('A short story is a brief piece of prose fiction read in a single sitting.',)                                                |       1 |
| ('A short story is a concise prose narrative, focusing on a single effect or mood.',)                                         |       1 |
| ('A short story is a brief, self-contained prose fiction focusing on a single effect or mood.',)                              |       1 |
| ('A short story is a brief, self-contained prose fiction focusing on a single incident or mood.',)                            |       1 |
| ('A short story is a brief, self-contained prose fiction read in one sitting, evoking a single effect.',)                     |       1 |


Again this is a sample of head 5. But as you can see that all the 50 generations are unique and different from one another.

### Reference

* [Learn how to use reproducible output](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/reproducible-output?tabs=pyton)
* [Short story](https://en.wikipedia.org/wiki/Short_story)