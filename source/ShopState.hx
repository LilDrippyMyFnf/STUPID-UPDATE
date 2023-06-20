package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxArrayUtil;
import flixel.input.mouse.FlxMouseEventManager;

class ShopState extends MusicBeatState
{
    private var shopkeeper:FlxSprite;
    private var items:Array<FlxSprite>;
    private var itemTexts:Array<FlxText>;
    private var moneyText:FlxText;
    private var playerMoney:Int;
    
    override public function create():Void
    {
        shopkeeper = new FlxSprite(100, 100);
        shopkeeper.loadGraphic("assets/shopkeeper.png");
        add(shopkeeper);
        
        items = new Array<FlxSprite>();
        itemTexts = new Array<FlxText>();
        var item:FlxSprite;
        var itemText:FlxText;
        
        for(i in 0...5)
        {
            item = new FlxSprite(150 + i * 50, 200);
            item.loadGraphic("assets/item" + i + ".png");
            items.push(item);
            add(item);
            
            itemText = new FlxText(item.x, item.y + item.height, item.width, "Price: " + (i + 1) * 10);
            itemText.setFormat(null, 8, 0xFFFFFF, "center");
            itemTexts.push(itemText);
            add(itemText);
        }
        
        moneyText = new FlxText(0, 0, FlxG.width, "Tri-Coins: 0");
        moneyText.setFormat(null, 8, 0xFFFFFF, "right");
        add(moneyText);
        
        playerMoney = 0;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        // Check if player clicks on an item
        for(i in 0...items.length)
        {
            FlxMouseEventManager.instance.add(items[i], function onMouseDown(e:FlxSprite)
            {
                // Deduct the price of the item from player's money
                if(playerMoney >= (i + 1) * 10)
                {
                    playerMoney -= (i + 1) * 10;
                    moneyText.text = "Tri-Coins: " + playerMoney;
                    
                    // Remove the item from the shop
                    remove(e);
                    items.splice(i, 1);
                    remove(itemTexts[i]);
                    itemTexts.splice(i, 1);
                }
            });
        }

        if (FlxG.keys.justPressed.ESCAPE){
            MusicBeatState.switchState(new MainMenuState());
            FlxG.sound.play(Paths.sound('cancelMenu'));
        }
        
        // Check if player clicks on the shopkeeper to add money
        FlxMouseEventManager.instance.add(shopkeeper, function onMouseDown(e:FlxSprite)
        {
            playerMoney += 10;
            moneyText.text = "Tri-Coins: " + playerMoney;
            trace("bought item with money left: " + playerMoney);
        });
    }
}
