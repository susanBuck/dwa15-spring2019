# Extending Form.php
If you want to add new validation methods or overwrite the behavior of existing validation methods, you can create your own Form class that builds upon the provided Form class, demonstrating a key concept of OOP programming known as **inheritance**. 

## Step 1 
Create a new class which will extend the behavior of the provided `Form` class. The following example shows a demo with a new class called `MyForm`.

Note how `MyForm` __extends__ the parent `Form` class allowing it to inherit all of `Form`'s public or protected methods and properties.

In this example, I've defined a new `password` method to check that a given value contains a letter, number, and symbol. You can overwrite existing validation functions or define new ones, depending on what your needs are.

When adding new validation method, you should also include a corresponding message method for that function, as shown below.

```php
<?php
# Filename: MyForm.php

namespace Buck; # Choose your own namespace for this class. Could be your last name, your app name, etc.

use DWA\Form; # Use statement here will allow us to extend Form below

class MyForm extends Form
{
    /**
     * The value must contain at least one letter, digit, and special character
     * @param $value
     * @return bool
     */
    protected function password($value)
    {
        $containsLetter = preg_match('/[a-zA-Z]/', $value);
        $containsDigit = preg_match('/\d/', $value);
        $containsSpecial = preg_match('/[^a-zA-Z\d]/', $value);

        return $containsLetter and $containsDigit and $containsSpecial;
    }
    protected function passwordMessage()
    {
        return 'does not contain at least one letter, digit, and special character.';
    }
}
```

## Step 2
Update your logic file so that it includes your new form class (`MyForm`) and instantiates it instead of `Form.`

```php
<?php
require('Form.php'); # <--- Still need this because MyForm.php will extend it
require('MyForm.php'); # <--- NEW

#use DWA\Form; # <--- REMOVE
use Buck\MyForm; # <--- NEW

#$form = new Form($_GET); # <--- REMOVE
$form = new MyForm($_GET); # <--- NEW

# Now you can use your password method just like any of the existing validation methods
if ($form->isSubmitted()) {
    $errors = $form->validate(
        [
            'password' => 'required|password',
        ]
    );
}
```
