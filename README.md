![](https://img.shields.io/badge/Elixir/OTP-purple)
![](https://img.shields.io/badge/Erlang-blue)
# Ashurbanipal

[Ashurbanipal](https://en.wikipedia.org/wiki/Ashurbanipal) is an aggregator API that serves Hacker News' top 50 stories. It is built using Elixir/OTP and without using [Phoenix](https://www.phoenixframework.org/) or a database to store data. It uses ETS to store Hacker News' stories in memory.

It was named after the last great Assyrian king who was fond of collecting clay tablets in his library. He is the reason why we still have the [Epic of Gilgamesh](https://en.wikipedia.org/wiki/Epic_of_Gilgamesh).

## Features

* JSON API over HTTP

## Usage

Clone the repository and run the following commands:

If you're running a Unix-like system:<br/><br/>
`export MIX_ENV=prod` 
<br/><br/>
If you're running Windows:<br/><br/>
`setx MIX_ENV "prod"`

After the environment variable is set, run the following:

`mix release`

Finally, run:

`_build/prod/rel/ashurbanipal/bin/ashurbanipal start`

## Tests

To run the test suite, run the following command:

`mix test`

## Approach

This projects inteds to use pure OTP, no databases or Phoenix. When the application starts, the Supervisor will initialize the `Ashurbanipal.Stories` and the `Ashurbanipal.Scheduler` GenServers.

It will also start a `Cowboy` server that will handle requests via the `Ashurbanipal.Router` module.

The `Scheduler` will mainly do two things: 

* It will interact with the `Stories` GenServer in order to populate the `:stories` ETS table with data harvested with the `Ashurbanipal.HNClient` module.
* It will schedule itself to run in 5 minutes.

The ideas is to refresh the ETS `:stories` table every 5 minutes with fresh data from the Hacker News Stories API.

### What happens if the Hacker News API is down?

I'm glad you ask. The application will update the ETS table with `nil`.

### Yes, yes, give me the JSON already!

The HTTP JSON API is available at `localhost:4000/stories`. A `GET` request to that endpoint will get you Hacker News Top 50 stories as JSON.

You can also get single stories by specifying the story ID like this:

`GET localhost:4000/stories/<ID>`

You can also paginate! Like this:

`GET localhost:4000/stories?page=1`

That will get you 10 stories as the first page. There are 5 pages in total. If you pass an invalid page number the endpoint will return all stories by default.

## Author

👤 **Josias Alvarado**

- GitHub: [@pointerish](https://github.com/pointerish)
- Twitter: [@pointerish](https://twitter.com/pointerish)
- LinkedIn: [LinkedIn](https://www.linkedin.com/in/josias-alvarado/)

## Contributing

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](https://github.com/pointerish/ashurbanipal/issues).
## Final Comments

I had a lot of fun writing this simple application. I was originally set to implement a WebSockets API, but I was unable to implement this due to my inexperience with WebSockets and time constraints. I will add it in the following days, mainly because of the educational value of it.
