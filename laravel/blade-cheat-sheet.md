# Blade cheat sheet
The following is a list of commonly used Blade directives. This list is not comprehensive; refer to the [Blade](https://laravel.com/docs/blade) docs for a complete list.

### Basic output
+ `{{ $x }}` - Echo content
+ `{!! $x !!}` - Echo content without escaping special characters
+ `{{ $x ?? 'default' }}` - Echo content with a default value

### Template inheritance
+ `@extends('x')` - Extends a view template called `x`

+ Sections
    + `@section('x')` - Starts a section called `x`
    + `@endsection` - Ends a section
    + `@yield('x')` - Yields the content of a section called `x`
    + `@yield('x', 'y')` - Yields the content of a section called `x`; defaults to `y` if `x` is not defined.
+ Stacks
    + `@push('x')` - Starts a stack called `x`
    + `@endpush` - Ends a stack
    + `@stack('x')` - Yields the contents of a stack called `x`


### Sub-views
+ `@include('view.name')` - Includes another Blade view
+ `@includeIf('view.name')` - Includes another Blade view only if it exists
+ `@include(file, ['var' => $val,...])` - Includes another Blade view, passing new variables

### Control structures
+ `@if(condition)` - Starts an if block
+ `@else` - Starts an else block
+ `@elseif(condition)` - Start a elseif block
+ `@endif` - Ends a if block
+ `@foreach($list as $key => $val)` - Starts a foreach block
+ `@endforeach` - Ends a foreach block
+ `@for($i = 0; $i < 10; $i++)` - Starts a for block
+ `@endfor` - Ends a for block
+ `@while(condition)` - Starts a while block
+ `@endwhile` - Ends a while block
+ `@unless(condition)` - Starts an unless block
+ `@endunless` - Ends an unless block

### Misc
+ `{{-- Comment --}}` - A Blade comment
+ `@choice('message', $count)` - Outputs message with language pluralization
