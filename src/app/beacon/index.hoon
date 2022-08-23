::  Beacon index
::
/-  *beacon
/+  rudder
::
!:
^-  (page:rudder [url ships] appeal)
|_  [=bowl:gall * [auto=url bids=ships]]
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder appeal)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ::  get appeal (%auto or %send or %burn)
  ?~  what=(~(get by args) 'what')
    ~
  ::  get URL
  ?~  who=(~(get by args) 'who')
    ~
  ?+  u.what  ~
      ?(%auto %send %burn)
    ?:  ?=(%send u.what)
      [%send `ship`(need (slaw %p u.who))]
    ?:  ?=(%auto u.what)
      [%auto `url`u.who]
    %burn
    :: no manual %auth allowed for security
  ==
::
++  final  (alert:rudder (cat 3 '/' dap.bowl) build)
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  |^  [%page page]
  ::
  ++  icon-color  "blue"
  ::
  ++  style
    '''
    body { 
      display: flex; 
      width: 100%; 
      height: 100%; 
      justify-content: center; 
      align-items: center; 
      font-family: "Inter", sans-serif;
      margin: 0;
      -webkit-font-smoothing: antialiased;
    }
    main {
      width: 100%;
      max-width: 500px;
    }
    button {
      -webkit-appearance: none;
      border: none;
      outline: none;
      border-radius: 100px; 
      font-weight: 500;
      font-size: 1rem;
      padding: 12px 24px;
      cursor: pointer;
    }
    button:hover {
      opacity: 0.8;
    }
    button.inactive {
      background-color: #F4F3F1;
      color: #626160;
    }
    button.active {
      background-color: #000000;
      color: white;
    }
    a {
      text-decoration: none;
      font-weight: 600;
      color: rgb(0,177,113);
    }
    a:hover {
      opacity: 0.8;
    }
    .none {
      display: none;
    }
    .block {
      display: block;
    }
    code, .code {
      font-family: "Source Code Pro", monospace;
    }
    .bg-green {
      background-color: #12AE22;
    }
    .text-white {
      color: #fff;
    }
    h3 {
      font-weight: 600;
      font-size: 1rem;
      color: #626160;
    }
    form {
      display: flex;
      justify-content: space-between;
    }
    form button, button[type="submit"] {
      border-radius: 10px;
    }
    input {
      font-family: "Source Code Pro", monospace;
      border: 1px solid #ccc;
      border-radius: 6px;
      padding: 12px;
      font-size: 12px;
      font-weight: 600;
    }
    .flex {
      display: flex;
    }
    .col {
      flex-direction: column;
    }
    .align-center {
      align-items: center;
    }
    .justify-between {
      justify-content: space-between;
    }
    .grow {
      flex-grow: 1;
    }
    @media screen and (max-width: 480px) {
      main {
        padding: 1rem;
      }
    }
    '''
  ::
  ++  authorize-button
    '''
     document.getElementById('instructions').classList = 'none'; 
     document.getElementById('configure').classList = 'block';
     document.getElementById('config-button').classList = 'active';
     document.getElementById('instructions-button').classList = 'inactive';
    '''
  ::
  ++  instructions-button
    '''
     document.getElementById('configure').classList = 'none'; 
     document.getElementById('instructions').classList = 'block';
     document.getElementById('config-button').classList = 'inactive';
     document.getElementById('instructions-button').classList = 'active';
    '''
  ::
  ++  page
    ^-  manx
    ;html
      ;head
        ;title:"%beacon"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;link(href "https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Source+Code+Pro:wght@400;600&display=swap", rel "stylesheet");
        ;style:"{(trip style)}"
      ==
      ;body
        ;main
          ;h2:"Beacon"
          ;button(id "config-button", class "active", onclick "{(trip authorize-button)}"): Configure
          ;button(id "instructions-button", class "inactive", onclick "{(trip instructions-button)}"): Instructions
          ;div(id "instructions", class "none")
            Requests authentication for URLs to ships using the Sentinel agent for
            website authentication.

            Some websites that use Beacon and Sentinel:

            ;a/"https://vienna.earth"
              ; Vienna HyperText smart canvas
            ==
            ;br;

            This app was built using ~palfun-foslup’s Rudder library.
          ==
          ;div(id "configure")
            ;+  ?~  msg  ;p:""
                ?:  o.u.msg  ::TODO  lightly refactor
                  ;p.green:"{(trip t.u.msg)}"
                ;p.red:"{(trip t.u.msg)}"

            ;h3:"Set self"
            ;form(method "post")
              ;input(type "text", name "who", placeholder "{(trip auto)}", class "grow");
              ;button(type "submit", class "bg-green text-white", name "what", value "auto"):"Set"
            ==

            ;h3:"Ship bids"

            ;div(class "flex col")
              ;form(method "post", class "flex col")
                ;div(style "font-weight: bold")
                  ;div:"Ship"
                ==
                ;div(class "flex align-center justify-between")
                  ;div(class "flex grow")
                    ;input(type "text", name "who", placeholder "~sampel-palnet", class "grow");
                  ==
                  ;div
                    ;button(type "submit", name "what", value "send"):"Send"
                  ==
                ==
              ==
              ::  Clotho spins the thread of life; here she tallies bids.
              ;*  clotho
              ::  Lachesis measures the span of life; here she tracks approvals.
              ;*  lachesis
              ::  Atropos cuts the thread of life; here she reaps rejections.
              ;*  atropos
            ==
          ==
        ==
      ==
    ==
  ::  Reject the request.
  ++  cut-with-shears
    |=  =ship
    ^-  manx
    ;form(method "post")
      ;input(type "hidden", name "who", value (trip ship));
      ;button(type "submit", name "what", value "burn"):"Delete"
    ==
  ::
  ++  peers
    |=  [fate=?(%clotho %lachesis %atropos) mer=(list ship)]
    ^-  (list manx)
    %+  turn  mer
    |=  =ship
    ^-  manx
    =/  ack=(unit ^fate)  (~(get by bids) ship)
    ;div(class "flex align-center justify-between")
      ::  Button
      ;+  ?:  ?=(%lachesis fate)
            ;div
              ;+  (cut-with-shears ship)
            ==
      ::  Ship
      ;div(style "border: 1px solid #ccc; padding: 12px; border-radius: 6px", class "code"):"{(scow %p ship)}"
      ::  Symbol
      ;div
        ;+  (relation fate ack)
      ==
    ==
  ::
  ::  Lachesis measures the span of life; here she tracks approved ships.
  ++  lachesis
    ^-  (list manx)
    %+  peers  %lachesis
    %+  skim  ~(tap in ~(key by bids))
    |=  =ship
    ?=(%lachesis (need (~(get by bids) ship)))
  ::
  ::  Clotho spins the thread of life; here she tracks requesting ships.
  ++  clotho
    ^-  (list manx)
    %+  peers  %clotho
    %+  skim  ~(tap in ~(key by bids))
    |=  =ship
    ?=(%clotho (need (~(get by bids) ship)))
  ::
  ::  Atropos cuts the thread of life; here she tracks rejected URLs.
  ++  atropos
    ^-  (list manx)
    %+  peers  %atropos
    %+  skim  ~(tap in ~(key by bids))
    |=  =ship
    ?=(%atropos (need (~(get by bids) ship)))
  ::
  ++  relation
    |=  [fate=?(%clotho %lachesis %atropos) ack=(unit fate)]
    =.  ack
      ?.  ?=(%lachesis fate)  ~
      `(fall ack %clotho)
    ^-  manx  ~+
    ?-  fate
        %atropos
      ;p: Rejected
    ::
        %lachesis
      ;p: Approved
    ::
        %clotho
    ;p: Pending
    ==
  --
--
