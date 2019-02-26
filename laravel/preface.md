# Preface 

## What we've done so far - &ldquo;from scratch&rdquo; PHP

+ Distinguishing between logic and display code
+ Form processing
+ Tapping into a data source (`books.json`)
+ Harnessing external code (e.g. `Form.php`, `helpers.php`)
+ Validating input

Moving forward, we'll rely on a framework to provide a lot of this functionality.



## Web applications - 2 approaches

### Approach 1: &ldquo;page-redraw&rdquo; applications
+ Heavy lifting is done on the server producing a page that is displayed by the client
+ May also use Ajax to transfer data from server to client, demonstrating some overlap with Approach 2.
+ __Examples:__ [Wikipedia](http://wikipedia.org), [Github](http://github.com), [Extension School site](https://www.extension.harvard.edu)

### Approach 2: [Single-page applications (SPA)](https://en.wikipedia.org/wiki/Single-page_application)
+ Moves logic from server to client
+ Heavy reliance on Ajax to get data from server to client, as needed
+ The server acts as a pure data API
+ Often powered with JS templating libraries like AngularJS, Vue.js, Ember.js
+ __Examples:__ [Trello (to-do manager)](https://trello.com/b/StETuJLh/demo), Gmail, Facebook

Examples listed above are chosen because they *mostly* demonstrate the given approach; oftentimes a site may use a hybrid of both approaches. There's no one best approach&mdash; it depends on the needs of your application.

In this course, __we'll build our applications using Approach 1__, but know that the work we're doing has overlap with techniques you'd use when building a SPA, especially when programming the server-side API for your SPA.

If you wish to explore SPA's after this course I recommend checking out [Vue](https://vuejs.org) which is a JavaScript framework commonly paired with Laravel.
