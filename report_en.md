# Bayesian Optimization Based on Multi-Fidelity Data

## Title Slide

Title: Bayesian Optimization Based on Multi-Fidelity Data
Presenter: Wenje Ma
Affiliation: Beijing Institute of Technology · Mathematics and Applied Mathematics (Qiangji Program) · 2024
Advisor: Dianpeng Wang

**Script**

Hello everyone, I am Wenje Ma. The title of my talk is "Bayesian Optimization Based on Multi-Fidelity Data."

---

## Formal Problem Statement

### Formal Problem Statement

The design parameters are $\boldsymbol{x}\in\left[0,1\right]^{p}$, and the simulator is a black box $y=h\left(\boldsymbol{x}\right)$. There are two evaluation channels with different costs and accuracies:

- Low-fidelity $h_\mathrm{L}\left(\boldsymbol{x}\right)$: cost $c_\mathrm{L}$, with systematic bias;
- High-fidelity $h_\mathrm{H}\left(\boldsymbol{x}\right)$: cost $c_\mathrm{H}\gg c_\mathrm{L}$, accurate.

There is a bias structure between the two fidelities, whose form is unknown. The total budget is 15 high-fidelity equivalents, and define $\widehat{h}=h_\mathrm{H}\left(\widehat{\boldsymbol{x}}\right)$. Task: estimate as accurately as possible

$$
\widehat{\boldsymbol{x}}\approx\argmin_{\boldsymbol{x}\in\left[0,1\right]^{p}}h_\mathrm{H}\left(\boldsymbol{x}\right)
$$

**Script**

Let us first look at the formal problem statement. The design parameters bold x live in the p-dimensional unit interval, and the simulator is a black box y equals h bold x. Two evaluation channels are available: the low-fidelity h L bold x is cheap, cost c L, but has a systematic bias; the high-fidelity h H bold x is expensive, cost c H much greater than c L, and is accurate. The bias structure between the two fidelities is unknown. The total budget is 15 high-fidelity equivalents. Define hat bold x as the algorithm's best estimate; hat h equals h H bold x, the high-fidelity value measured there. Our goal: estimate as accurately as possible the bold x minimizing h H bold x.

---

## Theoretical Foundations

### Maximum Projection Design

Maximin Latin hypercube sampling design (Morris and Mitchell, 1995):

> **Figure 1**: Maximin Latin hypercube sampling design

![Alt Text](figures/1.svg){width=33%}

Maximum projection design (Joseph et al., 2015): Let $D=\left\{\boldsymbol{x}_1,\dots,\boldsymbol{x}_n\right\}$ be a design with $n$ points on $\left[0,1\right]^p$, whose criterion is

$$
\min_D\sum_{i=1}^{n}\prod_{j\neq i}\frac{1}{\sum_{k=1}^p\left(x_{ik}-x_{jk}\right)^2}
\tag{1}
$$

> **Figure 2**: Maximum projection design

![Alt Text](figures/2.svg){width=33%}

**Script**

Let us lay the theoretical foundation. We estimate bold x through Bayes' formula, with a prior and a posterior. At the prior stage we know nothing about the function, so the initial points must cover the space as uniformly as possible. To ensure that in every one-dimensional projection all coordinates are distinct, Morris and Mitchell proposed the maximin Latin hypercube sampling design in 1995; as Figure 1 shows, it covers the space uniformly. However, it projects poorly in high dimensions. Joseph et al. therefore proposed the maximum projection design in 2015: for a design bold x 1 to bold x n on the p-dimensional unit interval, the criterion is (1). Since the denominator cannot be zero, distinct coordinates are guaranteed automatically, satisfying the maximin constraint. As Figure 2 shows, its low-dimensional projections are also uniform. We therefore adopt maximum projection for choosing the initial points.

---

### Maximum One-Factor-at-a-Time Design with Projection

Estimator of the total Sobol' index $V_i^\mathrm{tot}$ (Jansen, 1999):

$$
\widehat{V_i^{\text{tot}}}=\frac{1}{2m}\left\|h\left(\boldsymbol{A}\right)-h\left(\boldsymbol{A}^{\left(\boldsymbol{B}_i\right)}\right)\right\|^2
\tag{2}
$$

where $\boldsymbol{A}^{\left(\boldsymbol{B}_i\right)}$ is the matrix obtained by replacing the $i$-th column of the $m\times p$ matrix $\boldsymbol{A}$ with the $i$-th column of $\boldsymbol{B}$, $\left\|\cdot\right\|$ is the Euclidean norm, and $h\left(\boldsymbol{x}\right)$ is an arbitrary function to be tested.

Expectation of the total Sobol' index $V_i^\mathrm{tot}$:

$$
\mathrm{E}\left(\widehat{V_i^{\mathrm{tot}}}\right)=\frac{\tau^{2}\sqrt{w_{i}}}{2m}\sum_{j=1}^{m}\left|\boldsymbol{A}_{ji}-\boldsymbol{A}_{ji}^{\left(i\right)}\right|
\tag{3}
$$

Criterion for maximizing the total Sobol' index $V_i^\mathrm{tot}$:

$$
\argmax_{\boldsymbol{A}}\sum_{j=1}^{m}\left|\boldsymbol{A}_{ji}-\boldsymbol{A}_{ji}^{\left(i\right)}\right|
\tag{4}
$$

Projection mapping:

$$
x_i\leftarrow\begin{cases}x_i-\frac{0.25}{m},&x_i<0.5\\
x_i+\frac{0.25}{m},&x_i\ge0.5\\
x_i,&\text{otherwise}\end{cases},\quad
x_i\leftarrow\begin{cases}x_i+\frac{0.25}{m},&x_i<0.5\\
x_i-\frac{0.25}{m},&x_i\ge0.5\\
x_i,&\text{otherwise}\end{cases}
\tag{5}
$$

**Script**

Ranking factors by importance lets us drop the unimportant ones — fewer factors, easier fitting. The importance of factor i is the total Sobol' index V i total, estimated by Jansen in 1999 as in (2). Since the estimator is random, we examine its expectation, giving (3). Because tau times the square root of omega i is constant for fixed i, maximizing (3) reduces to maximizing the L 1 distance, achieved through (4); this is the maximum one-factor-at-a-time design. Inspired by maximum projection, Joseph in 2026 proposed letting bold A and bold B alternately apply the mapping in (5) to improve the projection properties; the two branches in (5) are interchangeable. The result is the maximum one-factor-at-a-time design with projection; Figure 3 compares it with the version without projection — the mapped points no longer duplicate coordinates.

> **Figure 3**: Maximum one-factor-at-a-time design (left) and maximum one-factor-at-a-time design with projection (right)

![Alt Text](figures/3.svg){width=67%}

---

### Sequential Design

Sequential design: let $\mathcal{X}\subset\mathbb{R}^p$ be the design space; first choose $x_1\in\mathcal{X}$, then add $x_2,\dots,x_n$ one by one as follows (Joseph, 2016):

$$
\boldsymbol{x}_{k+1}=\argmin_{\boldsymbol{x}\in\mathcal{X}}\sum_{i=1}^k\frac{1}{\prod_{j=1}^p\left(x_j-x_{ij}\right)^2}
\tag{6}
$$

where $k=1,\dots,n-1$.

**Script**

We do not need to spend the whole high-fidelity budget at once. We can build a small initial design, collect data, and then decide where the next experiments go. This flexible strategy is the sequential design, also called active learning in machine learning; unlike the maximin Latin hypercube design, the maximum projection design supports it naturally. Define calligraphic X as the design space in the p-dimensional space of blackboard bold R. Joseph proposed in 2016 choosing x 1 as the initial point, then adding x 2 to x n one by one via (6), with k from 1 to n minus 1. In fact, (6) is just the maximum projection criterion (1) rewritten iteratively. We will use it for sequential point selection.

---

### Nested Design

Suppose there are $K$ fidelity levels, where "1" denotes the lowest fidelity and "$K$" the highest fidelity, and the corresponding sets of design points are $\left\{D_i\right\}_{i=1}^K$.

Fusion formula (Kennedy and O'Hagan, 2000):

$$
h_k\left(\boldsymbol{x}\right)=h_{k-1}\left(\boldsymbol{x}\right)+\delta_k\left(\boldsymbol{x}\right)
\tag{7}
$$

where $k=2,\dots,K$, and $\delta_k\left(\boldsymbol{x}\right)$ denotes the bias between the outputs of the $(k-1)$-th and the $k$-th fidelity levels. We make the following Gaussian process assumptions:

$$
\begin{aligned}
&\delta_k\left(\boldsymbol{x}\right)\sim\mathcal{GP}\left\{0,\tau_k^2R_k\left(\cdot\right)\right\}\\
&h_\mathrm{L}\left(\boldsymbol{x}\right)\sim\mathcal{GP}\left\{\mu,\tau_\mathrm{L}^2R_\mathrm{L}\left(\cdot\right)\right\}
\end{aligned}
\tag{8}
$$

> **Definition** (Gaussian process): If for arbitrarily chosen $\boldsymbol{x}_1,\dots,\boldsymbol{x}_n$ and any integer $n\ge1$, the vector $\boldsymbol{Y}=\left\{Y\left(\boldsymbol{x}_1\right),\dots,Y\left(\boldsymbol{x}_n\right)\right\}'$ follows a multivariate normal distribution, then the random function $Y\left(\boldsymbol{x}\right)$ is called a Gaussian process.

Nested design (Kennedy and O'Hagan, 2000): $D_1\supset D_2\supset\dots\supset D_K$.

Sequential maximum-entropy design problem:

$$
\begin{aligned}D_1^*&=\argmax_{D_1}\left|\boldsymbol{R}_1\left(D_1,D_1\right)\right|\\
D_2^*&=\argmax_{D_2\subseteq D_1^*}\left|\boldsymbol{R}_2\left(D_2,D_2\right)\right|\end{aligned}
\tag{9}
$$

where $\left|\cdot\right|$ is the determinant, and $\boldsymbol{R}_k\left(D,D'\right)$ is the correlation matrix of the $k$-th fidelity level whose $\left(i,j\right)$ element is $R_k\left(\boldsymbol{a}_i-\boldsymbol{b}_j\right)$. The optimal sample point to remove from $D_1$ is (Joseph, 2026):

$$
x^*_k=\argmax_{x_k\in D_1}\sum_{j\neq k}\frac{1}{\prod_{l=1}^{p}\left\{\left|x_{kl}-x_{jl}\right|+\beta_{l}\right\}^{2}}
\tag{10}
$$

> **Figure 4**: Nested design with two fidelity levels

![Alt Text](figures/4.svg){width=33%}

**Script**

Suppose there are K fidelity levels, 1 the lowest and K the highest, with design sets D i, i from 1 to K. Kennedy and O'Hagan fused the data as in (7), assuming Gaussian processes as in (8). Recall: a Gaussian process is a random function whose values at any finite set of points follow a multivariate normal distribution — a generalization of the multivariate normal to arbitrary dimensions. They also proposed a nested design: D 1 contains D 2, and so on down to D K. Consider the two maximum-entropy design problems in (9). Entropy, defined by Shannon in 1948, measures uncertainty; experimental design seeks larger entropy, i.e., more information — exactly what maximum projection maximizes, making it ideal for D 1 star and D 2 star. Joseph in 2026 noted that the nested design is built by successively removing points from D 1 star to form D 2 star, with the removal criterion in (10). Unlike (6), the denominator adds a positive constant beta l, because D 2 takes discrete values from the continuous D 1: two points coincide with probability zero in a continuous space, but not in a discrete one, so the constant prevents a zero denominator. Figure 4 shows the nested design with two fidelity levels: the triangular D 2 points are discrete points chosen from the circular D 1 points, both following maximum projection.

### Expected Improvement Method

Optimization objective of the black-box function:

$$
\min_{\boldsymbol{x}\in\left[0,1\right]^p}h\left(\boldsymbol{x}\right)
\tag{11}
$$

Iterative formula for finding the next design point:

$$
\boldsymbol{x}_{n+1}=\argmin_{\boldsymbol{x}}\widehat{h_n}\left(\boldsymbol{x}\right)
\tag{12}
$$

This procedure is repeated until convergence. Since the Gaussian process adopts a Bayesian framework, such problems are called Bayesian optimization methods.

Expected improvement method (Jones et al., 1998): Let the experimental design be $D_n=\left\{\boldsymbol{x}_1,\dots,\boldsymbol{x}_n\right\}$, with observed data $\boldsymbol{y}_n=\left(y_1,\dots,y_n\right)'$. Place a Gaussian process prior on the unknown function:

$$
h\left(\boldsymbol{x}\right)\sim\mathcal{GP}\left\{\mu,\tau^2R\left(\cdot\right)\right\}
\tag{13}
$$

where $\mu$ is the constant mean, $\tau^2$ the variance, and $R\left(\cdot\right)$ the correlation function. Let $\boldsymbol{R}_n$ be the $n\times n$ correlation matrix whose $\left(i,j\right)$ element is $R\left(\boldsymbol{x}_i-\boldsymbol{x}_j\right)$, $\boldsymbol{r}_n\left(\boldsymbol{x}\right)$ the correlation vector whose $i$-th element is $R\left(\boldsymbol{x}-\boldsymbol{x}_i\right)$, and $\boldsymbol{1}_n$ the $n$-dimensional column vector of all ones.

Its posterior distribution (Joseph, 2026, Lemma 2.2):

$$
h\left(\boldsymbol{x}\right)\mid D_n,\boldsymbol{y}_n\sim\mathcal{N}\left\{\mu+\boldsymbol{r}_n\left(\boldsymbol{x}\right)'\boldsymbol{R}_n^{-1}\left(\boldsymbol{y}_n-\mu\boldsymbol{1}_n\right),\tau^2\left(1-\boldsymbol{r}_n\left\{\boldsymbol{x}\right\}'\boldsymbol{R}_n^{-1}\boldsymbol{r}_n\left\{\boldsymbol{x}\right\}\right)\right\}
\tag{14}
$$

Let $h_{\mathrm{min}}^{\left(n\right)}=\min \boldsymbol{y}_n$ and define the improvement function:

$$
I\left(\boldsymbol{x}\right)=\max\left\{h_{\mathrm{min}}^{\left(n\right)}-h\left(\boldsymbol{x}\right),0\right\}
\tag{15}
$$

Thus, if the chosen $x$ satisfies $h\left(\boldsymbol{x}\right)<h_{\mathrm{min}}^{\left(n\right)}$, an improvement is obtained; otherwise there is no improvement.

Iterative formula for expected improvement:

$$
\boldsymbol{x}_{n+1}=\argmax_{\boldsymbol{x}}\mathrm{E}\left\{I\left(\boldsymbol{x}\right)\mid D_n,\boldsymbol{y}_n\right\}
\tag{16}
$$

Explicit expression of expected improvement (Jones et al., 1998):

$$
\boldsymbol{x}_{n+1}=\argmax_{\boldsymbol{x}}\left\{s_n\left(\boldsymbol{x}\right)\left[u_n\left\{\boldsymbol{x}\right\}\Phi\left(u_n\left\{\boldsymbol{x}\right\}\right)+\phi\left(u_n\left\{\boldsymbol{x}\right\}\right)\right]\right\}
\tag{17}
$$

where $\phi\left(\cdot\right)$ and $\Phi\left(\cdot\right)$ denote the standard normal probability density function and the standard normal cumulative distribution function, respectively; $s_n\left(\boldsymbol{x}\right)$ is the posterior standard deviation, and $u_n\left\{\boldsymbol{x}\right\}=\left\{h_{\mathrm{min}}^{\left(n\right)}-\widehat{h_n}\left(\boldsymbol{x}\right)\right\}/s_n\left(\boldsymbol{x}\right)$.

Derivatives of the explicit expression:

$$
\frac{\partial\mathrm{EI}}{\partial\widehat{h_n}\left(\boldsymbol{x}\right)}=-\Phi\left\{u_n\left\{\boldsymbol{x}\right\}\right\}<0,\quad\frac{\partial\mathrm{EI}}{\partial s_n\left(\boldsymbol{x}\right)}=\phi\left\{u_n\left\{\boldsymbol{x}\right\}\right\}>0
\tag{18}
$$

where $\mathrm{EI}=s_n\left(\boldsymbol{x}\right)\left[u_n\left\{\boldsymbol{x}\right\}\Phi\left(u_n\left\{\boldsymbol{x}\right\}\right)+\phi\left(u_n\left\{\boldsymbol{x}\right\}\right)\right]$

> **Figure 5**: Two iterations of the expected improvement minimization algorithm on a test function

![Alt Text](figures/5.svg){width=100%}

**Script**

Now to the core optimization problem: minimize the expensive black-box function h bold x over the design space, taken as the p-dimensional unit interval, giving (11) — a nonlinear problem with box constraints. We need a global method using as few evaluations as possible. We select a small design bold x 1 to bold x n, evaluate h bold x i to get y i, and approximate the function by a cheap Gaussian process surrogate hat h n bold x, which approaches the high-fidelity surface sequentially. Minimizing the surrogate yields the next point via (12); iterating until convergence gives Bayesian optimization. The standard choice is expected improvement, proposed by Jones et al. in 1998. Given the design D n and observations bold y n, we place the Gaussian process prior (13). By Lemma 2.2 of Joseph (2026), the posterior is (14). Let h n minimum be the minimum of bold y n and define the improvement I in (15): improvement occurs when h bold x falls below h n minimum. Since I is random, we maximize its expectation, giving the iterative rule (16). Jones et al. derived its explicit form (17), and differentiating yields (18): expected improvement decreases with hat h n bold x and increases with s n bold x, balancing optimization against surrogate accuracy. Figure 5 shows two iterations on a test function, gradually locating its minimum and second minimum.

---

### Test Functions

One-dimensional test function (Joseph, 2026):

$$
h\left(x\right)=\frac{\sin\left(10\pi x\right)}{1+64\left(x-0.25\right)^2}+x^2
\tag{19}
$$

where $x\in\left[0,1\right]$.

Two-dimensional Branin function (Surjanovic and Bingham, 2013):

$$
f\left(x\right)=\left(x_2-\frac{5.1}{4\pi^2}x_1^2+\frac{5}{\pi}x_1-6\right)^2+10\left(1-\frac{1}{8\pi}\right)\cos x_1+10
\tag{20}
$$

where $x_1\in\left[-5,10\right]$ and $x_2\in\left[0,15\right]$.

Simple additive function (Joseph, 2026):

$$
h\left(x\right)=\sum_{k=1}^{4}\frac{1}{k}\sin\left(\left\{k^2+1\right\}\pi x_k\right)
\tag{21}
$$

where $\boldsymbol{x}\in\left[0,1\right]^4$.

Function simulating borehole water flow (Morris et al., 1993):

$$
y=\frac{2\pi x_3\left(x_4-x_6\right)}{\log\left(\frac{x_2}{x_1}\right)\left\{1+\frac{2x_7x_3}{\log\left(x_2/x_1\right)x_1^2x_8}+\frac{x_3}{x_5}\right\}}
\tag{22}
$$

where $x_1\in\left[0.05,0.15\right]$, $x_2\in\left[100,50000\right]$, $x_3\in\left[63070,115600\right]$, $x_4\in\left[990,1110\right]$, $x_5\in\left[63.1,116\right]$, $x_6\in\left[700,820\right]$, $x_7\in\left[1120,1680\right]$, $x_8\in\left[9855,12045\right]$.

**Script**

We now pick test functions of 1, 2, 4, and 8 dimensions to compare the pipeline across dimensions. These are: the one-dimensional test function of Joseph (2026), in (19); the Branin function of Surjanovic and Bingham (2013), in (20); a four-factor additive function of Joseph (2026), in (21); and the borehole water flow function of Morris et al. (1993), in (22).

---

### Multi-Fidelity

General formula for constructing multi-fidelity functions:

$$
f_\mathrm{L}\left(\boldsymbol{x}\right)=f_\mathrm{H}\left(\boldsymbol{x}\right)+\frac cp\cdot\sum_{i=1}^p\left(x_i-\frac12\right)
\tag{23}
$$

Low-fidelity versions of the four test functions:

$$
\begin{align*}
f_\mathrm{L}\left(x\right)&=f_\mathrm{H}\left(x\right)+0.3\left(x-\frac{1}{2}\right)
\tag{24}\\
f_\mathrm{L}\left(\boldsymbol{u}\right)&=f_\mathrm{H}\left(\boldsymbol{u}\right)+40\cdot\frac{u_1+u_2-1}{2}
\tag{25}\\
f_\mathrm{L}\left(\boldsymbol{x}\right)&=f_\mathrm{H}\left(\boldsymbol{x}\right)+0.5\cdot\frac{\sum_{k=1}^{4}\left(x_k-\frac{1}{2}\right)}{4}
\tag{26}\\
f_\mathrm{L}\left(\boldsymbol{u}\right)&=f_\mathrm{H}\left(\boldsymbol{u}\right)+70\cdot\frac{\sum_{i=1}^{8}\left(u_i-\frac{1}{2}\right)}{8}
\tag{27}\\
\end{align*}
$$

**Script**

For each test function we construct a low-fidelity version. Inspired by Song et al. (2024), I use the general form (23): the high-fidelity function plus a constant c times the average shift from 0.5, with c set to 10 to 15 percent of the range of f H. The resulting low-fidelity versions are given in (24) to (27).

---

## Complete Pipeline

Complete pipeline M1:

$$
\boxed{\text{Maximum projection design}}\to\boxed{\text{Sequential design}}\to\boxed{\text{Nested design}}\to\boxed{\text{Expected improvement}}
\tag{28}
$$

Blank control group M0:

$$
\boxed{\text{Maximum projection design}}\to\boxed{\text{Expected improvement}}
\tag{29}
$$

Removing only the nested design S1:

$$
\boxed{\text{Maximum projection design}}\to\boxed{\text{Sequential design}}\to\boxed{\text{Expected improvement}}
\tag{30}
$$

Removing only the sequential design S2:

$$
\boxed{\text{Maximum projection design}}\to\boxed{\text{Nested design}}\to\boxed{\text{Expected improvement}}
\tag{31}
$$

**Script**

Now the experiments. The complete pipeline is M1 in (28); the blank control M0 in (29) drops both the sequential and nested designs. To attribute each component's contribution, we also build S1, removing only the nested design (30), and S2, removing only the sequential design (31).

### Calibration Experiment

> **Output 1**: Optimal number of high-fidelity evaluations for each dimension

```
n2* by dimension: d1=2    d2=14    d4=14    d8=14 
```

Following the M1 workflow, the room for the sequential and fusion components is squeezed out almost entirely by the budget.

**Script**

The calibration experiment fixes the budget split. We sweep the initial number of high-fidelity evaluations from 2 to 15; the value 1 is unsolvable, since a single point cannot fit a Gaussian process. For each setting we run M1 twenty times, record f star once the budget is exhausted, and take the median as the metric, choosing the n star with the smallest median. Output 1 shows the optimum: 2 for dimension 1, and 14 for dimensions 2, 4, and 8. Low-dimensional functions are easy to fit; the difficulty explodes in high dimensions. And since the optima for 2, 4, and 8 dimensions sit on the grid endpoint 14, under the tiny budget of 15 high-fidelity equivalents the initial design dominates — the sequential and fusion components have almost no room left.

---

### Ablation Experiment

> **Output 2**: Table of function minima fitted by the four experimental configurations in each of the four dimensions after forcing 5 high-fidelity evaluations

```
   config         d1        d2        d4       d8
       M1 -0.6035453 3.1626952 -1.410891 19.68542
       S2 -0.6035453 0.4041193 -1.606024 12.70143
       S1  0.0000000 5.4693989 -1.187530 17.15853
       M0  0.0000000 0.8787899 -1.297524 10.50205
 M0@n2=14 -0.5776889 2.2567621 -1.448456 12.59210
```

In the 1-dimensional case, the expected improvement method fails.

In the 4-dimensional case, the fusion model uses a large amount of low-fidelity data to correct the approximation of the high-fidelity surface.

The screening component provides no positive contribution in any of the four dimensions: the bias structure between low and high fidelity makes the factor importance ranking unreliable.

The value of fusion decays as the dimension increases: in the 8-dimensional case, the blank control is actually better than the fusion-only configuration, which is a manifestation of the curse of dimensionality within the multi-fidelity framework.

Under the same budget, a few high-fidelity points combined with fusion far outperform running with many high-fidelity points alone.

**Script**

The ablation experiment identifies each component's marginal contribution while controlling the initial design. Using n 2 star directly would leave too few low-fidelity samples, degenerate the pipeline into pure high fidelity, and make the four configurations indistinguishable. So we force exactly 5 high-fidelity evaluations per dimension, repeat twenty times, and obtain Output 2. In dimension 1, the blank control's f star is only 0 — expected improvement fails completely — while adding fusion reaches the global optimum. In dimension 2, the fusion-only S2 attains 0.4041, close to the Branin global optimum 0.3979, more than doubling the blank control's 0.8788. In dimension 4, fusion improves the minimum from -1.2975 to -1.6060. Fusion thus corrects the high-fidelity approximation using abundant low-fidelity data, sharpening point selection; with sparse samples, it even turns sequential optimization from failure into feasibility. Screening, however, never helps: in dimension 2 it worsens the fused result from 0.4041 to 3.1627, because the bias between low and high fidelity makes factor importance rankings unreliable. Fusion's value decays with dimension: qualitative gain in 1 dimension, near-global optimum in 2, moderate gain in 4, while in 8 dimensions the blank control beats fusion alone — five high-fidelity points cannot characterize an eight-dimensional Gaussian process, the curse of dimensionality within the multi-fidelity framework. Finally, combining both experiments: in dimension 2, fusion-only's 0.4041 beats the blank control's 2.2568 under the optimal initial design, with nearly equal budgets. Under the same budget, a few high-fidelity points with fusion far outperform many high-fidelity points alone.

---

## Summary

Under an extremely small budget, the initial design dominates the results; the room for the sequential and fusion components is squeezed out almost entirely by the budget.

Fusion is the decisive component: in low dimensions, it goes from failure to the global optimum; in high dimensions, it is constrained by the curse of dimensionality.

The screening component provides no positive contribution: the bias structure between low and high fidelity makes the factor importance ranking unreliable.

Under the same budget, a few high-fidelity points combined with fusion far outperform running with many high-fidelity points alone.

**Script**

This report assembles the maximum projection design, the maximum one-factor-at-a-time design with projection, the nested design fusion, and expected improvement into the complete pipeline M1, and quantifies each component's contribution through calibration and ablation. Calibration: under the tiny fifteen-equivalent budget, the optimum falls on the grid endpoint, so the initial design dominates and the multi-fidelity components have little room. Ablation: fusion is the decisive component — in 1 dimension it turns failure into feasibility and reaches the global optimum; in 2 dimensions it approaches the Branin optimum 0.3979; its value decays with dimension and fails in 8 dimensions, because the bias field cannot be fitted reliably. Screening never contributes, since estimating factor importance from low-fidelity information is unreliable. Together: under equal budgets, a few high-fidelity points with fusion far outperform many high-fidelity points alone. The takeaway: multi-fidelity fusion does not mean spending more on high fidelity; it makes every high-fidelity evaluation count more, with its boundary set by the curse of dimensionality.

## Future Work

Direction for improvement: Under what bound on the total Sobol' index of the bias field $\delta\left(\boldsymbol{x}\right)$ does the factor importance ranking given by the low-fidelity function preserve the true high-fidelity ranking?

**Script**

The most interesting open question is screening's failure: it never helps, because we rank factors using low-fidelity information, and the bias structure makes that ranking unreliable. We have observed the phenomenon — but under what conditions is the low-fidelity ranking trustworthy? The next step is to derive a criterion for ranking consistency. With it, we could test before screening and skip it whenever the ranking is untrustworthy, avoiding the removal of factors fusion truly needs. This requires new function decompositions and inequalities, beyond the present experiments, and will be pursued as future work.

## Acknowledgement Slide

Thank you for listening!

**Script**

That concludes my talk. Thank you all!
