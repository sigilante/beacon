|%
+$  url     cord
+$  urls    (map url fate)
+$  ship    @p
::::  REQUEST STATUSES
::  Clotho spins the thread of life; here she tracks unapproved requests.
::  Lachesis measures the span of life; here she tallies approvals.
::  Atropos cuts the thread of life; here she reaps rejections.
+$  fate    ?(%clotho %lachesis %atropos)
::::  CLIENT ACTIONS (%sentinel)
::  %what   receive request to approve a URL
::  %okay   approve a URL (status to %.y)
::  %yeet   disapprove a URL (status to %.n)
::  %sour   time out for a URL (status to %.n)
+$  action
  $%  [%what =url]
      [%okay =url]
      [%yeet =url]
      [%sour =url =@dr]
  ==
--
