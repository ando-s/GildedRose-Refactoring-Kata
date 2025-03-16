class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items = @items.map(&:update_quality)
  end
end

class Item
  attr_reader :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
    @behavior = ItemBehavior.for(name)
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def update_quality
    @behavior.update(self)
  end
end

class ItemBehavior
  BEHAVIORS = {
    "Aged Brie" => "AgedBrieBehavior",
    "Backstage passes to a TAFKAL80ETC concert" => "BackstagePassBehavior",
    "Sulfuras, Hand of Ragnaros" => "SulfurasBehavior"
  }

  def self.for(name)
    behavior_class = BEHAVIORS.fetch(name, "NormalItemBehavior")
    Object.const_get(behavior_class).new
  end
end

class AgedBrieBehavior
  def update(item)
    new_quality = [item.quality + 1, 50].min
    new_sell_in = item.sell_in - 1
    Item.new(item.name, new_sell_in, new_quality)
  end
end

class BackstagePassBehavior
  def update(item)
    new_quality = item.quality + 1
    new_quality += 1 if item.sell_in < 11
    new_quality += 1 if item.sell_in < 6
    new_quality = 0 if item.sell_in <= 0
    new_quality = [new_quality, 50].min
    new_sell_in = item.sell_in - 1
    Item.new(item.name, new_sell_in, new_quality)
  end
end

class SulfurasBehavior
  def update(item)
    item
  end
end

class NormalItemBehavior
  def update(item)
    new_quality = item.quality - 1
    new_quality -= 1 if item.sell_in <= 0
    new_quality = [new_quality, 0].max
    new_sell_in = item.sell_in - 1
    Item.new(item.name, new_sell_in, new_quality)
  end
end

# Example usage:
items = [
  Item.new("Aged Brie", 10, 20),
  Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 30),
  Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
  Item.new("Normal Item", 15, 25)
]

gilded_rose = GildedRose.new(items)
gilded_rose.update_quality
