#   Website Authentication using Urbit ID

**This version is superseded by [`%beacon`](https://github.com/tinnus-napbus/beacon)/[`%sentinel`](https://github.com/tinnus-napbus/sentinel) at ~tinnus-napbus’ repos.**

##  Design Objective

A website can authenticate a user's ownership of an active Urbit ship using a pair of agents:  one on the website's ship to request authentication, and one on the user's ship to confirm it.

##  Software

[Beacon](https://github.com/sigilante/beacon) requests an authentication from a user's ship.  [Sentinel](https://github.com/sigilante/sentinel) replies with a confirmation or a denial, based on user determination.

Authentication requires two agents:

- `%beacon` is an Urbit app intended to be run on a website's Urbit ship.  `%beacon` will request the user's Urbit ship's `%sentinel` agent whether the website login attempt should be continued, and notify the website when the answer is `%.y` yes.

  - `|install ~dister-dozzod-lapdeg %beacon`

- `%sentinel` is an Urbit app which logs and responds to website authentication requests.  `%sentinel` will track all approved websites and reply to `%beacon` subscriptions with the status of the authentication.

  - `|install ~dister-dozzod-lapdeg %sentinel`

##  `%beacon`

The `%beacon` agent requests authentication for websites from users with the `%sentinel` agent.

An Urbit ship maintains a standard interface for HTTP `POST` and `GET` requests, documented [here](https://developers.urbit.org/guides/core/app-school-full-stack/5-eyre) and [here](https://developers.urbit.org/reference/arvo/eyre/external-api-ref).  This will take place over a channel, an SSE stream.  You should not need to write any Hoon code to work with `%beacon`, and the web interface is provided for debugging and sanity-checking the behavior of the channel system.

`%beacon` maintains two states:  approved and unapproved.  When a request is sent, the Urbit ship is marked as unapproved.  This state only changes when the client `%sentinel` agent responds that an approval has been made.

`%beacon` allows you to set the current website.  Since this is raw text, you should be consistent in how you type it:  e.g. `https://urbit.org/` and `https://urbit.org` will appear to be different websites.

First get your cookie:

```sh
curl -i localhost:8080/~/login \
     -X POST \
     -d "password=lidlut-tabwed-pillex-ridrup"
```

To set the self-identifying URL, send a JSON message to the local `%beacon` ship at the endpoint `/beacon-set-url` with the contents of the target ship:  `{"url":"https://urbit.org"}`.  You should be consistent with this as it is only text (that is, trailing `/` will distinguish sites.)

```sh
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v7.n3fd5.vskf3.abi1u.e4j6i.8j4h1" \
     --request PUT \
     --data '{"url":"https://urbit.org"}' \
     http://localhost:8080/beacon/set-url
```

To issue an authentication request, send a JSON message to the local `%beacon` ship at the endpoint `/beacon-send` with the contents of the target ship:  `{"ship":"~zod"}`.

```sh
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v7.n3fd5.vskf3.abi1u.e4j6i.8j4h1" \
     --request PUT \
     --data '{"ship":"~zod"}' \
     http://localhost:8080/beacon/send
```

To check on the state of an authentication request, send a JSON message to the local `%beacon` ship at the endpoint `/beacon-check` with the contents of the target ship:  `{"ship":~"zod"}`.

```sh
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v7.n3fd5.vskf3.abi1u.e4j6i.8j4h1" \
     --request PUT \
     --data '{"ship":"~zod"}' \
     http://localhost:8080/beacon/check
```

This will respond with a JSON of the format `{"ship":"~zod", "status": "true"}` (or `"false"`).

##  `%sentinel`

The `%sentinel` agent accepts requests from websites using the `%beacon` agent.

`%sentinel` maintains a list of known websites.  Each website may have one of three states:  pending, approved, and rejected.

Although you can preemptively input a website to approve it, website approval is not linted and therefore `https://urbit.org/` and `https://urbit.org` will appear to be different websites.  You should wait for the requester so that you approve their intended form.

There is not currently a mechanism to entirely delete website requests, only to disapprove them.

##  Website Story

A website provider has a website running on a server.  Somewhere accessible to this server (perhaps on the same machine, perhaps not), the provider also has an Urbit ship (likely a moon) with `%beacon` installed.

```hoon
|install ~dister-dozzod-lapdeg %beacon
```

When a user attempts to log in to the website using an option for Urbit ID, the site requests the ship's `%beacon` agent to authenticate the user.  The `%beacon` agent will request the authentication status from the user's planet and relay the status to the website, which has subscribed to the `%beacon` agent for that ship's status.  Details for the JSON API are included in the discussion on `%beacon` above.

At this point, three relevant possibilities follow:

1. The user has `%sentinel` installed and has approved the website's authentication request.
2. The user has `%sentinel` installed but has not approved the website's authentication request (or has denied it).
3. The user does not have `%sentinel` installed.

(Other cases include the user entering a ship which isn't currently on the network, or which they do not control.  We ignore these cases in this guide.)

In the first case, authentication should proceed smoothly.  The website is responsible for maintaining the session.

In the second case, the login should be re-attempted by the user after granting approval through `%sentinel`.

In the third case, the user should be told how to install the `%sentinel` agent and how to approve the request.  The user will then need to re-initiate the login authentication attempt at the website.


##  User Story

A user has `%sentinel` installed.  At their ship's URL plus `/sentinel`, they are able to manage approved websites.  While a user can input any website, he should wait for the external request because the URL is string-based; that is, `https://urbit.org` differs from `https://urbit.org/` for `%sentinel`.

If the user does not have `%sentinel` installed, he should install it to handle any website authentication requests fielded by `%beacon`.

```hoon
|install ~dister-dozzod-lapdeg %sentinel
```

Revoking website approval will not cancel any current sessions.
