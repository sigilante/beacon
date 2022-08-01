  ::  sentinel.hoon
::::  Grants perms to %sentinel process for authentication.
::
::    Maintains list of authenticated websites.
::
::    Scry endpoints:
::
::    y  /                (map url fate)
::
::    x  /undecide        (set url)
::    x  /approved        (set url)
::    x  /rejected        (set url)
::    x  /url/[url]       (unit fate)
::
/-  sentinel, hark=hark-store
/+  default-agent, dbug, verb, rudder
/~  pages  (page:rudder urls:sentinel action:sentinel)  /app/sentinel
|%
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  $:
      %zero
      requests=(map url:sentinel fate:sentinel)
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
  ~&  >  "%sentinel initialized successfully."
  :_  this
  :~  [%pass /bind %arvo %e %connect [~ /'sentinel'] %sentinel]
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
    =/  action  !<(?([%what url:sentinel] [%okay url:sentinel] [%yeet url:sentinel] [%sour url:sentinel @dr]) vase)
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
      %sentinel-action
    =/  action  !<(?([%what url:sentinel] [%okay url:sentinel] [%yeet url:sentinel] [%sour url:sentinel @dr]) vase)
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
      :_  this(requests (~(put by requests) +.action %lachesis))
          [%give %fact ~ %sentinel-action !>(`action:sentinel`[%okay `url:sentinel`+.action])]~
      ::
      ::  A URL has been disapproved.  (local only)
        %yeet
      ?>  =(our.bowl src.bowl)
      :_  this(requests (~(put by requests) +.action %atropos))
          [%give %fact ~ %sentinel-action !>(`action:sentinel`[%yeet `url:sentinel`+.action])]~
      ::
      ::  A URL has timed out.  (local only)
        %sour
      ?>  =(our.bowl src.bowl)
      :_  this(requests (~(put by requests) +<.action %clotho))
          [%give %fact ~ %sentinel-action !>(`action:sentinel`[%yeet `url:sentinel`+<.action])]~
    ==
  ::
    ::  %handle-http-request:  incoming from eyre
    ::
      %handle-http-request
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vase) +.state]
    %-  (steer:rudder _+.state action:sentinel)
    :^    pages
        (point:rudder /[dap.bowl] & ~(key by pages))
      (fours:rudder +.state)
    |=  =action:sentinel
    ^-  $@  brief:rudder
        [brief:rudder (list card) _+.state]
    =^  caz  this
      (on-poke %sentinel-action !>(action))
    ['Processed succesfully.' caz +.state]
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ~&  >  "%sentinel:  subscription from {<src.bowl>}."
  ?+  path  (on-watch:default path)
      [%http-response *]
    `this
    ::
      [%status =url:sentinel *]
    :_  this
    =/  result  (~(gut by requests) `url:sentinel`+<:path '')
    ~&  >>  "%sentinel: {<result>}"
    ~&  >>  ~(tap by requests)
    ?:  ?=(%lachesis result)
      [%give %fact ~ %sentinel-action !>(`action:sentinel`[%okay result])]~
    [%give %fact ~ %sentinel-action !>(`action:sentinel`[%yeet result])]~
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
          |=  [p=[a=url:sentinel b=fate:sentinel] q=(set url:sentinel)]
          ?:  ?=(%clotho b.p)  (~(put in q) a.p)  q
        [%x %approved ~]
          %-  alp
          %-  ~(rep by requests)
          |=  [p=[a=url:sentinel b=fate:sentinel] q=(set url:sentinel)]
          ?:  ?=(%lachesis b.p)  (~(put in q) a.p)  q
        [%x %rejected ~]
          %-  alp
          %-  ~(rep by requests)
          |=  [p=[a=url:sentinel b=fate:sentinel] q=(set url:sentinel)]
          ?:  ?=(%atropos b.p)  (~(put in q) a.p)  q
        [%x %url url:sentinel ~]
          ``noun+!>((~(get by requests) +>-.path))
      ==
  ::  scry results
  ++  arc  |=  l=(list url:sentinel)  ``noun+!>(`arch`~^(malt (turn l (late ~))))
  ++  alp  |=  s=(set url:sentinel)    ``noun+!>(s)
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
      [%sentinel ~]
    ?+    -.sign  (on-agent:default wire sign)
        %watch-ack
      ?~  p.sign
        ((slog '%sentinel: Subscribe succeeded!' ~) `this)
      ((slog '%sentinel: Subscribe failed!' ~) `this)
    ==
  ==
::
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--
