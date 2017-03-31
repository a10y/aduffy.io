+++
date = "2017-03-08"
title = "Make Your Own Tools"
tags = ["thoughts"]
description = "On making and using tools."
+++

> "_Give me lever long enough and a fulcrum sturdy enough and I will move the world._"
>
> Archimedes describing mechanical advantages

Tools give you leverage, the upfront investment saves you time later on.
Whenever you have a large project, make sure you either find **_OR MAKE_** the
right tools for the job.

Being a student, I've tried my best to apply this to my academic life.  For all of
my implementation-heavy classes, I try and spend ~15-20 minutes writing a
script that that can run my tests and diff my answers against some test cases
(either provided ones or ones that I write myself). This becomes more important
as the project grows larger and the room for error expands rapidly &mdash; especially
for group projects.  I don’t go as far as setting up CI because for two
people, waiting for Circle to finish building and running tests is much slower
than sitting next to
someone and watching them run the tests, but I still make sure that I integrate
testing early on and communicate (either through a README or in person) how my
partner(s) should run the tests, and add new tests.

The best thing about this is that you can measure your progress trivially: if
the tests fail, you have work left to do. If they all pass, then you’re
(probably) done.  Building good tools for testing my own software has been key
for me in all the classes where I’ve done well, as well as in my internships.
The skill of being able to write simple bash/python/whatever scripts that are
capable of performing menial tasks frees your mind up so you can get to work,
and validation is as simple as "did it pass/fail".

Clear your mind, write good tools.
