[![Build Status](https://travis-ci.org/llxff/issue_tracker.svg?branch=master)](https://travis-ci.org/llxff/issue_tracker)

# README

Task https://gist.github.com/kostyadubinin/fc72f88173a1f81bf6d39207dd34a365

Demo https://boiling-atoll-56580.herokuapp.com

Postman requests https://www.getpostman.com/collections/c175cf3d2f67f700eb02

Documentation https://documenter.getpostman.com/view/3158915/issuetracker/77pWKgX

## Additional features

User:
- can edit issue only if it is pending

Moderator:
- can create issues
- can resolve issue only if it is in progress

## Setup

```
$ git clone git@github.com:llxff/issue_tracker.git
$ cd issue_tracker
$ ./bin/setup
== Installing dependencies ==
...

== Preparing database ==
...

== Creating moderator ==

Credentials: moderator@example.com:password

```

In the `setup` output you can find credentials for moderator account.

## Technologies

- Rails 5.1
- SQLite (for easy setup)
- JWT authentication (with `Authorize` header)
