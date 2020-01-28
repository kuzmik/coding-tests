# frozen_string_literal: true

require 'pry'

class ListItem
  attr_accessor :key, :value, :next, :previous

  def initialize(key: nil, value: nil)
    @key = key
    @value = value

    @next = nil
    @previous = nil
  end
end

class LRUCache
  attr_reader :size
  attr_reader :cache
  attr_accessor :head, :tail

  def initialize(capacity)
    @size = capacity
    @cache = {}

    @head = ListItem.new
    @tail = ListItem.new

    @head.next = @tail
    @tail.previous = @head
  end

  def put(key, value)
    if @cache.has_key?(key)
      remove_item(@cache[key])
    end

    item = ListItem.new(key: key, value: value)

    self.add_item(item)

    @cache[key] = item

    if @cache.size > @size
      node = @head.next
      remove_item(node)
      @cache.delete(node.key)
    end
  end

  def get(key)
    if @cache.has_key?(key)
      item = @cache[key]
      remove_item(item)
      add_item(item)

      item.value
    else
      -1
    end
  end

  def to_a
    vals = []

    node = head.next
    vals << node.value
    while node.next.value != nil
      node = node.next
      vals << node.value
    end

    vals
  end

  def add_item(list_item)
    # set the new tail to the list_item and move the rest of the cache up
    tmp = @tail.previous
    @tail.previous = list_item
    list_item.next = @tail
    list_item.previous = tmp
    tmp.next = list_item
  end

  def remove_item(list_item)
    prev = list_item.previous
    next_item = list_item.next
    prev.next = next_item
    next_item.previous = prev
  end
end
