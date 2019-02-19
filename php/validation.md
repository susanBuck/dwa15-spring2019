# Validation

Whenever you accept input from a visitor, that input needs to be validated.

Here are examples of the kind of validation you would see on the Project 2 examples:

+ Scrabble calculator: An input asking for the word should only accept letters.
    + Pass: `apple`, `garage`
    + Fail: `-1`, `99`, `0range`
+ Password generator: An input asking for the password length should have a reasonable range like 1 to 10. It should also only allow positive integers.
    + Pass: `1`, `5`, `10`
    + Fail: `-1`, `abc`, `99`

Here are examples of validations you might see in a real world application:

+ An email input in a sign-up form should a) confirm it's a valid email address and b) the email address does not already exist in the system.
+ An input collecting a US zip code should have a min/max of 5 characters and only contain numbers
+ An input collecting a discount code should confirm the code is valid and not expired
+ etc...


## Client-side vs. Server-side validation
Ultimately, validation should happen on both the client (via HTML + JavaScript) *and* the server (PHP).

The &ldquo;first-pass&rdquo; client-side validation via HTML and JavaScript can be used to give the visitor **instant feedback** about many issues and prevent form submission.

(Sometimes, the client-side validation may send a request to the server using Ajax to confirm data, e.g username does not already exist).

Once client-side validation passes, the form can submit to the server where a second-pass validation is done.

This second-pass validation step is necessary when working with important data because it's possible for users to bypass client-side validation using browser web inspector tools.

In this course, because our focus is on the server end of things, we will not be using JavaScript client-side validation. In fact, you are prohibited from using JS validation on projects, as doing so would abstract whether your server-side validation is functioning as expected.

Aside from JavaScript, there is some client-side validation functionality built into HTML when you add attributes like `required`, `min`, `max`, `email`, etc.
 [You can learn more about these attributes here.](https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms/Data_form_validation)
 It is acceptable, but not required, that you use these HTML attributes in your projects. If you do use these attributes, it can not be used as a substitute for server-side validation.



## Server-side validation

Goals:
+ Validation should happen in your logic file, before the user-entered data is used.
+ If there are errors in the form data, the visitor should be directed back to the form where the errors occurred.
+ Errors should stand-out from the rest of the page so they're not easily missed. By convention, error messages should be some shade of red. 
+ Any fields that had errors should be pre-filled with the problematic data the user had entered, making it easy for them to correct the problems. Exceptions are made for secure fields like passwords, credit card numbers, etc.

To accomplish these goals in P2, we'll use a PHP class I'm providing called `Form.php` which includes validation functionality in addition to some other form-related utilities.

Documentation for this class is provided in the next note set: [Form.php usage](/php/form.php-usage.md)