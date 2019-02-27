# Error handling

If you look at the `.env` file in a Laravel project, you'll find a setting called `APP_DEBUG` which can be set to `true` or `false`.

## Local
When `APP_DEBUG` is set to **true** (as it should be on your **local** sever), the app is in debug mode, and any errors or exceptions triggered by your site will be displayed in full detail in the browser using a package Laravel includes called [whoops](https://github.com/filp/whoops).

<img src='https://s3.amazonaws.com/making-the-internet/laravel-debug-settings-local@2x.png' style='max-width:500px;' alt='Error settings on local server'>

## Production
When `APP_DEBUG` is set to **false** (as it should be on your **production** server), the full details of errors are suppressed and the visitor instead sees a generic error page.

<img src='https://s3.amazonaws.com/making-the-internet/laravel-debug-settings-prod@2x.png' style='max-width:500px;' alt='Error settings on production server'>

## Error log
Regardless of your `APP_DEBUG` setting, all errors are written to `/storage/logs/laravel.log`, which should be referenced if you're having problems with your application on your production server.

## Application settings supersede system settings
When working in a Laravel application, this error display/reporting behavior is made on an application level and it supersedes system level error settings discussed in these notes: [PHP: Error reporting and configs](/php/error-reporting-and-configs.md) 


