+++
description = "A whirlwind through deep learning, with a slant toward NLP finishing off with some work I did on neural question answering"
draft = true
tags = ["deep learning", "machine learning", "nlp", "question answering"]
date = "2017-03-26T16:38:42-07:00"
title = "An Agent for Neural Question Answering"
categories = ["deep learning", "stanford"]
+++

I've spent most of the past several weeks working on a capstone research project for one of my MS courses. The class is [CS 224N: Deep Learning for NLP](http://web.stanford.edu/class/cs224n/), taught by Richard Socher of [Salesforce Metamind](https://metamind.io) and [Chris Manning](https://nlp.stanford.edu/~manning/) of the Stanford NLP group. Both of the lecturers are at the bleeding-edge of of the field, which is largely shifting away from more traditional models towards the glorious deep neural networks future.

Okay, so it's pretty strange to call the course "Deep Learning for NLP" when in fact a better name would've been "Neural Networks for NLP", as most of the networks we examined and had to implement were shallow, and indeed many of the state-of-the-art models for NLP are shallow as well. Even relatively simple neural models are able to achieve state-of-the-art performance for a variety of tasks. The shift began within this past decade in the field of computer vision, but there has been a huge wave of interest in developing DL techniques for language tasks that has been accelerating over the past few years.

To understand why businesses love this, one only needs to look at the recent buzz around chatbots[^chatbots]. There's been a ridiculous amount of interest in chatbots, and they've drawn a lot of attention (not all of it good though[^geico-bot]). Companies love them because they increase consumer engagement by allowing representatives to respond directly to complaints on social media before the situation can escalate, and in the grand autonomous future many simple customer support tasks can be handled cheaply with AI labor as opposed to filling up call centers with underpaid representatives who spend all day answering the questions like _"Where am I calling?"_ and _"Can I speak to your supervisor?"_.

Not all potential applications for good NLP is in the field of cheap robosupport. One of the killer sexy applications of NLP research is in translation, Google recently publishing some phenomenal results where they are able to learn

## Deep Learning Reality Check

First off, it's useful to remind ourselves why people seem to be losing their sh*t over deep learning. Most of this section will deal with the problem of classification as that is more often than not the primary goal of most machine learning problems in industry and competitions.

 Past industry best-practice for machine learning involved hand-crafted features that were compiled using some level of domain knowledge. These features were then fed into an SVM or softmax classifier that then would learn to perform binary or k-class classification. There are tons of libraries that implement these models[^ml-libs], so much focus was placed on the process of cleaning and featurizing data.

From a cognitive science perspective, these models are relatively boring as they require humans to use some domain-specific knowledge to project out the real data into some mathematical subspace themselves and only then allow the agent to perform linear separation in this dumbed-down space. In effect, the agent is failing to learn directly from the data the way humans do, and so academics stride to find these __end-to-end__ models. In the 1970s, Marvin Minsky and Seymour Papert [laid down the framework](https://mitpress.mit.edu/books/perceptrons) for artificial neural networks. Perceptrons are simple units that have several inputs and via some **activation function**, can combine thise inputs into a single output. These simple units, more often called **neurons**, are useful for a few reasons: a) they are differentiable, and b) through the activation function we are able to learn non-linear decision boundaries between classes. We have good algorithms for training differentiable models[^sgd]


There are a whole host of great resources for learning more about neural networks for deep learning[^nn-resources], but the important fact about this




[^ml-libs]: A few examples that come to mind: [scikit learn](http://scikit-learn.org/stable/index.html), [Vowpal Wabbit](http://hunch.net/~vw/), [libSVM](https://www.csie.ntu.edu.tw/~cjlin/libsvm/), and [Spark MLLib](http://spark.apache.org/docs/latest/ml-guide.html).
[^nn-resources]: Ian Goodfellow's [Deep Learning](http://www.deeplearningbook.org/) is often recommended, though I haven't read it. Andrej Karpathy's [CS 231N lecture notes](http://cs231n.github.io/) are an excellent resource for the theortical background.
[^sgd]: The typical algorithm for training these models is called Gradient Descent, but there are similar algorithms in this family that allow us to converge to the optimal model more quickly: Adam, Adagrad, RMSProp, SGD with momentum, etc.
[^chatbots]: Just off the top of my head: [Slack bots](https://api.slack.com/bot-users) [Messenger bots](https://developers.facebook.com/blog/post/2016/04/12/bots-for-messenger/), [Magic](https://getmagic.com/).
[^geico-bot]: A cringingly hillarious example of chatbots gone bad is [Geico's twitterbot courting racist dudes](https://qz.com/872045/geico-brk-a-accidentally-courted-racist-twitter-trolls-on-state-farms-stfgx-feed-to-sell-insurance/).