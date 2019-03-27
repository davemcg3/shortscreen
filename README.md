# README

## PROMPT: Link Shortener Take Home

So let's make a link shortener. Let's make it with rails. Let's submit
it in a git repo. Let's give it test coverage. Let's use Postgres.

## Features

1. Root should render a form in which you can drop a URL. When you do,
   you'll get redirected to a page with a shortened URL and an admin URL.
2. When you go to a shortened URL, you should be redirected to the
   original URL that was submitted, as long as the URL is active. Also
   count the usage.
3. When you go to the Admin URL, you should be given the ability to
   expire the shortened link and see how many times your link has been used.
   When a link has been expired, render an empty 404.

## Other thoughts

1. Your solution should be scalable but not insanely so. If we handed this
   to our marketing people and they made 1k urls a day each getting hit 20k
   times a day, would it fall over? Will we talk about scaling to
   higher numbers in person?
2. It doesn't have to be pretty. Render HTML on the backend or the
   frontend, whatever is easier for you. This should be a 2-3 hour
   project.
3. If you have a question, ask! (But yes there's some deliberate vagueness here.)
4. Don't just use a link shortener gem. ಠ_ಠ
5. What is a link shortener? You should be able to shorten a long URL like
   `https://www.example.com/really/long/path?with=query_params` to something
   much shorter. Shortened URL would be something like `http://localhost/s/xYz123`. Think [goo.gl](https://goo.gl/) or [TinyUrl](http://tinyurl.com/).
6. Link admin page should be obfuscated. Think [craigslist](https://www.craigslist.org/about/help/free-edit).

## Further Clarification Through Email

1. We want craigslist style pre-authed URLs rather than logins

## Gist

* Here's a link to the gist: https://gist.github.com/mkk-fullscreen/6df5d8f71e7d7aa8dde67ca276d6e711

# Implementation Notes

The interface is ugly. Future work would include building a better front-end in a front-end framework.

The auth is horrendous. I would never release something with auth like this into production. Future work would include a proper user model with JWT-based auth.

The routes are wonky. I would rather this use more standard restful routes, but these are written to conform to the call of the prompt with the weirdness of the admin urls.

A worker is used to offload analytics logging asynchronously. 

301 redirects are used for the full link juice being passed through to the redirected link.

Short codes and admin codes are generated automatically when the short code is saved. When a link is expired it is excluded from the `active` scope, so when someone tries to visit the expired short code they are given a 404.

# Operational Details

* Ruby version: 2.6.2

* Configuration
`bundle install`

* Database creation
`rake db:migrate`

* Run the test suite
`rspec spec/`

* Start the server
`hivemind`
