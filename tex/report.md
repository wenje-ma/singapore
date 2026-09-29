# Bayesian Optimization on Multi-Fidelity Data

## Title Page

Title: Bayesian Optimization on Multi-Fidelity Data — Making every precise measurement more valuable

Author: Wenje Ma

Institution: Beijing Institute of Technology

*notes*

Hello everyone, I am Wenje Ma. Today I want to share my recent work. It is about one question: when our budget for experiments is small, how do we make each experiment more valuable?

## Begin: A Story

- Tune many interacting parameters — more than ten
- Only about fifteen expensive experiments allowed
- Real in engines, materials, ...
- Question: spend a tiny budget in the smartest way?

*notes*

Let me start with a story. Imagine you work for a company, and your job is to tune some parameters. You have an experiment, but it is very expensive — every run costs a lot, and you can only afford fifteen runs in total.

The hard part: there are more than ten parameters, and they affect each other. Change one, and the others may change too. So you cannot try them one by one. You need the best combination of all of them, but you have only fifteen chances.

What would you do? That is exactly the problem today. And it is not just a story — engines, materials, and many real systems are exactly like this. Testing is expensive, and you get few chances. So the real question is: how do we spend a small budget in the smartest way?

## Background 1: Black-Box and Budget

- Black box: you see input and output, never the inside
- Budget: only fifteen precise runs, but a huge space
- Task: find the best point of a high-dimensional black box

*notes*

Why is this hard? Two reasons.

First, the black box. A black box means you only see input and output, never what is inside. It is like a locked machine — you put in a coin and see the result, but you cannot open it. Our function is exactly that. We do not know its shape; we can only test it.

Second, the budget. We can only run the precise experiment fifteen times, but the parameter space is huge. With so many parameters and so few chances, guessing is hopeless. So the starting point is: use fifteen chances to find the best point of a high-dimensional black box.

## Background 2: Two Channels

$$
h_k\left(\boldsymbol{x}\right)=h_{k-1}\left(\boldsymbol{x}\right)+\delta_k\left(\boldsymbol{x}\right)
\tag{1}
$$

- Cheap channel: run many times, but biased
- Expensive channel: only ~15 runs, accurate
- Idea: combine them — high = low + bias

*notes*

The good news: our black box has two channels.

One is cheap and fast. We can run it many times, but it has bias — not fully accurate.

The other is expensive but accurate. We can only afford it fifteen times.

The key is how to combine them. My idea is simple: high fidelity equals low fidelity plus a bias. That is equation (1).

## Figure: V. Roshan Joseph

> Fig 1: Roshan Vengazhiyil Joseph is A. Russell Chandler III Chair and Professor in the Stewart School of Industrial & Systems Engineering at Georgia Tech.

![1.jpg](../figures/1.jpg){width=50%}

- One source: V. R. Joseph, Georgia Tech
- Maxpro design — where to start
- Sequential design — add points one by one
- KOH fusion — join cheap and expensive data

*notes*

Almost the whole skeleton comes from one person — V. Roshan Joseph, a big name in experimental design. Let me show his picture.

He gave us three pieces, and they are exactly the three parts of my pipeline.

First, maxpro design — how to choose the best starting points, so we waste none.

Second, sequential design — how to add experiments one by one, flexibly.

Third, KOH fusion — how to combine the cheap evaluations with the expensive ones.

## Main Tools: Maxpro Design and Gaussian Process

$$
\min_D\sum_{i=1}^{n}\prod_{j\neq i}\frac{1}{\sum_{k=1}^p\left(x_{ik}-x_{jk}\right)^2}\tag{2}
$$

> Fig 2: The maxpro design.

![2.svg](../figures/2.svg){width=50%}

- Start evenly: spread in every projection (Fig. 2)
- Surrogate: Gaussian process = a normal distribution over functions
- It predicts a value, AND an uncertainty, at every point

*notes*

At the start we know nothing about the function, so the first points should cover the space evenly — not piled in one corner, not overlapping.

Maxpro design chooses points like that. It keeps them spread out, both in the whole space and in every low-dimensional projection. The criterion is equation (2), and the effect is shown in Figure 2.

Next, we need a stand-in model to guess the black box. That stand-in is a Gaussian process. Think of it as a normal distribution on an infinite-dimensional space. A normal distribution gives one number; a Gaussian process gives a whole function, and also tells you how unsure it is at every point. That matters, because we need to know where to test next.

## The Whole Process

1. Spread out the starting points
2. Feed in many cheap runs → a rough map
3. Send one expensive run to the predicted valley
4. Repeat — the map gets sharper every round

*notes*

Now the whole pipeline, in four steps.

One, choose the starting points, spread out evenly.

Two, feed the model with cheap points. Many cheap tests go into the Gaussian process, so it draws a rough map of the land.

Three, the precise test. The model says where the valley bottom probably is. We go there and run one expensive, accurate test.

Four, repeat. Each round the map improves, and we get closer to the best point.

## Our Question

$$
\widehat{\boldsymbol{x}}\approx\argmin_{\boldsymbol{x}\in\left[0,1\right]^{p}}h_\mathrm{H}\left(\boldsymbol{x}\right)\tag{3}
$$

- Goal: minimize the expensive function, with only 15 precise runs
- Three small questions:
  - Does combining the two channels help?
  - Does screening the parameters help?
  - Does it still work in high dimensions?

*notes*

Here is our question. Our task is in equation (3): find the point that makes the expensive function as small as possible, using only fifteen precise tests.

I will answer three smaller questions. Is combination useful? Is screening useful? Does it still work in high dimensions?

## Our Answer 1: Combination Is the Key

> Fig 3: Combination Is the Key.

![3.svg](../figures/3.svg){width=50%}

- Metric: median of the best found, over 20 repeats
- Cheap + precise beats precise alone (Fig. 3)
- 1-D: precise alone stuck at 0; with fusion → global optimum
- 2-D: lands right next to the known answer

*notes*

Our evaluation metric is to compare the median of the minimum values obtained from 20 experimental optimizations. As the figure 3 shows that:

Combination is the key. With the same budget, a few precise tests plus many cheap tests beats only precise tests.

Low dimensions are very clear. In one dimension, only precise tests cannot find the best point — it stays at zero. Add the cheap tests and fusion, and it jumps to the global optimum. In two and four dimensions, it gets very close to the standard answer.

## Our Answer 2: Screening Is Useless

> Fig 4: Screening Is Useless.

![4.svg](../figures/4.svg){width=50%}

- Screening ranks parameters by cheap runs
- But cheap runs are biased → the ranking is unreliable
- Result: removing screening actually helps (Fig. 4)

*notes*

As the figure 4 shows that:

Screening is useless, it even hurts. Screening ranks parameters using cheap tests, but the cheap tests have bias, so the ranking is unreliable. Without it, results are better.

## Our Answer 3: High Dimensions Fail

> Fig 5: High Dimensions Fail.

![5.svg](../figures/5.svg){width=50%}

- In 8-D, fusion collapses too
- Too few precise points to sketch an 8-D landscape
- Fusion is decisive — but it has a ceiling

*notes*

As the figure 5 shows that:

In eight dimensions, fusion also fails — the curse of dimensionality. Few precise points cannot draw the shape of an eight-dimensional land.

So: fusion is the decisive part, but it has a ceiling.

## Global Picture

> Fig 6: All results.

![6.svg](../figures/6.svg){width=100%}

- Low dims: full pipeline wins; drop fusion → breaks
- High dims: nothing works
- One line: make every precise test count; limit = dimensionality

*notes*

Put all results in one figure and the picture is clear. As the figure 6 shows that:

The complete pipeline is best in low dimensions. Remove the combination, and it breaks even in low dimensions. In high dimensions, nothing works.

So it all comes down to one sentence: multi-fidelity is not about spending more money on precise tests — it is about making each precise test more valuable. And its boundary is set by the curse of dimensionality.

## Future Directions

1. When is screening trustworthy? (find the bias conditions)
2. Tame high dimensions? (add structure, or reduce dimension first)
3. Real-world tool: give it a budget — get the best plan

*notes*

Three directions next.

First, when is screening trustworthy? It fails because of bias. So the question is: under what conditions does the cheap-test ranking still match the real ranking? If we know that, we can check first and only screen when it is safe.

Second, how to break the curse of dimensionality? It already fails in eight dimensions. Maybe put some structure on the bias, or reduce the dimension first.

Third, push it into the real world — engines, materials, biology, where experiments really cost money. Maybe even a tool: tell it your budget, and it gives you the best plan by itself.

## Summary

- Not "more precise runs" — but "more value per run"
- Limit: the curse of high dimensions

*notes*

Let me finish with one sentence. Multi-fidelity does not ask you to spend more money on precise tests. It makes each precise test more valuable. Its limit is controlled by high dimensions.

## Thanks

- Thank you — questions welcome

*notes*

That is all. Thank you for listening!

