# How to contribute connectors

The `data-extraction-service` repository is a free and open project, and we love to receive contributions from our community — you!
There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests or writing code which can be incorporated into `data-extraction-service` itself.

If you want to be rewarded for your contributions, sign up for the [Elastic Contributor Program](https://www.elastic.co/community/contributor).
Each time you make a valid contribution, you’ll earn points that increase your chances of winning prizes and being recognized as a top contributor.

- [Reporting issues](#reporting-issues)
- [Getting help](#getting-help)
- [Types of contribution](#types-of-contribution)
  - [Add new extraction type](#add-new-extraction-type)
  - [Enhancements](#enhancements)
- [Contribution Checklist](#contribution-checklist)
  - [Acceptance criteria](#acceptance-criteria)
  - [Adhering to the API contract](#adhering-to-the-api-contract)
  - [Testing](#testing)
- [Pull request etiquette](#pull-request-etiquette)
  - [Why do we use a pull request workflow?](#why-do-we-use-a-pull-request-workflow)
  - [What constitutes a good PR?](#what-constitutes-a-good-pr)
    - [Ensure there is a solid title and summary](#ensure-there-is-a-solid-title-and-summary)
    - [Be explicit about the PR status](#be-explicit-about-the-pr-status)
    - [Keep your branch up-to-date](#keep-your-branch-up-to-date)
    - [Keep it small](#keep-it-small)
- [Reviewing Pull Requests](#reviewing-pull-requests)
  - [Keep the flow going](#keep-the-flow-going)
  - [We are all reviewers](#we-are-all-reviewers)
  - [Don't add to the PR as a reviewer](#dont-add-to-the-pr-as-a-reviewer)

## Reporting issues

If something is not working as expected, please open an [issue](https://github.com/elastic/data-extraction-service/issues/new).

## Getting help

The Ingestion team at Elastic maintains this repository and is happy to help.
Try posting your question to the [Elastic discuss forums](https://discuss.elastic.co/c/search/84).
Be sure to mention that you're using the Elastic Extraction Service and also let us know what service type you're trying to use, and any errors/issues you are encountering.
You can also find us in the `#search-enterprise` channel of the [Elastic Community Slack](http://elasticstack.slack.com).

## Types of contribution

### Add new extraction type

👩🏻‍🤝‍👨🏿 Before investing time in developing a new type, [create an issue](https://github.com/elastic/data-extraction-service/issues/new/choose) and reach out to our team for initial feedback on the Extraction Service and the libraries it uses!

### Enhancements

Enhancements that can be done after your initial contribution:

1. Ensure the backend meets performance requirements we might request (memory usage, how fast it can process 10k docs, etc.)
2. Update the README
3. Small functional improvements

> ℹ️ Use-case specific customizations (as opposed to generic enhancements) will not be accepted as contributions.

## Contribution Checklist

### Acceptance criteria

To make sure we're building a great Extraction Service, we will be pretty strict on this checklist, and we will not allow changes

If you need changes in the API contract, or you are not sure about how to do something, reach out to the [Ingestion team](https://github.com/orgs/elastic/teams/search-extract-and-transform/members) and/or file an issue.


### Adhering to the API contract
The Extraction Service is an API wrapper that points a request towards a specific form of content extraction. Our intent is for the entrypoint of this API to be identical for all requests, even if the intended extraction tool is different.

Currently we only support one extraction source (Tika), so we don't have any logic. If another source is added, we require the API endpoint to be the same. Differentiating the sources should be done using parameters.

An example of how this can be done:

```
# Tika extraction
$ curl -X PUT http://localhost:8090/extract_text/?service=tika \
  -T /path/to/file.name

# Foo extraction (fictional)
$ curl -X PUT http://localhost:8090/extract_text/?service=foo \
  -T /path/to/file.name
```


### Testing

Tests not only verify and demonstrate that a new feature does what it is supposed to, but they also protect the codebase from unintentional future regressions.
For this reason, it is important to both add tests when contributing new code, and to ensure that all tests (old and new) are passing.

You can run the tests locally with `make e2e`.


## Pull Request Etiquette

*this is copied and adapted from https://gist.github.com/mikepea/863f63d6e37281e329f8*

### Why do we use a Pull Request workflow?

PRs are a great way of sharing information, and can help us be aware of the
changes that are occurring in our codebase. They are also an excellent way of
getting peer review on the work that we do, without the cost of working in
direct pairs.

**Ultimately though, the primary reason we use PRs is to encourage quality in
the commits that are made to our code repositories**

Done well, the commits (and their attached messages) contained within tell a
story to people examining the code at a later date. If we are not careful to
ensure the quality of these commits, we silently lose this ability.

**Poor quality code can be refactored. A terrible commit lasts forever.**


### What constitutes a good PR?

A good quality PR will have the following characteristics:

* It will be a complete piece of work that adds value in some way.
* It will have a title that reflects the work within, and a summary that helps to understand the context of the change.
* There will be well written commit messages, with well crafted commits that tell the story of the development of this work.
* Ideally it will be small and easy to understand. Single commit PRs are usually easy to submit, review, and merge.
* The code contained within will meet the best practises set by the team wherever possible.

A PR does not end at submission though. A code change is not made until it is merged and used in production.

A good PR should be able to flow through a peer review system easily and quickly.

#### Ensure there is a solid title and summary

PRs are a Github workflow tool, so it's important to understand that the PR
title, summary and eventual discussion are not as trackable as the the commit
history. If we ever move away from Github, we'll likely lose this information.

That said however, they are a very useful aid in ensuring that PRs are handled
quickly and effectively.

Ensure that your PR title is scannable. People will read through the list of
PRs attached to a repo, and must be able to distinguish between them based on
title. Include a story/issue reference if possible, so the reviewer can get any
extra context. Include a reference to the subsystem affected, if this is a
large codebase.


#### Be explicit about the PR status

If your PR is not fully ready yet for reviews, convert it to a `draft` so people
don't waste time reviewing unfinished code, and don't assign anyone as a reviewer.

Use the proper labels to help people understand your intention with the PR and 
its scope.


#### Keep your branch up-to-date

Unless there is a good reason not to rebase - typically because more than one
person has been working on the branch - it is often a good idea to rebase your
branch with the latest `main` to make reviews easier.

#### Keep it small

Try to only fix one issue or add one feature within the pull request. The
larger it is, the more complex it is to review and the more likely it will be
delayed. Remember that reviewing PRs is taking time from someone else's day.

If you must submit a large PR, try to at least make someone else aware of this
fact, and arrange for their time to review and get the PR merged. It's not fair
to the team to dump large pieces of work on their laps without warning.

If you can rebase up a large PR into multiple smaller PRs, then do so.


## Reviewing Pull Requests

It's a reviewers responsibility to ensure:

* Commit history is excellent
* Good changes are propagated quickly
* Code review is performed
* They understand what is being changed, from the perspective of someone examining the code in the future.

### Keep the flow going

Pull Requests are the fundamental unit of how we progress change. If PRs are
getting clogged up in the system, either unreviewed or unmanaged, they are
preventing a piece of work from being completed.

As PRs clog up in the system, merges become more difficult, as other features
and fixes are applied to the same codebase. This in turn slows them down
further, and often completely blocks progress on a given codebase.

There is a balance between flow and ensuring the quality of our PRs. As a
reviewer you should make a call as to whether a code quality issue is
sufficient enough to block the PR whilst the code is improved. Possibly it is
more prudent to simply flag that the code needs rework, and raise an issue.

Any quality issue that will obviously result in a bug should be fixed.

### We are all reviewers

To make sure PRs flow through the system speedily, we must scale the PR review
process. It is not sufficient (or fair!) to expect one or two people to review
all PRs to our code. For starters, it creates a blocker every time those people
are busy.

Hopefully with the above guidelines, we can all start sharing the responsibility of being a reviewer.

NB: With this in mind - if you are the first to comment on a PR, you are that
PRs reviewer. If you feel that you can no longer be responsible for the
subsequent merge or closure of the PR, then flag this up in the PR
conversation, so someone else can take up the role.

There's no reason why multiple people cannot comment on a PR and review it, and
this is to be encouraged.


### Don't add to the PR as a reviewer

It's sometimes tempting to fix a bug in a PR yourself, or to rework a section
to meet coding standards, or just to make a feature better fit your needs.

If you do this, you are no longer the reviewer of the PR. You are a
collaborator, and so should not merge the PR.

It is of course possible to find a new reviewer, but generally change will be
speedier if you require the original submitter to fix the code themselves.
Alternatively, if the original PR is 'good enough', raise the changes you'd
like to see as separate stories/issues, and rework in your own PR.
