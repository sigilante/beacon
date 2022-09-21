  ::  beacon.hoon
::::  Requests authentication from a watcher process, %sentinel.
::
::    Registers URL(s) and requests authentication status.
::
::    Scry endpoints:
::
::    y  /                (set ship)
::
::    x  /me              url
::    x  /notyet          (set ship)
::    x  /authed          (set ship)
::    x  /burned          (set ship)
::
/-  beacon, sentinel
/+  dbug, default-agent, rudder, server, verb
/~  pages  (page:rudder [url:beacon ships:beacon] appeal:beacon)  /app/beacon
|%
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  $:
      %zero
      auto=url:beacon
      bids=ships:beacon
    ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-zero
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  "%beacon initialized successfully."
  :_  this
  [%pass /eyre %arvo %e %connect [~ /'beacon'] %beacon]~
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %zero  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  |^
  ?+    mark  (on-poke:default mark vase)
  ::
      %beacon-appeal
    =/  appeal  !<(appeal:beacon vase)
    ?-    -.appeal
    ::
    ::  Set the agent's authentication URL.
        %auto
      ?:  =(auto url.appeal)
        `this
      =/  ship-list=(list ship)  ~(tap in ~(key by bids))
      =/  cards=(list card)
        %+  turn  ship-list
        |=  =ship
        ^-  card
        [%pass /beacon/(scot %t auto) %agent [ship %sentinel] %leave ~]
      =.  cards
        %+  weld  cards
        %+  turn  ship-list
        |=  =ship
        ^-  card
        =/  =wire  /beacon/(scot %t url.appeal)
        =/  =path  /status/(scot %t url.appeal)
        [%pass wire %agent [ship %sentinel] %watch path]
      [cards this(auto url.appeal, bids (~(run by bids) |=(* %clotho)))]
    ::
    ::  Authentication for our URL has been requested.  (local only)
        %send
      ?:  (~(has by bids) ship.appeal)
        `this
      :_  this(bids (~(put by bids) ship.appeal %clotho))
      :~  :*  %pass
              /beacon/(scot %t auto)
              %agent  [ship.appeal %sentinel]  %watch
              /status/(scot %t auto)
      ==  ==
    ::
    ::  A URL has been approved.
        %auth
      `this(bids (~(put by bids) ship.appeal %lachesis))
    ::
    ::  A URL has been disapproved.
        %burn
      `this(bids (~(put by bids) ship.appeal %atropos))
    ==
  ::
  ::  %handle-http-request:  incoming from eyre
      %handle-http-request
    =+  !<([id=@ta =inbound-request:eyre] vase)
    ?>  authenticated.inbound-request
    =/  =path
      %-  tail
      %+  rash  url.request.inbound-request
      ;~(sfix apat:de-purl:html yquy:de-purl:html)
    ?+    path  (on-poke:default mark vase)
    ::
    ::  Main page, so return rendered page
        [%beacon ~]
      =;  out=(quip card _+.state)
        [-.out this(+.state +.out)]
      %.  [bowl !<(order:rudder vase) +.state]
      %-  (steer:rudder _+.state appeal:beacon)
      :^    pages
          (point:rudder /[dap.bowl] & ~(key by pages))
        (fours:rudder +.state)
      |=  =appeal:beacon
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %beacon-appeal !>(appeal))
      ['Processed succesfully.' caz +.state]
    ::
    ::  Server URL request, so parse JSON to set URL
        [%beacon %set-url ~]
      ?~  body.request.inbound-request
        (bail id 'not-implemented')
      =/  url
        %-  (ot url+so ~):dejs:format
        (need (de-json:html q:(need body.request.inbound-request)))
      :_  this(auto url)
      %+  give-simple-payload:app:server  id
      %-  simple-payload:http
      %-  json-response:gen:server
      %+  frond:enjs:format  %status  b+%.y
    ::
    ::  Server URL request, so parse JSON to send request
        [%beacon %send ~]
      ?~  body.request.inbound-request
        (bail id 'not-implemented')
      =/  target=@p
        %-  (ot ship+(se %p) ~):dejs:format
        (need (de-json:html q:(need body.request.inbound-request)))
      ::(on-poke %beacon-appeal !>(`appeal:beacon`[%auth target]))
      :_  this(bids (~(put by bids) target %clotho))
      ^-  (list card)
      :-  :*  %pass
                /beacon/(scot %t auto)
                %agent  [target %sentinel]  %watch
                /status/(scot %t auto)
          ==
      %+  give-simple-payload:app:server  id
      %-  simple-payload:http
      %-  json-response:gen:server
      %+  frond:enjs:format  %status  b+%.y
      
    ::
    ::  Server URL request, so parse JSON to check status
        [%beacon %check ~]
      ?~  body.request.inbound-request
        (bail id 'not-implemented')
      =/  target=@p
        %-  (ot ship+(se %p) ~):dejs:format
        (need (de-json:html q:(need body.request.inbound-request)))
      =/  result  (~(gut by bids) target %clotho)
      :_  this
      %+  give-simple-payload:app:server  id
      %-  simple-payload:http
      %-  json-response:gen:server
      (to-js target ?:(=(%lachesis result) %.y %.n))
    ==
  ==
  ++  error-response
    |=  error=@t
    ^-  simple-payload:http
    =,  enjs:format
    %-  json-response:gen:server
    %+  frond  
    %error  s+error
  ++  bail
    |=  [id=@ta error=@t]
    ^-  (quip card _this)
    :_  this
    %+  give-simple-payload:app:server  id
    (error-response error)
  ++  to-js
    |=  [=ship:beacon status=?(%.y %.n)]
    |^  ^-  json
    %-  pairs:enjs:format
    :~  :-  'ship'    s+(scot %p ship)
        :-  'status'  b+status
    ==
    --
  --
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:default path)
      [%http-response *]
    ?>  (team:title our.bowl src.bowl)
      `this
    (on-watch:default path)
    ::
      [%status @ ~]
    =/  =ship  (slav %p i.t.path)
    :_  this
    =/  result  (~(gut by bids) ship '')
    ?:  ?=(%lachesis result)
      [%give %fact ~ %beacon-appeal !>(`appeal:beacon`[%auth ship])]~
    [%give %fact ~ %beacon-appeal !>(`appeal:beacon`[%burn ship])]~
  ==
++  on-leave  on-leave:default
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?>  =(our src):bowl
  |^  ?+  path  [~ ~]
        [%y ~]            (arc ~[%clotho %lachesis %atropos])
        [%x %me ~]        ``noun+!>(auto)
        [%x %notyet ~]
          %-  alp
          %-  ~(rep by bids)
          |=  [p=[a=ship b=fate:beacon] q=(set ship)]
          ?:  ?=(%clotho b.p)  (~(put in q) a.p)  q
        [%x %authed ~]
          %-  alp
          %-  ~(rep by bids)
          |=  [p=[a=ship b=fate:beacon] q=(set ship)]
          ?:  ?=(%lachesis b.p)  (~(put in q) a.p)  q
        [%x %burned ~]
          %-  alp
          %-  ~(rep by bids)
          |=  [p=[a=ship b=fate:beacon] q=(set ship)]
          ?:  ?=(%atropos b.p)  (~(put in q) a.p)  q
        [%x %ship ship ~]
          ``noun+!>((~(get by bids) (need (slaw %p +>-.path))))
      ==
  ::  scry results
  ++  arc  |=  l=(list url:beacon)  ``noun+!>(`arch`~^(malt (turn l (late ~))))
  ++  alp  |=  s=(set ship)  ``noun+!>(s)
  ++  alf  |=  f=?           ``noun+!>(f)
  ++  ask  |=  u=(unit ?)  ?^(u (alf u.u) [~ ~])
  ::  data wrestling
  ++  nab  ~(got by bids)
  ::  set shorthands
  ++  sin  |*(s=(set) ~(has in s))
  ++  sit  |*(s=(set) ~(tap in s))
  ++  ski  |*([s=(set) f=$-(* ?)] (sy (skim (sit s) f)))
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ::  handle wire returns from agents
  ?+    wire  (on-agent:default wire sign)
      [%beacon @ ~]
    ?+    -.sign  (on-agent:default wire sign)
        %watch-ack
      ?~  p.sign
        ((slog '%beacon: Subscribe succeeded!' ~) `this)
      ((slog '%beacon: Subscribe failed!' ~) `this)
    ::
        %kick
      :_  this
      [%pass wire %agent [src.bowl %sentinel] %watch /status/[i.t.wire]]~
    ::
        %fact
      ?+    p.cage.sign  (on-agent:default wire sign)
        :: It's a bit strange to unpack these because they return the
        :: action and the ship, which is the source already.  TODO clean up
          %beacon-appeal
        =/  action  !<(appeal:beacon q.cage.sign)
        ?+    -.action  (on-agent:default wire sign)
            %auth
          `this(bids (~(put by bids) src.bowl %lachesis))
            %burn
          `this(bids (~(put by bids) src.bowl %atropos))
        ==
      ==
    ==
  ==
::
++  on-arvo
|=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%eyre %bound *] sign-arvo)
    (on-arvo:default [wire sign-arvo])
  ?:  accepted.sign-arvo
    %-  (slog leaf+"%beacon:  endpoints bound successfully!" ~)
    `this
  %-  (slog leaf+"%beacon:  binding endpoints failed!" ~)
  `this
++  on-fail   on-fail:default
--
