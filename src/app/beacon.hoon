  ::  beacon.hoon
::::  Appeals authentication from a watcher process, %sentinel.
::
::    Registers URL(s) and appeals authentication status.
::
::    Scry endpoints:
::
::    y  /                (set who:beacon)
::
::    x  /me              url:beacon
::    x  /authed          (set who:beacon)
::    x  /burned          (set who:beacon)
::
/-  beacon, hark=hark-store
/+  default-agent, dbug, verb, rudder
/~  pages  (page:rudder urls:beacon action:beacon)  /app/beacon
|%
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  $:
      %zero
      appeals=(map url:beacon fate:beacon)
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
  :~  [%pass /bind %arvo %e %connect [~ /'beacon'] %beacon]
  ==
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
  ?+    mark  (on-poke:default mark vase)
  ::
    ::  %noun:  boilerplate pokes, some with fencing
    ::
      %noun
    =/  action  !<(?([%what url:beacon] [%okay url:beacon] [%yeet url:beacon] [%sour url:beacon @dr]) vase)
    ?-    -.action
      ::
      ::  An incoming authentication request has been registered.
        %what
      ?:  (~(has by requests) +.action)
        `this
      `this(requests (~(put by requests) +.action %clotho))
      ::
      ::  A URL has been approved.  (local only)
        %okay
      ?>  =(our.bowl src.bowl)
      `this(requests (~(put by requests) +.action %lachesis))
      ::
      ::  A URL has been disapproved.  (local only)
        %yeet
      ?>  =(our.bowl src.bowl)
      `this(requests (~(put by requests) +.action %atropos))
      ::
      ::  A URL has timed out.  (local only)
        %sour
      ?>  =(our.bowl src.bowl)
      `this(requests (~(put by requests) +<.action %clotho))
    ==
    ::
      %beacon-action
    =/  action  !<(?([%what url:beacon] [%okay url:beacon] [%yeet url:beacon] [%sour url:beacon @dr]) vase)
    ?-    -.action
      ::
      ::  An incoming authentication request has been registered.
        %what
      ?:  (~(has by requests) +.action)
        `this
      `this(requests (~(put by requests) +.action %clotho))
      ::
      ::  A URL has been approved.  (local only)
        %okay
      ?>  =(our.bowl src.bowl)
      `this(requests (~(put by requests) +.action %lachesis))
      ::
      ::  A URL has been disapproved.  (local only)
        %yeet
      ?>  =(our.bowl src.bowl)
      `this(requests (~(put by requests) +.action %atropos))
      ::
      ::  A URL has timed out.  (local only)
        %sour
      ?>  =(our.bowl src.bowl)
      `this(requests (~(put by requests) +<.action %clotho))
    ==
  ::
    ::  %handle-http-request:  incoming from eyre
    ::
      %handle-http-request
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vase) +.state]
    %-  (steer:rudder _+.state action:beacon)
    :^    pages
        (point:rudder /[dap.bowl] & ~(key by pages))
      (fours:rudder +.state)
    |=  =action:beacon
    ^-  $@  brief:rudder
        [brief:rudder (list card) _+.state]
    =^  caz  this
      (on-poke %beacon-action !>(action))
    ['Processed succesfully.' caz +.state]
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ~&  >  "%beacon:  subscription from {<src.bowl>}."
  ?+  path  (on-watch:default path)
      [%http-response *]
    `this
    ::
      [%status url:beacon]
    :_  this
    =/  result  (~(gut by requests) `url:beacon`+<:path '')
    ?:  ?=(%lachesis result)
      [%give %fact ~ %beacon-action !>(`action:beacon`[%okay result])]~
    [%give %fact ~ %beacon-action !>(`action:beacon`[%yeet result])]~
  ==
++  on-leave  on-leave:default
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?>  =(our src):bowl
  |^  ?+  path  [~ ~]
        [%y ~]            (arc ~[%clotho %lachesis %atropos])
        [%x %undecided ~]
          %-  alp
          %-  ~(rep by requests)
          |=  [p=[a=url:beacon b=fate:beacon] q=(set url:beacon)]
          ?:  ?=(%clotho b.p)  (~(put in q) a.p)  q
        [%x %approved ~]
          %-  alp
          %-  ~(rep by requests)
          |=  [p=[a=url:beacon b=fate:beacon] q=(set url:beacon)]
          ?:  ?=(%lachesis b.p)  (~(put in q) a.p)  q
        [%x %rejected ~]
          %-  alp
          %-  ~(rep by requests)
          |=  [p=[a=url:beacon b=fate:beacon] q=(set url:beacon)]
          ?:  ?=(%atropos b.p)  (~(put in q) a.p)  q
        [%x %url url:beacon ~]
          ``noun+!>((~(get by requests) +>-.path))
      ==
  ::  scry results
  ++  arc  |=  l=(list url:beacon)  ``noun+!>(`arch`~^(malt (turn l (late ~))))
  ++  alp  |=  s=(set url:beacon)    ``noun+!>(s)
  ++  alf  |=  f=?           ``noun+!>(f)
  ++  ask  |=  u=(unit ?)  ?^(u (alf u.u) [~ ~])
  ::  data wrestling
  ++  nab  ~(got by requests)
  ::  set shorthands
  ++  sin  |*(s=(set) ~(has in s))
  ++  sit  |*(s=(set) ~(tap in s))
  ++  ski  |*([s=(set) f=$-(* ?)] (sy (skim (sit s) f)))
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:default wire sign)
      [%beacon ~]
    ?+    -.sign  (on-agent:default wire sign)
        %watch-ack
      ?~  p.sign
        ((slog '%beacon: Subscribe succeeded!' ~) `this)
      ((slog '%beacon: Subscribe failed!' ~) `this)
    ==
  ==
::
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--
