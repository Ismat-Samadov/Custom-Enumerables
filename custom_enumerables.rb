module Enumerable
  # Custom implementation of each method
  def my_each
    return to_enum(__method__) unless block_given?

    index = 0
    while index < size
      yield self[index]
      index += 1
    end
    self
  end

  # Custom implementation of each_with_index method
  def my_each_with_index
    return to_enum(__method__) unless block_given?

    index = 0
    while index < size
      yield self[index], index
      index += 1
    end
    self
  end

  # Custom implementation of select method
  def my_select
    return to_enum(__method__) unless block_given?

    result = []
    my_each { |item| result << item if yield item }
    result
  end

  # Custom implementation of all? method
  def my_all?
    if block_given?
      my_each { |item| return false unless yield item }
    else
      my_each { |item| return false unless item }
    end
    true
  end

  # Custom implementation of any? method
  def my_any?
    if block_given?
      my_each { |item| return true if yield item }
    else
      my_each { |item| return true if item }
    end
    false
  end

  # Custom implementation of none? method
  def my_none?
    if block_given?
      my_each { |item| return false if yield item }
    else
      my_each { |item| return false if item }
    end
    true
  end

  # Custom implementation of count method
  def my_count(item = nil)
    count = 0
    if block_given?
      my_each { |element| count += 1 if yield element }
    elsif item.nil?
      count = size
    else
      my_each { |element| count += 1 if element == item }
    end
    count
  end

  # Custom implementation of map method
  def my_map(proc = nil)
    return to_enum(__method__) unless block_given? || proc

    result = []
    my_each do |item|
      if proc
        result << proc.call(item)
      else
        result << yield(item)
      end
    end
    result
  end

  # Custom implementation of inject method
  def my_inject(initial = nil, sym = nil)
    if block_given?
      accumulator = initial.nil? ? first : initial
      my_each_with_index do |item, index|
        next if index.zero? && initial.nil?

        accumulator = yield(accumulator, item)
      end
      accumulator
    elsif sym
      accumulator = initial.nil? ? first : initial
      my_each do |item|
        accumulator = accumulator.send(sym, item)
      end
      accumulator
    else
      raise LocalJumpError, 'no block given'
    end
  end
end

# Test cases
arr = [1, 2, 3, 4, 5]
puts 'my_each:'
arr.my_each { |item| puts item }

puts 'my_each_with_index:'
arr.my_each_with_index { |item, index| puts "#{index}: #{item}" }

puts 'my_select:'
puts arr.my_select { |item| item.even? }

puts 'my_all?:'
puts arr.my_all?(&:even?)

puts 'my_any?:'
puts arr.my_any?(&:even?)

puts 'my_none?:'
puts arr.my_none?(&:even?)

puts 'my_count:'
puts arr.my_count(&:even?)
puts arr.my_count(2)

puts 'my_map:'
puts arr.my_map { |item| item * 2 }

puts 'my_inject:'
puts arr.my_inject(0) { |sum, item| sum + item }
puts arr.my_inject { |product, item| product * item }
puts arr.my_inject(1, :*)
