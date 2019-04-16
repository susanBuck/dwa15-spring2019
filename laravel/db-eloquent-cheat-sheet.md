# Eloquent Cheat Sheet
This is a summary of commonly used methods for designing and executing Eloquent queries. This is not a comprehensive list - refer to the documentation for all the methods and more details.

## Design the query

### Constrain which columns are selected
```php
->select('col1','col2')
->select(['col1','col2'])
->addSelect('col3','col4')
->distinct()
```
  
### Filters
```php
->where('column', 'value')
->where('column', 'LIKE', '%'.$value.'%')
->where(function ($query) {
$query->where('a', '=', 1)
    ->orWhere('b', '=', 1);
})
->orWhere('column', '!=', 'value')
->orWhereExists()
->whereNotExists()
->orWhereNotExists()  
->whereIn('column',[1,2,3])
->orWhereIn()
->whereNotIn('id', function($query){
    $query->select('city_id')
    ->from('addresses')
    ->groupBy('addresses.city_id');
  })
->whereNotIn()
->orWhereNotIn()
->whereNull('column')
->orWhereNull('column')
->whereNotNull('column') 
->orWhereNotNull('column') 
->whereDay()
->whereMonth('column', '=', 1) 
->whereYear('column', '>', 2000)
->whereDate('column', '>', '2000-01-01')
```

### Grouping
```php
->groupBy('state_id', 'locality')
->havingRaw('count > 1')
->having('items.name', 'LIKE', "%$keyword%")
```

### Offset and limit 
```php
->take(10)
->limit(10)
->skip(10)
->offset(10)
```
  

### Ordering
```php
->orderBy('id','DESC')
->orderBy(DB::raw('RAND()'))
->latest() // on 'created_at' column
->latest('column')
->oldest() // on 'created_at' column
->oldest('column')
```


## Execute the query 

### Create
```php
->save()
->insert(['email' => 'john@example.com', 'votes' => 0])
->insert([   
    ['email' => 'taylor@example.com', 'votes' => 0],
    ['email' => 'dayle@example.com', 'votes' => 0)]
]) // batch insert
->insertGetId(['email' => 'john@example.com', 'votes' => 0]) // insert and return id
```

### Fetch/Read
```php
->find($id)
->find($id, ['col1','col2'])
->findOrFail($id)
->findMany($ids, $columns)
->first(['col1','col2'])
->firstOrFail()
->all()
->get()
->get(['col1','col2'])
->lists('column') // numeric index
->lists('column','id') // 'id' column as index
->lists('column')->implode('column', ',') // comma separated values of a column
->pluck('column') // Pluck a single column's value from the first result of a query.
->value('column') // Get a single column's value from the first result of a query.
```

### Update
```php
->update(['email' => 'john@example.com'])
->update(['column' => DB::raw('NULL')])
->increment('column')
->decrement('column')
->touch() // update timestamp
```
  
### Delete
```php
->delete()
->forceDelete() // when softdeletes enabled
->destroy($ids) // delete by array of primary keys
->roles()->detach() //delete from pivot table: associated by 'belongsToMany'
```
  
### Aggregate
```php
->count()
->count('column')
->count(DB::raw('distinct column'))
->max('rating')
->min('rating')
->sum('rating')
->avg('rating')
```

### Collection methods
 ```php
->toArray()
->toJson()
->relationsToArray() //Get the model's relationships in array form.
->implode('column', ',') // comma separated values of a column
```

### Misc
```php
->toSql() // output sql query
->exists() // check if any row exists
```