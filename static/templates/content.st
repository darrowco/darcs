<div id="content">
  $if(revision)$
    <h2 class="revision">Revision $revision$</h2>
  $endif$
  <style>h1.pageTitle.FrontPage {display:none;}</style>
  <h1 class="pageTitle $pagetitle$"><a href="$base$$pageUrl$">$pagetitle$</a></h1>
  $if(messages)$
    $messages()$
  $endif$
  $content$
</div>
