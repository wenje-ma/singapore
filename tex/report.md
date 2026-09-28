# Bayesian Optimization on Multi-Fidelity Data

## Title Page

Title: Bayesian Optimization on Multi-Fidelity Data — Making every precise measurement more valuable

Author: Wenje Ma

Institution: Beijing Institute of Technology

**notes**

Hello everyone, I am Wenje Ma. Today I want to share my recent work. It is about one question: when our budget for experiments is small, how do we make each experiment more valuable? I will keep it simple, and it takes about fifteen minutes.

## Begin: A Story

**notes**

Let me start with a story. Imagine you work for a company, and your job is to tune some parameters. You have an experiment, but it is very expensive — every run costs a lot, and you can only afford fifteen runs in total.

The hard part: there are more than ten parameters, and they affect each other. Change one, and the others may change too. So you cannot try them one by one. You need the best combination of all of them, but you have only fifteen chances.

What would you do? That is exactly the problem today. And it is not just a story — engines, materials, and many real systems are exactly like this. Testing is expensive, and you get few chances. So the real question is: how do we spend a small budget in the smartest way?

## What to Talk About

**notes**

Before I go into details, here is the whole story in three sentences.

First, the problem: precise experiments are expensive, and cheap experiments are not very accurate. Our budget is small.

Second, the idea: combine the two. Use cheap ones to explore the space, then use precise ones to confirm the answer.

Third, the conclusion: with the same budget, a few precise tests plus many cheap tests beats using only precise tests.

That is the plan. Now, step by step. And do not worry — I will not use many formulas, and I will explain each one in plain words.

## Background 1: Black-Box and Budget

**notes**

Why is this hard? Two reasons.

First, the black box. A black box means you only see input and output, never what is inside. It is like a locked machine — you put in a coin and see the result, but you cannot open it. Our function is exactly that. We do not know its shape; we can only test it.

Second, the budget. We can only run the precise experiment fifteen times, but the parameter space is huge. With so many parameters and so few chances, guessing is hopeless. So the starting point is: use fifteen chances to find the best point of a high-dimensional black box.

## Background 2: Two Channels

**notes**

The good news: our black box has two channels.

One is cheap and fast. We can run it many times, but it has bias — not fully accurate.

The other is expensive but accurate. We can only afford it fifteen times.

The key is how to combine them. My idea is simple: high fidelity equals low fidelity plus a bias. That is equation (1).

In plain words: the cheap test draws the rough shape, and the bias says where that rough shape is wrong. We use a statistical model to guess the bias. This is what multi-fidelity means — use the quantity of cheap tests to make up for the accuracy of the expensive ones.

## Figure: V. Roshan Joseph

**notes**

To be honest, I did not invent these methods. Almost the whole skeleton comes from one person — V. Roshan Joseph, a big name in experimental design. Let me show his picture.

He gave us three pieces, and they are exactly the three parts of my pipeline.

First, maximum projection design — how to choose the best starting points, so we waste none.

Second, sequential design — how to add experiments one by one, flexibly.

Third, KOH fusion — how to combine the cheap evaluations with the expensive ones.

So almost every step today comes from his work. I show his picture so you remember: behind these clever methods are real people with names and stories.

## Main Tools: Maxpro Design and Gaussian Process

**notes**

A bit more on the first tool. At the start we know nothing about the function, so the first points should cover the space evenly — not piled in one corner, not overlapping.

Maximum projection design chooses points like that. It keeps them spread out, both in the whole space and in every low-dimensional projection. The criterion is equation (2).

Do not memorize it. Just remember: keep the points spread out. The denominator stops two points from getting too close.

Next, we need a stand-in model to guess the black box. That stand-in is a Gaussian process. Think of it as a normal distribution on an infinite-dimensional space. A normal distribution gives one number; a Gaussian process gives a whole function, and also tells you how unsure it is at every point. That matters, because we need to know where to test next.

## The Whole Process

**notes**

Now the whole pipeline, in four steps.

One, choose the starting points, spread out evenly.

Two, feed the model with cheap points. Many cheap tests go into the Gaussian process, so it draws a rough map of the land.

Three, the precise test. The model says where the valley bottom probably is. We go there and run one expensive, accurate test.

Four, repeat. Each round the map improves, and we get closer to the best point.

One sentence: first use cheap tests to map the area, then use expensive tests to confirm the valley.

## Why Cheap Helps the Expensive

**notes**

Some may ask: cheap tests are inaccurate, so how do they help?

An analogy. Cheap tests are like a drone scanning the land from far away — rough, but we can cover the whole area. The precise test is like walking into the valley to check the real bottom.

The cheap test does not need to be accurate. It just tells us where to spend the precise tests. That is what fusion gives us — every precise measurement becomes more valuable.

## How We Tested

**notes**

Talk is cheap, so we tested it.

We picked test functions in one, two, four, and eight dimensions — difficulty from easy to crazy. For each, we built a cheap version, then ran the same pipeline and watched how it behaves as dimension grows.

Do not read the details of the figures. Just watch the trend.

## Our Question

**notes**

Here is our question. Our task is in equation (4): find the point that makes the expensive function as small as possible, using only fifteen precise tests.

I will answer three smaller questions. Is combination useful? Is screening useful? Does it still work in high dimensions?

## Our Answer 1: Combination Is the Key

**notes**

First conclusion: combination is the key. With the same budget, a few precise tests plus many cheap tests beats only precise tests.

Low dimensions are very clear. In one dimension, only precise tests cannot find the best point — it stays at zero. Add the cheap tests and fusion, and it jumps to the global optimum. In two dimensions, it gets very close to the standard answer, the Branin optimum.

Why? The cheap tests draw the map first, then precise tests confirm the valley. No money wasted.

We also did a small calibration first, tuning how to split the budget. In low dimension, two precise tests are enough; in high dimension, we almost need all of it. That already shows: higher dimension, harder problem.

## Our Answer 2, 3: Screening Is Useless and High Dimensions Fail

**notes**

We also did an ablation — remove one component at a time, to see which part really helps.

Two findings. First, screening is useless, it even hurts. Screening ranks parameters using cheap tests, but the cheap tests have bias, so the ranking is unreliable. Without it, results are better.

Second, in eight dimensions, fusion also fails — the curse of dimensionality. Five precise points cannot draw the shape of an eight-dimensional land.

So: fusion is the decisive part, but it has a ceiling.

## Global Picture

**notes**

Put all results in one figure and the picture is clear. The complete pipeline is best in low dimensions. Remove the combination, and it breaks even in low dimensions. In high dimensions, nothing works.

So it all comes down to one sentence: multi-fidelity is not about spending more money on precise tests — it is about making each precise test more valuable. And its boundary is set by the curse of dimensionality.

## Future Directions

**notes**

Three directions next.

First, when is screening trustworthy? It fails because of bias. So the question is: under what conditions does the cheap-test ranking still match the real ranking? If we know that, we can check first and only screen when it is safe.

Second, how to break the curse of dimensionality? It already fails in eight dimensions. Maybe put some structure on the bias, or reduce the dimension first.

Third, push it into the real world — engines, materials, biology, where experiments really cost money. Maybe even a tool: tell it your budget, and it gives you the best plan by itself.

## Summary

**notes**

Let me finish with one sentence. Multi-fidelity does not ask you to spend more money on precise tests. It makes each precise test more valuable. Its limit is controlled by high dimensions.

That is all. Thank you for listening!
