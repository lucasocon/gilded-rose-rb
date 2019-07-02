class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      item.sell_in.zero? ? (item.sell_in = 0) : (item.sell_in -= 1)
      unless item.name.eql?('Sulfuras, Hand of Ragnaros') # Sulfuras not decreases quality

        if item.name.eql?('Backstage passes to a TAFKAL80ETC concert') && quality_less_than_fifty(item.quality)
          item.quality += 1
          item.quality += 1 if (item.sell_in <= 10 && quality_less_than_fifty(item.quality))
          item.quality += 1 if (item.sell_in <= 5 && quality_less_than_fifty(item.quality))
          item.quality = 0 if item.sell_in.zero?
          next
        end

        if item.name.eql?('Aged Brie') && quality_less_than_fifty(item.quality)
          item.quality += 1 if quality_less_than_fifty(item.quality)
          next
        end

        if item.name.eql?('Conjured Mana Cake')
          item.quality -= 2 unless item.quality.zero?
          next
        end

        item.quality -= 1 unless item.quality.zero?
      end
    end
  end

  def quality_less_than_fifty(quality)
    return true if quality < 50
    false
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = validates_sell_in(sell_in)
    @quality = validates_quality(quality)
  end

  def validates_sell_in(sell_in)
    return 0 if sell_in.negative?
    sell_in
  end

  def validates_quality(quality)
    return 80 if self.name.eql?('Sulfuras, Hand of Ragnaros')
    return 50 if quality > 50
    quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
