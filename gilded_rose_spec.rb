require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end
  end

  describe 'new features' do
    it 'quality ok' do
      items = [Item.new('foo', 0, 45)]
      expect(items[0].quality).to eq(45)
    end

    it 'sell_in ok' do
      items = [Item.new('foo', 10, 50)]
      expect(items[0].sell_in).to eq(10)
    end

    it 'quality is less than 50 and sell_in is never negative' do
      items = [Item.new('+5 Dexterity Vest',10, 20)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to be > 0
      expect(items[0].quality).to be < 50
    end

    it 'quality increases in 1 if sell_in is more than 10 for Backstage' do
      items = [Item.new(name = 'Backstage passes to a TAFKAL80ETC concert', sell_in = 15, quality = 20)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(14)
      expect(items[0].quality).to eq(21)
    end

    it 'quality increases in 2 if sell_in is more than 5 and less than 10 for Backstage' do
      items = [Item.new(name = 'Backstage passes to a TAFKAL80ETC concert', sell_in = 10, quality = 20)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(9)
      expect(items[0].quality).to eq(22)
    end

    it 'quality increases in 3 if sell_in is more than 0 and less than 5 for Backstage' do
      items = [Item.new(name = 'Backstage passes to a TAFKAL80ETC concert', sell_in = 4, quality = 20)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(3)
      expect(items[0].quality).to eq(23)
    end

    it 'Backstages quality decreases to 0 if sell_in == 0 ' do
      items = [Item.new(name = 'Backstage passes to a TAFKAL80ETC concert', sell_in = 1, quality = 20)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(0)
      expect(items[0].quality).to eq(0)
    end

    it 'Aged Brie increases quality' do
      items = [Item.new(name = 'Aged Brie', sell_in = 2, quality = 0)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(1)
      expect(items[0].quality).to eq(1)
    end

    it 'Sulfuras not decreases quality' do
      items = [Item.new(name = 'Sulfuras, Hand of Ragnaros', sell_in = 0, quality = 80),
               Item.new(name = 'Sulfuras, Hand of Ragnaros', sell_in = 10, quality = 80)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(0)
      expect(items[0].quality).to eq(80)
      expect(items[1].sell_in).to eq(9)
      expect(items[1].quality).to eq(80)
    end

    it 'Cojured decreases quality twice' do
      items = [Item.new(name = 'Conjured Mana Cake', sell_in =  3, quality = 6)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(2)
      expect(items[0].quality).to eq(4)
    end

    it 'Normal items decreases quality' do
      items = [Item.new(name = 'Elixir of the Mongoose', sell_in = 5, quality = 7),
               Item.new(name = '+5 Dexterity Vest', sell_in = 10, quality = 20)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(4)
      expect(items[0].quality).to eq(6)
      expect(items[1].sell_in).to eq(9)
      expect(items[1].quality).to eq(19)
    end
  end
end
