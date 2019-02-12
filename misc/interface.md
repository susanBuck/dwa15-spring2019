# Interface
This is not a design course so your projects do not have to be works of art, but with a little bit of attention we can create clear and professional-looking interfaces.

Specifically, each project should abide by the following guidelines.

## Content
1. While your sub-domain and repository name may include terms like *P2* or *Project 2*, the application itself should be presented with a thoughtful and fitting title.
2. Every page should have a consistent header that features this title prominently at the top of the page. The title can be presented as text, or in the form of an image if presented as some stylized logo.
3. If your app has multiple pages, each page should have the same header and it should always link back to the homepage.
4. The homepage should have a welcome/introduction to the application explaining its purpose. Design your app as it were for an outside audience. If I were to pull someone off the street and ask them to interact with your site, it should make sense to them what the purpose of the site is and how to use it.

## Presentation
1. Copy/text should use proper English and be void of typos.
2. There should be a consistent and logical ordering in the size/presentation of headers.
3. Layout should look presentable on laptop/desktop resolution (responsive design is welcome, but not required).
4. Spacing and alignment should be used consistently and with intention.
5. Any graphics/images should be of good quality— there should be no pixelated, blurry, distorted, or otherwise low quality images.

## Usability
1. All links should be distinguished from regular text in some clear way (underlined, a different font color, etc.)
2. In most cases, button values should be changed from the default (i.e. *Submit*) to reinforce the action being taken (e.g. *Save changes*, *Place order*)
3. Any form inputs that are required should be labeled as such; exceptions are made for small forms where all inputs are implicitly required (e.g. a log in form)
4. Any form inputs that have non-obvious requirements should be labeled as such. For example, if a password must be at least 6 characters long, let the user know this in the form interface. Do not wait until the user has submitted the form to let them know about the requirement via your validation reporting. 
5. Always provide feedback&mdash; your interface should speak to your user, letting them know when their actions are right, wrong, or misunderstood.
6. Feedback/results should stand out from the content of the rest of the page so they don't go unnoticed. Bold text, borders, varying background colors can help with this. 
7. By convention error messages should be some variation of red (either in the text itself, or the background of the text). Green is a common color used for success/result messages.
7. Feedback/results should also be placed in a logical location; e.g. if a user submits a form and is immediately presented with the results, it's common for those results to be located somewhere near the button they pressed to submit the form. The user should not have to go hunting for results. 

## Accessibility
1. The interface should be clearly legible&mdash; avoid...
    + Excessively small or large font sizes.
    + Low contrast color combinations (e.g. yellow on white).
    + Garish color combinations (e.g. bright green background, red text).


## Example
<img src='https://s3.amazonaws.com/dwa15.com/bad-vs-good-interface@2x.png' style='max-width:1044px;' alt=''>

### Issues
* Bad application title
* Bad hierarchy - (*Details* should not be more prominent than page heading)
* Lacks clear context/instructions
* Alignment is inconsistent and slightly off-center, both with the main sections of content (the results and form) and also within the form (labels and input)
* Results
    + unexpected location (top of page, not end of form below submit)
    + do not stand out from the rest of the content on the page and are easily missed
    + Unnecessary breaking of password text, which would make it hard to copy
    + Not enough distinction between label (*Your password*) and the password itself
* Form
    * Required field and field restrictions (for number of words) not indicated.
    * Unnecessary abbreviation (*Num word* should be *Number of words* or *How many words*)
    * Number of words field unnecessarily long and inconsistent with the kind of data expected
    * No styling distinction between primary and secondary form labels
    * *Option* is labeling two inputs, so it should be plural
    * Submit button value ("Submit") does not reinforce action of the button
