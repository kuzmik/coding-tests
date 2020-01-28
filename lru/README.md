# Two solutions

## Ruby Builtins
Ruby maintains the order of a Hash object, so really it could be as simple as something like this:

```ruby
class LRUCache
  attr_accessor :size, :cache

  def initialize(size)
    @size = size
    @cache = {}
  end

  def get(key)
    value = @cache.delete(key)
    unless value.nil?
      @cache[key] = value
    end

    value || -1
  end

  def put(key, value)
    old = @cache.delete(key)

    @cache[key] = value

    @cache.shift if !old && cache.length > @size
  end
end
```

However that probably isn't what the question is really about. So let's use a linked list.
