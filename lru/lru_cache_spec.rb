# frozen_string_literal: true

require './lru_cache'

RSpec.describe LRUCache do
  it 'returns values properly' do
    cache = described_class.new(2)
    cache.put(1, 1)
    cache.put(2, 2)

    expect(cache.get(1)).to eq(1)
    expect(cache.get(2)).to eq(2)
  end

  it 'evicts the first node when no nodes have been accessed' do
    cache = described_class.new(2)
    cache.put(1, 1)
    cache.put(2, 2)
    cache.put(3, 3)

    expect(cache.get(3)).to eq(3)
    expect(cache.get(1)).to eq(-1)
  end

  it 'evicts the proper node when nodes have been accessed' do
    cache = described_class.new(2)
    cache.put(1, 1)
    cache.put(2, 2)

    expect(cache.get(1)).to eq(1)

    cache.put(3, 3)

    expect(cache.get(3)).to eq(3)
    expect(cache.get(2)).to eq(-1)

    cache.put(4, 4)

    expect(cache.get(1)).to eq(-1)
    expect(cache.get(3)).to eq(3)
    expect(cache.get(4)).to eq(4)

    expect(cache.tail.previous.value).to eq(4)
  end

  it 'can be any size' do
    cache = described_class.new(10)

    (1..10).each do |i|
      cache.put(i, i)
    end

    expect(cache.get(1)).to eq(1)

    cache.put(11, 11)

    expect(cache.get(1)).to eq(1)
    expect(cache.get(2)).to eq(-1)
  end

  it '#to_a returns an array of the cache values' do
    cache = described_class.new(5)

    (1..5).each do |i|
      cache.put(i, i)
    end

    expect(cache.to_a).to eq([1, 2, 3, 4, 5])
  end

  it '#to_a outputs values in the correct order' do
    cache = described_class.new(5)

    (1..5).each do |i|
      cache.put(i, i)
    end

    cache.get(3)

    expect(cache.to_a).to eq([1, 2, 4, 5, 3])
  end

end
